# Descriptivo.R

# Instalar librerías necesarias
install.packages(c(
  "readxl",
  "dplyr",
  "ggplot2",
  "ggcorrplot",
  "e1071",
  "ROCR",
  "class",
  "rpart",
  "randomForest",
  "reshape",
  "kknn",
  "psych"
))

# Cargar librerías
library(readxl)
library(dplyr)
library(ggplot2)
library(ggcorrplot)
library(e1071)
library(ROCR)
library(class)
library(rpart)
library(randomForest)
library(reshape)
library(kknn)
library(psych)

# Importar datos
data <- read_excel("BBDD_EPA_NIVELES_ABSTRACCION_CLASS.xlsx")

# Ver datos
View(data)
head(data)
summary(data)

# Estadísticos básicos
mean(data$Edad)
median(data$Edad)
range(data$Edad)
min(data$Edad)
max(data$Edad)
var(data$Edad)
sd(data$Edad)
skew(data$Edad)
kurtosis(data$Edad)

# Gráficos descriptivos
boxplot(data$Edad)

tabla_Modalidad <- table(data$Modalidad)
barplot(tabla_Modalidad, xlab = "JORNADA", ylab = "Frecuencia",
        main = "ESTUDIANTES SEGUN JORNADA", col = c(1:2))

hist(data$Edad, main = "HISTOGRAMA EDAD")

# NOTA: Se pueden definir e instanciar variables usando "<-" (= igual funciona pero no es idiomatico)
Tabla_Semestre <- table(data$Semestre)

barplot(Tabla_Semestre, xlab = "SEMESTRE", ylab = "Frecuencia",
        main = "ESTUDIANTES SEGUN SEMESTRE", col = c(1:2))

tabla_Abstraccion <- table(data$`Abstraccion final`)
barplot(tabla_Abstraccion, xlab = "TIPO DE ABSTRACCION", ylab = "Frecuencia",
        main = "ABSTRACCION FINAL", col = c(1:2))

# Matriz de correlaciones
corr <- data.frame(
  ED = data$Edad,
  SE = data$Semestre,
  P1 = data$Pregunta1,
  P2 = data$Pregunta2
)

correlacion <- round(cor(corr), 2)

ggcorrplot(correlacion, hc.order = FALSE,
           outline.col = "white",
           ggtheme = theme_minimal(),
           colors = c("#6D9EC1", "white", "#E46726"),
           lab = TRUE) +
  labs(title = "Correlacion de las Variables",
       subtitle = "Nivel de Respuesta de Encuesta") +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 18, hjust = 0.5)
  )
