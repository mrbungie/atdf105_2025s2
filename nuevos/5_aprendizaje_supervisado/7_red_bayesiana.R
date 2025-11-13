# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "Metrics", "caret", "bnlearn"))

# Cargar librerías necesarias
library(tidyverse)
library(Metrics)
library(caret)
library(bnlearn)  # Para redes bayesianas

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

# Convertir a formato discreto para redes bayesianas (discretizar variables continuas)
# IMPORTANTE: Hacer esto ANTES de dividir los datos para usar los mismos cortes
datos_modelo_bn <- datos_modelo %>%
  mutate(
    Age_disc = cut(Age, breaks = c(0, 18, 35, 60, 100), labels = c("Joven", "Adulto", "Maduro", "Mayor")),
    Fare_disc = cut(Fare, breaks = quantile(Fare, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE), 
                    labels = c("Bajo", "Medio", "Alto", "MuyAlto"), include.lowest = TRUE),
    SibSp_disc = ifelse(SibSp == 0, "Ninguno", ifelse(SibSp <= 2, "Pocos", "Muchos")),
    Parch_disc = ifelse(Parch == 0, "Ninguno", ifelse(Parch <= 2, "Pocos", "Muchos"))
  ) %>%
  select(Survived, Pclass, Sex, Age_disc, SibSp_disc, Parch_disc, Fare_disc, Embarked) %>%
  mutate_all(as.factor)

# Dividir datos en entrenamiento y prueba (80/20)
set.seed(123)
indices <- sample(seq_len(nrow(datos_modelo_bn)), size = 0.8 * nrow(datos_modelo_bn))
entrenamiento_bn <- datos_modelo_bn[indices, ]
prueba_bn <- datos_modelo_bn[-indices, ]

# También mantener los datos originales para las métricas
entrenamiento <- datos_modelo[indices, ]
prueba <- datos_modelo[-indices, ]

# Asegurar que es data.frame clásico
entrenamiento_bn <- as.data.frame(entrenamiento_bn)
prueba_bn <- as.data.frame(prueba_bn)

# Aprender estructura de la red bayesiana
estructura <- hc(entrenamiento_bn)

# Ajustar parámetros de la red
modelo <- bn.fit(estructura, entrenamiento_bn)

# Resumen del modelo
print(modelo)

# ===== PREDICCIONES Y MÉTRICAS PARA ENTRENAMIENTO =====
# Hacer predicciones en el conjunto de entrenamiento
predicciones_train <- predict(modelo, node = "Survived", data = entrenamiento_bn, method = "bayes-lw")
predicciones_clase_train <- as.factor(predicciones_train)

# Crear tabla de métricas para entrenamiento
metricas_train <- entrenamiento %>%
  mutate(
    Survived = as.numeric(Survived) - 1,  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_train) - 1,  # Convertir a 0/1
    probabilidad = NA  # Las redes bayesianas no proporcionan probabilidades directamente de forma simple
  )

# ===== PREDICCIONES Y MÉTRICAS PARA PRUEBA =====
# Hacer predicciones en el conjunto de prueba
predicciones_test <- predict(modelo, node = "Survived", data = prueba_bn, method = "parents")
predicciones_clase_test <- as.factor(predicciones_test)

# Crear tabla de métricas para prueba
metricas_test <- prueba %>%
  mutate(
    Survived = as.numeric(Survived) - 1,  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_test) - 1,  # Convertir a 0/1
    probabilidad = NA  # Las redes bayesianas no proporcionan probabilidades directamente de forma simple
  )

# Matriz de confusión - Entrenamiento
matriz_confusion_train <- confusionMatrix(data=as.factor(metricas_train$prediccion), 
                                          reference = as.factor(metricas_train$Survived),
                                          positive='1')
matriz_confusion_train

# Matriz de confusión - Testing
matriz_confusion_test <- confusionMatrix(data=as.factor(metricas_test$prediccion), 
                                         reference = as.factor(metricas_test$Survived),
                                         positive='1')
matriz_confusion_test

# Calcular accuracy, precision y recall para entrenamiento
accuracy_train <- accuracy(metricas_train$Survived, metricas_train$prediccion)
accuracy_train

precision_train <- precision(metricas_train$Survived, metricas_train$prediccion)
precision_train

recall_train <- recall(metricas_train$Survived, metricas_train$prediccion)
recall_train

# Calcular accuracy, precision y recall para prueba
accuracy_test <- accuracy(metricas_test$Survived, metricas_test$prediccion)
accuracy_test

precision_test <- precision(metricas_test$Survived, metricas_test$prediccion)
precision_test

recall_test <- recall(metricas_test$Survived, metricas_test$prediccion)
recall_test

# ===== RESUMEN DE MÉTRICAS =====
# Crear tabla resumen de métricas
resumen_metricas <- tibble(
  Metrica = c("Accuracy", "Precision", "Recall"),
  Entrenamiento = c(accuracy_train, precision_train, recall_train),
  Prueba = c(accuracy_test, precision_test, recall_test)
)

print("=== RESUMEN DE MÉTRICAS ===")
print(resumen_metricas)

