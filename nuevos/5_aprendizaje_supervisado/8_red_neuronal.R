# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "yardstick", "nnet"))

# Cargar librerías necesarias
library(tidyverse)
library(yardstick)  # Para métricas de evaluación
library(nnet)  # Para redes neuronales

# Cargar datos del Titanic
titanic <- read_csv("data/titanic.csv")

# Explorar estructura de los datos
glimpse(titanic)

# Preparar datos para el modelo
# Convertir Survived a factor y manejar valores faltantes
datos_modelo <- titanic %>%
  mutate(
    Survived = as.factor(Survived),
    Sex = as.factor(Sex),
    Pclass = as.factor(Pclass)
  ) %>%
  # Eliminar filas con valores faltantes en variables importantes
  drop_na(Age, Embarked) %>%
  # Seleccionar variables relevantes
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare, Embarked)

# Ver resumen de los datos preparados
summary(datos_modelo)

# Dividir datos en entrenamiento y prueba (80/20)
set.seed(123)
indices <- sample(seq_len(nrow(datos_modelo)), size = 0.8 * nrow(datos_modelo))
entrenamiento <- datos_modelo[indices, ]
prueba <- datos_modelo[-indices, ]

# Preparar datos para la red neuronal (convertir factores a variables dummy)
entrenamiento_nn <- entrenamiento %>%
  mutate(
    Sex_male = as.numeric(Sex == "male"),
    Pclass_2 = as.numeric(Pclass == "2"),
    Pclass_3 = as.numeric(Pclass == "3"),
    Embarked_C = as.numeric(Embarked == "C"),
    Embarked_Q = as.numeric(Embarked == "Q")
  ) %>%
  select(Age, SibSp, Parch, Fare, Sex_male, Pclass_2, Pclass_3, Embarked_C, Embarked_Q)

prueba_nn <- prueba %>%
  mutate(
    Sex_male = as.numeric(Sex == "male"),
    Pclass_2 = as.numeric(Pclass == "2"),
    Pclass_3 = as.numeric(Pclass == "3"),
    Embarked_C = as.numeric(Embarked == "C"),
    Embarked_Q = as.numeric(Embarked == "Q")
  ) %>%
  select(Age, SibSp, Parch, Fare, Sex_male, Pclass_2, Pclass_3, Embarked_C, Embarked_Q)

# Normalizar datos
normalizar <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

entrenamiento_nn_norm <- entrenamiento_nn %>%
  mutate_all(normalizar)

prueba_nn_norm <- prueba_nn %>%
  mutate_all(normalizar)

# Construir modelo de red neuronal (1 capa oculta con 5 neuronas)
modelo <- nnet(Survived ~ Age + SibSp + Parch + Fare + Sex_male + Pclass_2 + Pclass_3 + Embarked_C + Embarked_Q,
               data = cbind(entrenamiento_nn_norm, Survived = entrenamiento$Survived),
               size = 5,
               maxit = 200,
               decay = 0.1)

# Resumen del modelo
print(modelo)

# ===== PREDICCIONES Y MÉTRICAS PARA ENTRENAMIENTO =====
# Hacer predicciones en el conjunto de entrenamiento
predicciones_train <- predict(modelo, newdata = entrenamiento_nn_norm, type = "raw")
predicciones_clase_train <- ifelse(predicciones_train > 0.5, "1", "0") %>%
  as.factor()

# Crear tabla de métricas para entrenamiento
metricas_train <- entrenamiento %>%
  mutate(
    prediccion = predicciones_clase_train,
    probabilidad = as.vector(predicciones_train)
  )

