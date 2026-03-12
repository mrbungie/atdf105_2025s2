# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "Metrics", "caret", "nnet"))

# Cargar librerías necesarias
library(tidyverse)
library(caret)
library(nnet)  # Para redes neuronales
library(Metrics)

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
    Survived = as.numeric(Survived) - 1,  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_train) - 1,  # Convertir a 0/1
    probabilidad = as.vector(predicciones_train)
  )

# ===== PREDICCIONES Y MÉTRICAS PARA PRUEBA =====
# Hacer predicciones en el conjunto de prueba
predicciones_test <- predict(modelo, newdata = prueba_nn_norm, type = "raw")
predicciones_clase_test <- ifelse(predicciones_test > 0.5, "1", "0") %>%
  as.factor()

# Crear tabla de métricas para prueba
metricas_test <- prueba %>%
  mutate(
    Survived = as.numeric(Survived) - 1,  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_test) - 1,  # Convertir a 0/1
    probabilidad = as.vector(predicciones_test)
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