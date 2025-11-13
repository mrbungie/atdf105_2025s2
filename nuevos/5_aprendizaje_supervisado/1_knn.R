# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "class", "Metrics", "caret"))

# Cargar librerías necesarias
library(tidyverse)
library(class)  # Para KNN
library(caret)
library(Metrics)

# Cargar datos del Titanic
titanic <- read_csv("data/titanic.csv")

# Explorar estructura de los datos
glimpse(titanic)

# Preparar datos para el modelo
# Convertir Survived a factor y manejar valores faltantes
datos_modelo <- titanic %>%
  mutate(
    Survived = as.numeric(Survived),
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

# Preparar datos para KNN (convertir factores a numéricos y normalizar)
entrenamiento_knn <- entrenamiento %>%
  mutate(
    Sex_num = as.numeric(Sex) - 1,
    Pclass_num = as.numeric(Pclass),
  ) %>%
  select(Age, SibSp, Parch, Fare, Sex_num, Pclass_num)

prueba_knn <- prueba %>%
  mutate(
    Sex_num = as.numeric(Sex) - 1,
    Pclass_num = as.numeric(Pclass),
  ) %>%
  select(Age, SibSp, Parch, Fare, Sex_num, Pclass_num)

# Normalizar datos
normalizar <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

entrenamiento_knn_norm <- entrenamiento_knn %>%
  mutate_all(normalizar)

prueba_knn_norm <- prueba_knn %>%
  mutate_all(normalizar)

# Construir modelo KNN (k=5)
k_valor <- 5
predicciones_clase_train <- knn(train = entrenamiento_knn_norm,
                                 test = entrenamiento_knn_norm,
                                 cl = entrenamiento$Survived,
                                 k = k_valor)

predicciones_clase_test <- knn(train = entrenamiento_knn_norm,
                                test = prueba_knn_norm,
                                cl = entrenamiento$Survived,
                                k = k_valor)

# Crear tabla de métricas para entrenamiento
metricas_train <- entrenamiento %>%
  mutate(
    Survived = as.numeric(Survived),  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_train)-1,  # Convertir a 0/1
    probabilidad = NA  # KNN no proporciona probabilidades directamente
  )

# Crear tabla de métricas para prueba
metricas_test <- prueba %>%
  mutate(
    Survived = as.numeric(Survived),  # Convertir a 0/1 para métricas
    prediccion = as.numeric(predicciones_clase_test)-1,  # Convertir a 0/1
    probabilidad = NA  # KNN no proporciona probabilidades directamente
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

