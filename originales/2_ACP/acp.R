# ==========================================================
#        ANÁLISIS DE COMPONENTES PRINCIPALES (ACP) EN R
# ==========================================================
# Este ejercicio utiliza una base de datos proveniente de un test
# aplicado a estudiantes de Educación Parvularia. 
# Se busca construir un modelo predictivo para la variable "Abstracción"
# a partir de las variables de entrada del test.
# ==========================================================


# ==========================================================
# 1. INSTALACIÓN Y CARGA DE LIBRERÍAS
# ==========================================================
# Estas librerías permiten leer datos, manipularlos y visualizar resultados.
# Si no las tienes instaladas, usa install.packages("nombre_paquete")

library(readxl)       # Leer archivos Excel
library(dplyr)        # Manipulación de datos (select, mutate, etc.)
library(ggplot2)      # Visualización gráfica
library(ggcorrplot)   # Correlaciones visuales


# ==========================================================
# 2. IMPORTAR LA BASE DE DATOS
# ==========================================================
# Asegúrate de escribir correctamente la ruta del archivo Excel.
# IMPORTANTE: R no reconoce "\" como separador de carpetas, debes usar "/".
# Ejemplo: "C:\\Documentos\\archivo.xlsx" → "C:/Documentos/archivo.xlsx"

data <- read_excel("BBDD_EPA_NIVELES_ABSTRACCION_CLASS-Minaría_de_datos.xlsx")


# ==========================================================
# 3. TRANSFORMAR VARIABLES CATEGÓRICAS
# ==========================================================
# Convertimos la variable "Modalidad" en binaria:
# 1 = Vespertina, 0 = Diurna
data$Modalidad <- ifelse(data$Modalidad == "Vespertina", 1, 0)


# ==========================================================
# 4. REVISAR ESTRUCTURA DE LOS DATOS
# ==========================================================
# Esto nos permite ver los tipos de datos (numérico, carácter, factor, etc.)
str(data)


# ==========================================================
# 5. TRANSFORMAR VARIABLES EN FACTORES
# ==========================================================
# La variable de salida “Abstracción final” debe ser tratada como un factor
data$`Abstraccion final` <- factor(data$`Abstraccion final`)


# ==========================================================
# 6. CAMBIAR NOMBRES DE VARIABLES (ELIMINAR ESPACIOS)
# ==========================================================
# Esto evita errores de sintaxis en R
data = rename(data, c(
  `Pregunta1` = "Pregunta1",
  `Pregunta2` = "Pregunta2",
  `Rotular` = "Rotular",
  `ReduccionContenido` = "ReduccionContenido",
  `Titulo` = "Titulo",
  `PromedioPreguntas` = "PromedioPreguntas"
))


# ==========================================================
# 7. SEPARAR VARIABLES DE ENTRADA
# ==========================================================
# Seleccionamos las variables que se usarán para el ACP
abs <- select(data, 2:9)


# ==========================================================
# 8. ANÁLISIS DE COMPONENTES PRINCIPALES (ACP)
# ==========================================================
# El ACP busca reducir la dimensionalidad de los datos conservando
# la mayor cantidad posible de varianza (información).


# ----------------------------------------------------------
# 8.1 Correlaciones
# ----------------------------------------------------------
# El primer paso es observar el comportamiento de las variables.
# Lo ideal es que todas estén correlacionadas (valores cercanos a 1 o -1).
cor(abs) %>% round(2)


# ----------------------------------------------------------
# 8.2 Normalización de las variables
# ----------------------------------------------------------
# La normalización elimina las diferencias de escala entre variables.
# Se usa una transformación lineal para llevar todos los valores al rango [0,1].
# Es requisito indispensable antes de aplicar ACP.
norm01 <- function(x) { (x - min(x)) / (max(x) - min(x)) }

# Aplicamos la función a todas las columnas
abs_norm <- data.frame(apply(abs, 2, norm01))

# Verificamos los mínimos y promedios (deben estar entre 0 y 1)
apply(abs_norm, 2, min) %>% round(2)
apply(abs_norm, 2, mean) %>% round(2)


# ----------------------------------------------------------
# 8.3 Ajuste del modelo de ACP
# ----------------------------------------------------------
# prcomp() realiza el cálculo de los componentes principales
acp <- prcomp(abs_norm)
acp  # Mostrará las cargas factoriales y varianza explicada


# ----------------------------------------------------------
# 8.4 Valores de los componentes principales
# ----------------------------------------------------------
# Cada componente principal es una combinación lineal de las variables originales.
# Estos valores representan la posición de cada observación en los nuevos ejes.
acp$x


# ----------------------------------------------------------
# 8.5 Gráfico de sedimentación (Varianza explicada)
# ----------------------------------------------------------
# El gráfico muestra qué cantidad de varianza explica cada componente.
# Permite decidir cuántos componentes conservar (los que más varianza explican).
screeplot(acp, type = "lines")


# ----------------------------------------------------------
# 8.6 Selección de los primeros componentes
# ----------------------------------------------------------
# Se suelen mantener los primeros que explican la mayor parte de la varianza.
cp <- data.frame(acp$x)
cp <- cp[, 1:3]  # Conservamos los tres primeros componentes


# ----------------------------------------------------------
# 8.7 Correlación entre componentes y variables originales
# ----------------------------------------------------------
# Esto permite identificar qué variables están más relacionadas con cada componente.
cor(abs_norm, cp, use = "everything", method = c("pearson"))


# ==========================================================
# 9. INTERPRETACIÓN GENERAL
# ==========================================================
#  - Los componentes principales son combinaciones lineales de las variables originales.
#  - El primer componente (PC1) suele capturar la mayor parte de la varianza total.
#  - Los siguientes componentes explican la variabilidad residual.
#  - Al reducir de n variables originales a pocos componentes,
#    simplificamos el análisis sin perder demasiada información.
#  - Las correlaciones finales nos permiten interpretar qué conjunto
#    de variables están asociadas a cada componente (i.e., patrones o perfiles).
# ==========================================================