# Calcular accuracy, precision y recall para entrenamiento
accuracy_train <- accuracy(metricas_train, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Entrenamiento")

precision_train <- precision(metricas_train, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Entrenamiento")

recall_train <- recall(metricas_train, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Entrenamiento")

# Combinar métricas de entrenamiento
tabla_metricas_train <- bind_rows(accuracy_train, precision_train, recall_train)

# ===== PREDICCIONES Y MÉTRICAS PARA PRUEBA =====
# Hacer predicciones en el conjunto de prueba
predicciones_test <- predict(modelo, newdata = prueba_nn_norm, type = "raw")
predicciones_clase_test <- ifelse(predicciones_test > 0.5, "1", "0") %>%
  as.factor()

# Crear tabla de métricas para prueba
metricas_test <- prueba %>%
  mutate(
    prediccion = predicciones_clase_test,
    probabilidad = as.vector(predicciones_test)
  )

# Calcular accuracy, precision y recall para prueba
accuracy_test <- accuracy(metricas_test, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Prueba")

precision_test <- precision(metricas_test, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Prueba")

recall_test <- recall(metricas_test, Survived, prediccion) %>%
  select(.metric, .estimator, .estimate) %>%
  rename(Metrica = .metric, Estimador = .estimator, Valor = .estimate) %>%
  mutate(Conjunto = "Prueba")

# Combinar métricas de prueba
tabla_metricas_test <- bind_rows(accuracy_test, precision_test, recall_test)

# ===== TABLA COMPARATIVA DE MÉTRICAS =====
# Combinar y pivotar para comparación
tabla_metricas_completa <- bind_rows(tabla_metricas_train, tabla_metricas_test) %>%
  pivot_wider(names_from = Conjunto, values_from = Valor)

print("=== TABLA DE MÉTRICAS (ENTRENAMIENTO vs PRUEBA) ===")
print(tabla_metricas_completa)

# Matriz de confusión - Entrenamiento
print("\n=== MATRIZ DE CONFUSIÓN - ENTRENAMIENTO ===")
matriz_confusion_train <- metricas_train %>%
  conf_mat(truth = Survived, estimate = prediccion)
print(matriz_confusion_train)

# Matriz de confusión - Prueba
print("\n=== MATRIZ DE CONFUSIÓN - PRUEBA ===")
matriz_confusion_test <- metricas_test %>%
  conf_mat(truth = Survived, estimate = prediccion)
print(matriz_confusion_test)

# Métricas adicionales - Entrenamiento
print("\n=== MÉTRICAS ADICIONALES - ENTRENAMIENTO ===")
cat("Accuracy:", accuracy(metricas_train, Survived, prediccion)$.estimate, "\n")
cat("Precision:", precision(metricas_train, Survived, prediccion)$.estimate, "\n")
cat("Recall:", recall(metricas_train, Survived, prediccion)$.estimate, "\n")

# Métricas adicionales - Prueba
print("\n=== MÉTRICAS ADICIONALES - PRUEBA ===")
cat("Accuracy:", accuracy(metricas_test, Survived, prediccion)$.estimate, "\n")
cat("Precision:", precision(metricas_test, Survived, prediccion)$.estimate, "\n")
cat("Recall:", recall(metricas_test, Survived, prediccion)$.estimate, "\n")

# ===== REPORTE DE CLASIFICACIÓN COMPLETO =====
# Reporte de clasificación para entrenamiento
print("\n=== REPORTE DE CLASIFICACIÓN - ENTRENAMIENTO ===")
reporte_train <- summary(matriz_confusion_train)
print(reporte_train)

# Reporte de clasificación para prueba
print("\n=== REPORTE DE CLASIFICACIÓN - PRUEBA ===")
reporte_test <- summary(matriz_confusion_test)
print(reporte_test)

# Tabla resumen completa de clasificación
tabla_clasificacion <- tibble(
  Conjunto = c("Entrenamiento", "Entrenamiento", "Entrenamiento", 
               "Prueba", "Prueba", "Prueba"),
  Metrica = c("Accuracy", "Precision", "Recall",
              "Accuracy", "Precision", "Recall"),
  Valor = c(
    accuracy(metricas_train, Survived, prediccion)$.estimate,
    precision(metricas_train, Survived, prediccion)$.estimate,
    recall(metricas_train, Survived, prediccion)$.estimate,
    accuracy(metricas_test, Survived, prediccion)$.estimate,
    precision(metricas_test, Survived, prediccion)$.estimate,
    recall(metricas_test, Survived, prediccion)$.estimate
  )
) %>%
  pivot_wider(names_from = Conjunto, values_from = Valor)

print("\n=== TABLA RESUMEN DE CLASIFICACIÓN ===")
print(tabla_clasificacion)

