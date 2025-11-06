# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "yardstick", "bnlearn"))

# Cargar librerías necesarias
library(tidyverse)
library(yardstick)  # Para métricas de evaluación
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

# Dividir datos en entrenamiento y prueba (80/20)
set.seed(123)
indices <- sample(seq_len(nrow(datos_modelo)), size = 0.8 * nrow(datos_modelo))
entrenamiento <- datos_modelo[indices, ]
prueba <- datos_modelo[-indices, ]

# Convertir a formato discreto para redes bayesianas (discretizar variables continuas)
entrenamiento_bn <- entrenamiento %>%
  mutate(
    Age_disc = cut(Age, breaks = c(0, 18, 35, 60, 100), labels = c("Joven", "Adulto", "Maduro", "Mayor")),
    Fare_disc = cut(Fare, breaks = quantile(Fare, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE), 
                    labels = c("Bajo", "Medio", "Alto", "MuyAlto"), include.lowest = TRUE),
    SibSp_disc = ifelse(SibSp == 0, "Ninguno", ifelse(SibSp <= 2, "Pocos", "Muchos")),
    Parch_disc = ifelse(Parch == 0, "Ninguno", ifelse(Parch <= 2, "Pocos", "Muchos"))
  ) %>%
  select(Survived, Pclass, Sex, Age_disc, SibSp_disc, Parch_disc, Fare_disc, Embarked) %>%
  mutate_all(as.factor)

prueba_bn <- prueba %>%
  mutate(
    Age_disc = cut(Age, breaks = c(0, 18, 35, 60, 100), labels = c("Joven", "Adulto", "Maduro", "Mayor")),
    Fare_disc = cut(Fare, breaks = quantile(entrenamiento$Fare, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE), 
                    labels = c("Bajo", "Medio", "Alto", "MuyAlto"), include.lowest = TRUE),
    SibSp_disc = ifelse(SibSp == 0, "Ninguno", ifelse(SibSp <= 2, "Pocos", "Muchos")),
    Parch_disc = ifelse(Parch == 0, "Ninguno", ifelse(Parch <= 2, "Pocos", "Muchos"))
  ) %>%
  select(Survived, Pclass, Sex, Age_disc, SibSp_disc, Parch_disc, Fare_disc, Embarked) %>%
  mutate_all(as.factor)

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

# Obtener probabilidades
predicciones_prob_train <- cpdist(modelo, nodes = "Survived", evidence = TRUE, n = nrow(entrenamiento_bn))
prob_train <- table(predicciones_prob_train) / length(predicciones_prob_train)

# Crear tabla de métricas para entrenamiento
metricas_train <- entrenamiento %>%
  mutate(
    prediccion = predicciones_clase_train,
    probabilidad = ifelse(predicciones_clase_train == "1", 
                         as.numeric(prob_train["1"]), 
                         as.numeric(prob_train["0"]))
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
predicciones_test <- predict(modelo, node = "Survived", data = prueba_bn, method = "bayes-lw")
predicciones_clase_test <- as.factor(predicciones_test)

# Obtener probabilidades
predicciones_prob_test <- cpdist(modelo, nodes = "Survived", evidence = TRUE, n = nrow(prueba_bn))
prob_test <- table(predicciones_prob_test) / length(predicciones_prob_test)

# Crear tabla de métricas para prueba
metricas_test <- prueba %>%
  mutate(
    prediccion = predicciones_clase_test,
    probabilidad = ifelse(predicciones_clase_test == "1", 
                         as.numeric(prob_test["1"]), 
                         as.numeric(prob_test["0"]))
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

