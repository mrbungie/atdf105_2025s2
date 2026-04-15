# install.packages(c("tidyverse", "caret", "pROC", "class"))
library(class)

# ## 1) Librerias
# Cargamos los paquetes que vamos a usar en el script.
# La idea es que el alumno pueda identificar rapidamente qué biblioteca aporta cada parte del flujo.
library(tidyverse)
library(caret)
library(pROC)

# ## 2) Cargar datos
# Leemos el dataset completo antes de modelar.
# Mirar las primeras filas y la estructura ayuda a detectar columnas, tipos y posibles problemas.
data <- read_csv("titanic.csv", show_col_types = FALSE)

# Vista rapida
# head() permite revisar ejemplos concretos de registros.
print(head(data))

# Tipos de columnas
# glimpse() resume el tipo de cada variable y muestra ejemplos de valores.
glimpse(data)

# ## 3) Preparar datos
# En esta etapa dejamos las variables en un formato que el modelo pueda usar.
# También definimos qué columnas entran al análisis y cuáles conviene excluir.
variables_a_descartar <- c("PassengerId", "Name", "Cabin", "Ticket")
variables_categoricas <- c("Sex", "Embarked")
variables_numericas <- c("Pclass", "Age", "SibSp", "Parch", "Fare")
variables_ordinales <- c()
variable_dependiente <- "Survived"

