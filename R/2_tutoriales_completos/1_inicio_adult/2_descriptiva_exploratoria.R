# Instalar paquetes
# install.packages(c("tidyverse","skimr","hexbin"))

library(tidyverse)
library(skimr)
library(ggplot2)
library(scales)

data <- read_csv("adult.csv")

head(data)

# Characters a factores
data$workclass <- as.factor(data$workclass)
data$`marital-status` <- as.factor(data$`marital-status`)
data$occupation <- as.factor(data$occupation)
data$relationship <- as.factor(data$relationship)
data$race <- as.factor(data$race)
data$sex <- as.factor(data$sex)
data$`native-country` <- as.factor(data$`native-country`)
data$`income-status` <- as.factor(data$`income-status`)

# Documentación ggplot
# https://www.epirhandbook.com/es/new_pages/ggplot_basics.es.html
# 
# Ideas para graficos
# https://www.justinmind.com/es/blog/visualizacion-datos-ejemplos-principios/
# https://www.datacamp.com/es/blog/data-visualization-techniques

# Tutorial de exploración

# Revision inicial de la data
view(data)
head(data)
tail(data)

skim(data)

# factor × factor (Categorico vs Categorico)
# 1A) Barras apiladas al 100% (muestra proporciones fila a fila)
ggplot(data, aes(x = workclass, fill = income_status)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent) +
  labs(title = "Income split within each workclass",
       x = "Workclass", y = "Share") +
  theme_minimal()

# 1B) Barras lado a lado (frecuencias absolutas)
ggplot(data, aes(x = workclass, fill = income_status)) +
  geom_bar(position = position_dodge(width = 0.7)) +
  labs(title = "Counts by workclass × income",
       x = "Workclass", y = "Count") +
  theme_minimal()

# 1C) Heatmap de la tabla de contingencia (cuentas absolutas)
data %>%
  count(workclass, income_status) %>%
  ggplot(aes(workclass, income_status, fill = n)) +
  geom_tile() +
  geom_text(aes(label = n), color = "white") +
  labs(title = "Contingency heatmap: workclass × income", fill = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

## 2) Factor × Numérico (comparar una variable numérica entre grupos)
# 2A) Boxplot clásico
ggplot(data, aes(x = income_status, y = age, fill = income_status)) +
  geom_boxplot(outlier.alpha = 0.4) +
  labs(title = "Distribución de edad según ingresos",
       x = "Ingresos", y = "Edad") +
  theme_minimal() +
  theme(legend.position = "none")

# 2B) Violín con boxplot embebido (muestra forma + resumen)
ggplot(data, aes(x = workclass, y = `hours-per-week`, fill = workclass)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.12, outlier.shape = NA) +
  labs(title = "Horas trabajadas por semana según clase laboral",
       x = "Clase laboral", y = "Horas/semana") +
  theme_minimal() +
  theme(legend.position = "none")

# 2C) Densidad superpuesta (útil para comparar 2–3 grupos)
ggplot(data, aes(x = age, fill = income_status)) +
  geom_density(alpha = 0.35, adjust = 1) +
  labs(title = "Densidad de edades por grupo de ingresos",
       x = "Edad", y = "Densidad") +
  theme_minimal()

## 🔹 3) Numérico × Numérico (relaciones entre dos variables numéricas)

# 3A) Dispersión simple con recta de regresión
ggplot(data, aes(x = age, y = `capital-gain`)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Capital vs Edad", x = "Edad", y = "Capital") +
  theme_minimal()

# 3B) Dispersión coloreada por un factor (ej: ingresos)
ggplot(data, aes(x = age, y = `hours-per-week`, color = income_status)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  labs(title = "Horas/semana vs Edad por nivel de ingreso",
       x = "Edad", y = "Horas/semana") +
  theme_minimal()

# 3C) Alta densidad: binning 2D (rectángulos)
ggplot(data, aes(x = age, y = `capital-gain`)) +
  geom_bin2d() +
  scale_fill_viridis_c() +
  labs(title = "Mapa de densidad 2D (binning rectangular)",
       x = "Edad", y = "Capital", fill = "Cuenta") +
  theme_minimal()

# 3D) Alta densidad: hexbin (requiere librería hexbin)
# install.packages("hexbin")
library(hexbin)
ggplot(data, aes(x = age, y = `capital-gain`)) +
  geom_hex() +
  scale_fill_viridis_c() +
  labs(title = "Mapa de densidad hexagonal",
       x = "Edad", y = "Capital", fill = "Cuenta") +
  theme_minimal()

# 3E) Alta densidad: contornos de densidad (KDE 2D)
ggplot(data, aes(x = age, y = `capital-gain`)) +
  stat_density_2d(aes(fill = after_stat(level)), geom = "polygon", alpha = 0.7) +
  scale_fill_viridis_c() +
  labs(title = "Contornos de densidad 2D (KDE)",
       x = "Edad", y = "Capital", fill = "Densidad") +
  theme_minimal()
