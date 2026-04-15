# install.packages(c("tidyverse", "FNN"))
library(FNN)


# ## 1) Librerias
# Cargamos los paquetes que participan en el flujo de regresión.
# Cada uno aporta algo distinto: lectura de datos, gráficos o el algoritmo del modelo.
library(tidyverse)

# ## 2) Cargar datos
# Leemos el dataset de precios de vivienda y revisamos rápidamente su forma general.
housing <- read_csv("housing.csv", show_col_types = FALSE)

# Vista rápida
# Miramos unas pocas filas para entender qué representa cada columna.
print(head(housing))

# Tipos de columnas
# glimpse() resume el tipo de cada variable y muestra ejemplos de valores.
glimpse(housing)

# ## 3) Preparar datos
# Definimos qué columnas son numéricas, cuáles son categóricas y cuál es la variable objetivo.
variables_a_descartar <- c()
variables_categoricas <- c("CHAS")
variables_numericas <- c(
  "CRIM", "ZN", "INDUS", "NOX", "RM", "AGE",
  "DIS", "RAD", "TAX", "PTRATIO", "B", "LSTAT"
)
variable_dependiente <- "MEDV"

housing <- housing %>%
  mutate(CHAS = as.factor(CHAS))

# Resumen
# summary() ayuda a revisar rangos, medianas y distribución general de las variables.
summary(housing)

X <- housing %>% select(-all_of(c(variable_dependiente, variables_a_descartar)))
y <- housing[[variable_dependiente]]
print(head(y))

# En regresión, la variable dependiente debe ser numérica.
# Aquí nos aseguramos de que el precio se trate como una cantidad continua.
y <- as.numeric(y)

# ## 4) Separar entrenamiento y prueba (80/20)
# Reservamos una parte del dataset para medir qué tan bien generaliza el modelo.
set.seed(42)
indices <- sample(seq_len(nrow(housing)), size = floor(0.8 * nrow(housing)))
entrenamiento <- housing[indices, ]
prueba <- housing[-indices, ]