# Esta función devuelve la categoría más frecuente.
# La usamos para completar faltantes categóricos sin inventar un valor nuevo.
moda <- function(x) {
  x <- x[!is.na(x)]
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Esta función reúne la limpieza básica del dataset:
# convierte tipos, completa faltantes y deja las columnas listas para modelar.
preparar_datos_clasificacion <- function(df) {
  df <- df %>%
    mutate(
      Survived = as.integer(Survived),
      Sex = as.factor(Sex),
      Embarked = as.factor(Embarked)
    )

  # En numéricas usamos la mediana porque resiste mejor valores extremos que el promedio.
  for (col in variables_numericas) {
    mediana <- median(df[[col]], na.rm = TRUE)
    df[[col]][is.na(df[[col]])] <- mediana
  }

  # En categóricas imputamos con la moda, es decir, la categoría más frecuente.
  for (col in variables_categoricas) {
    valor_moda <- moda(df[[col]])
    df[[col]][is.na(df[[col]])] <- valor_moda
    df[[col]] <- as.factor(df[[col]])
  }

  df
}

# Esta función construye la matriz final que recibe el modelo.
# Estandarizamos variables numéricas y codificamos las categóricas en columnas binarias.
generar_matriz_modelo <- function(train_df, test_df) {
  # Guardamos medias y desvíos del entrenamiento para aplicar exactamente la misma escala en prueba.
  medias <- sapply(train_df[variables_numericas], mean)
  desvios <- sapply(train_df[variables_numericas], sd)
  desvios[is.na(desvios) | desvios == 0] <- 1

  train_num <- scale(train_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()
  test_num <- scale(test_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()

  # model.matrix transforma factores en variables indicadoras (dummies).
  train_cat <- model.matrix(~ Sex + Embarked, data = train_df) %>% as.data.frame()
  test_cat <- model.matrix(~ Sex + Embarked, data = test_df) %>% as.data.frame()

  if ("(Intercept)" %in% names(train_cat)) train_cat <- train_cat %>% select(-`(Intercept)`)
  if ("(Intercept)" %in% names(test_cat)) test_cat <- test_cat %>% select(-`(Intercept)`)

  faltantes <- setdiff(names(train_cat), names(test_cat))
  for (col in faltantes) test_cat[[col]] <- 0
  extras <- setdiff(names(test_cat), names(train_cat))
  if (length(extras) > 0) test_cat <- test_cat %>% select(-all_of(extras))
  test_cat <- test_cat[, names(train_cat), drop = FALSE]

  x_train <- bind_cols(train_num, train_cat)
  x_test <- bind_cols(test_num, test_cat)
  y_train_num <- train_df[[variable_dependiente]]
  y_test_num <- test_df[[variable_dependiente]]
  y_train_factor <- factor(y_train_num, levels = c(0, 1))
  y_test_factor <- factor(y_test_num, levels = c(0, 1))

  list(
    x_train = x_train,
    x_test = x_test,
    y_train_num = y_train_num,
    y_test_num = y_test_num,
    y_train_factor = y_train_factor,
    y_test_factor = y_test_factor
  )
}

# Algunos modelos devuelven probabilidades con formatos distintos.
# Esta función intenta dejar siempre la probabilidad de la clase positiva en un vector numérico.
extraer_probabilidad_positiva <- function(prob_obj) {
  if (is.null(prob_obj)) {
    return(NULL)
  }

  if (is.vector(prob_obj)) {
    return(as.numeric(prob_obj))
  }

  if (is.matrix(prob_obj) || is.data.frame(prob_obj)) {
    cols <- colnames(prob_obj)
    if (!is.null(cols) && "1" %in% cols) {
      return(as.numeric(prob_obj[, "1"]))
    }
    return(as.numeric(prob_obj[, ncol(prob_obj)]))
  }

  NULL
}

# Esta función resume la evaluación del clasificador.
# Calcula métricas básicas y, cuando hay probabilidades, también el AUROC y la curva ROC.
evaluar_clasificacion <- function(y_real, y_pred_class, y_pred_prob = NULL, nombre = "Conjunto") {
  y_real_factor <- factor(y_real, levels = c(0, 1))
  y_pred_factor <- factor(y_pred_class, levels = c(0, 1))

  cm <- confusionMatrix(data = y_pred_factor, reference = y_real_factor, positive = "1")
  print(cm)

  # Accuracy mide el porcentaje total de aciertos.
  accuracy <- mean(y_real == y_pred_class)
  # Precision responde: de todo lo que el modelo marcó como clase 1, ¿cuánto era correcto?
  precision <- if (sum(y_pred_class == 1) == 0) 0 else sum(y_real == 1 & y_pred_class == 1) / sum(y_pred_class == 1)
  # Recall responde: de todos los casos realmente positivos, ¿cuántos detectó el modelo?
  recall <- if (sum(y_real == 1) == 0) 0 else sum(y_real == 1 & y_pred_class == 1) / sum(y_real == 1)
  auroc <- NA_real_

  if (!is.null(y_pred_prob) && length(unique(y_real)) > 1) {
    roc_obj <- roc(response = y_real, predictor = y_pred_prob, quiet = TRUE, levels = c(0, 1), direction = "<")
    auroc <- as.numeric(auc(roc_obj))
    plot(roc_obj, main = paste("Curva ROC -", nombre))
  }

  tibble(
    Conjunto = nombre,
    Accuracy = accuracy,
    Precision = precision,
    Recall = recall,
    AUROC = auroc
  )
}

# Aplicamos la limpieza completa antes del split para mantener una lógica clara en el ejemplo.
data <- preparar_datos_clasificacion(data)

# Resumen
# summary() ayuda a revisar rangos, medianas y distribución general de las variables.
print(summary(data))

X <- data %>% select(-all_of(c(variable_dependiente, variables_a_descartar)))
y <- data[[variable_dependiente]]
print(head(y))

# Puede que su variable dependiente no esté en formato numérico.
# Muchos algoritmos y métricas esperan 0/1 de manera explícita.
# En ese caso, conviértanla antes de entrenar.
y <- as.integer(y)

# ## 4) Separar entrenamiento y prueba (80/20)
# Separamos los datos para evaluar al modelo en ejemplos no vistos durante el entrenamiento.
set.seed(42)
indices <- sample(seq_len(nrow(data)), size = floor(0.8 * nrow(data)))
entrenamiento <- data[indices, ]
prueba <- data[-indices, ]

procesados <- generar_matriz_modelo(entrenamiento, prueba)
x_train <- procesados$x_train
x_test <- procesados$x_test
y_train_num <- procesados$y_train_num
y_test_num <- procesados$y_test_num
y_train_factor <- procesados$y_train_factor
y_test_factor <- procesados$y_test_factor

# En Python usamos un umbral basado en la proporción observada de la clase positiva.
# Eso evita decidir siempre con 0.5 cuando las clases están desbalanceadas.
umbral <- mean(y_train_num)

# ## 5) Variables para KNN (numericas + codificacion simple)
# Este modelo es un clasificador KNN con 5 vecinos.
# Hiperparametros a ajustar: n_neighbors, metric, weights.
pred_train_factor <- knn(train = x_train, test = x_train, cl = y_train_factor, k = 5, prob = TRUE)
prob_train_attr <- attr(pred_train_factor, "prob")
y_train_pred <- ifelse(pred_train_factor == "1", prob_train_attr, 1 - prob_train_attr)
y_train_pred_class <- as.integer(as.character(pred_train_factor))

pred_test_factor <- knn(train = x_train, test = x_test, cl = y_train_factor, k = 5, prob = TRUE)
prob_test_attr <- attr(pred_test_factor, "prob")
y_test_pred <- ifelse(pred_test_factor == "1", prob_test_attr, 1 - prob_test_attr)
y_test_pred_class <- as.integer(as.character(pred_test_factor))

# ## 6) Entrenar y predecir
# Aquí el modelo ya produce salidas tanto para entrenamiento como para prueba.
# Comparar ambos conjuntos ayuda a detectar sobreajuste.
# Ajustar modelo

# Prediccion entrenamiento

# Prediccion prueba

# ## 7) Evaluacion
# Revisamos la matriz de confusión y luego resumimos métricas comparables entre modelos.
cat("
=== Matriz de confusion entrenamiento ===
")
metricas_train <- evaluar_clasificacion(y_train_num, y_train_pred_class, y_train_pred, "Entrenamiento")

cat("
=== Matriz de confusion prueba ===
")
metricas_test <- evaluar_clasificacion(y_test_num, y_test_pred_class, y_test_pred, "Prueba")

print("=== Resumen de métricas ===")
print(bind_rows(metricas_train, metricas_test))