# Funciones auxiliares de preprocesamiento
# Esta función devuelve la categoría más frecuente.
# La usamos para completar faltantes categóricos sin inventar un valor nuevo.
moda <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Esta función aplica el mismo preprocesamiento a entrenamiento y prueba.
# Es importante calcular parámetros como media, desvío o moda usando SOLO entrenamiento.
preparar_datos <- function(train_df, test_df) {
  train_df <- train_df %>% mutate(CHAS = as.factor(CHAS))
  test_df <- test_df %>% mutate(CHAS = factor(CHAS, levels = levels(train_df$CHAS)))

  # En numéricas usamos la mediana porque resiste mejor valores extremos que el promedio.
  for (col in variables_numericas) {
    mediana <- median(train_df[[col]], na.rm = TRUE)
    train_df[[col]][is.na(train_df[[col]])] <- mediana
    test_df[[col]][is.na(test_df[[col]])] <- mediana
  }

  # En categóricas imputamos con la moda, es decir, la categoría más frecuente.
  for (col in variables_categoricas) {
    valor_moda <- moda(train_df[[col]])
    train_df[[col]][is.na(train_df[[col]])] <- valor_moda
    test_df[[col]][is.na(test_df[[col]])] <- valor_moda
    train_df[[col]] <- droplevels(train_df[[col]])
    test_df[[col]] <- factor(test_df[[col]], levels = levels(train_df[[col]]))
  }

  # Guardamos medias y desvíos del entrenamiento para aplicar exactamente la misma escala en prueba.
  medias <- sapply(train_df[variables_numericas], mean)
  desvios <- sapply(train_df[variables_numericas], sd)
  desvios[desvios == 0 | is.na(desvios)] <- 1

  train_num <- scale(train_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()
  test_num <- scale(test_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()

  train_cat <- model.matrix(~ CHAS, data = train_df) %>% as.data.frame()
  test_cat <- model.matrix(~ CHAS, data = test_df) %>% as.data.frame()

  if ("(Intercept)" %in% names(train_cat)) train_cat <- train_cat %>% select(-`(Intercept)`)
  if ("(Intercept)" %in% names(test_cat)) test_cat <- test_cat %>% select(-`(Intercept)`)

  faltantes <- setdiff(names(train_cat), names(test_cat))
  for (col in faltantes) test_cat[[col]] <- 0
  extra <- setdiff(names(test_cat), names(train_cat))
  if (length(extra) > 0) test_cat <- test_cat %>% select(-all_of(extra))
  test_cat <- test_cat[, names(train_cat), drop = FALSE]

  x_train <- bind_cols(train_num, train_cat)
  x_test <- bind_cols(test_num, test_cat)
  y_train <- train_df[[variable_dependiente]] %>% as.numeric()
  y_test <- test_df[[variable_dependiente]] %>% as.numeric()

  list(x_train = x_train, x_test = x_test, y_train = y_train, y_test = y_test)
}

# Esta función resume el error del modelo con varias métricas complementarias.
# Ninguna métrica cuenta toda la historia por sí sola, por eso conviene leerlas en conjunto.
evaluar_regresion <- function(y_real, y_pred) {
  # MSE penaliza más fuerte los errores grandes porque eleva el residuo al cuadrado.
  mse <- mean((y_real - y_pred)^2)
  # MAE mide el error promedio en la misma escala de la variable objetivo.
  mae <- mean(abs(y_real - y_pred))
  # RMSE vuelve a la escala original y también castiga más los errores grandes.
  rmse <- sqrt(mse)
  # MAPE expresa el error relativo; puede ser inestable si hay valores reales cercanos a cero.
  mape <- mean(abs((y_real - y_pred) / y_real))
  # R2 compara al modelo contra una referencia muy simple: predecir siempre la media.
  r2 <- 1 - sum((y_real - y_pred)^2) / sum((y_real - mean(y_real))^2)
  tibble(MAE = mae, MSE = mse, RMSE = rmse, MAPE = mape, R2 = r2)
}

# Los gráficos ayudan a ver patrones que no aparecen en una tabla.
# Si los residuos muestran estructura, el modelo todavía está dejando información sin capturar.
graficar_resultados <- function(y_real, y_pred, titulo_modelo) {
  resultados <- tibble(real = y_real, predicho = y_pred, residuo = y_real - y_pred)

  print(
    ggplot(resultados, aes(x = real, y = predicho)) +
      geom_point(color = "steelblue", alpha = 0.7) +
      geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
      labs(title = paste("Real vs predicho -", titulo_modelo), x = "Valor real", y = "Valor predicho")
  )

  print(
    ggplot(resultados, aes(x = predicho, y = residuo)) +
      geom_point(color = "firebrick", alpha = 0.7) +
      geom_hline(yintercept = 0, linetype = "dashed") +
      labs(title = paste("Residuos vs predicción -", titulo_modelo), x = "Valor predicho", y = "Residuo")
  )
}

procesados <- preparar_datos(entrenamiento, prueba)
x_train <- procesados$x_train
x_test <- procesados$x_test
y_train <- procesados$y_train
y_test <- procesados$y_test

# ## 5) Variables para KNN (numéricas + estandarización)
# KNN predice usando los vecinos más parecidos del conjunto de entrenamiento.
# Como depende de distancias, escalar las variables es especialmente importante.
# Modelo KNN
k_valor <- 5
pred_train <- knn.reg(train = x_train, test = x_train, y = y_train, k = k_valor)$pred
pred_test <- knn.reg(train = x_train, test = x_test, y = y_train, k = k_valor)$pred

# ## 7) Evaluacion
# Primero comparamos errores en entrenamiento y prueba.
# Luego miramos ejemplos concretos y gráficos para interpretar el ajuste.
# Evaluación
metricas_train <- evaluar_regresion(y_train, pred_train) %>% mutate(Conjunto = "Entrenamiento")
metricas_test <- evaluar_regresion(y_test, pred_test) %>% mutate(Conjunto = "Prueba")
metricas <- bind_rows(metricas_train, metricas_test) %>% relocate(Conjunto)
print(metricas)
print(tibble(Real = y_test, Predicho = pred_test, Residuo = y_test - pred_test) %>% head())
graficar_resultados(y_test, pred_test, "KNN")
