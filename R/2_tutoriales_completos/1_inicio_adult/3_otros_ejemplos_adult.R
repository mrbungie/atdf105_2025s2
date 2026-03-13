library(tidyverse)

# Cargar datos
data <- read_csv("adult.csv", show_col_types = FALSE, na=c("","?"))

# 1) Informacion basica del dataset
nrow(data)
ncol(data)
names(data)

# 1b) Tipos de datos
glimpse(data)
# chr: caracteres
# dbl: double/numerico

# NOTA: Ojo que no siempre los tipos de datos estan alineados con la esencia de la variable, 
# por ejemplo, "education-num" es un entero pero representa un ordinal (nivel educativo como número con orden)
# por lo que se podria convertir a factor (en R) o a categoria (en Python). Por esto es importante
# revisar: 
# 1) la documentacion del dataset si es que existe, y
# 2) inspeccionar cada variable a detalle para entender su naturaleza y decidir el tipo de dato mas adecuado para cada una.

# 2) Introduccion (codigo simple para revisar calidad inicial)
head(data)
summary(data)

# 2b) Transformamos a los tipos correctos:
# Characters a factores (factores = categorias en R)
data$workclass <- as.factor(data$workclass)
data$`marital-status` <- as.factor(data$`marital-status`)
data$occupation <- as.factor(data$occupation)
data$relationship <- as.factor(data$relationship)
data$race <- as.factor(data$race)
data$sex <- as.factor(data$sex)
data$`native-country` <- as.factor(data$`native-country`)
data$`income_status` <- as.factor(data$`income_status`)
data$`education-num` <- as.factor(data$`education-num`)


# 3) Objetivos del estudio (ejemplo: definir variables de trabajo)
vars_categoricas <- data %>% select(where(is.character), where(is.factor)) %>% names()
vars_numericas   <- data %>% select(where(is.numeric)) %>% names()
print("Variables categoricas:" )
print(vars_categoricas)
print("Variables numericas:" )
print(vars_numericas)

# 4) Descripcion del conjunto de datos
data %>% summarise(across(all_of(vars_numericas), ~ sum(!is.na(.))))

# 5) Variable categorica: grafico de barras
ggplot(data, aes(x = workclass)) +
  geom_bar(fill = "steelblue") +
  labs(x = "workclass", y = "Frecuencia") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# 6) Tabla de medidas para variables numericas
data %>%
  select(all_of(vars_numericas)) %>%
  summary()

# 7) Histograma + densidad para variable continua (age)
ggplot(data, aes(x = age)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "skyblue", color = "white") +
  geom_density(color = "red", linewidth = 1) +
  theme_minimal()

# 8) Normalidad (Q-Q + Shapiro)
qqnorm(data$age)
qqline(data$age, col = "red")

set.seed(123)
age_sample <- sample(data$age, size = min(5000, length(data$age)))
shapiro.test(age_sample)
# Shapiro: si el p-value es menor al threshold (comúnmente 0.05), se rechaza la normalidad,
# indicando que la distribución de la variable se desvía significativamente de una distribución normal.
# Sin embargo, en datasets grandes, incluso pequeñas desviaciones pueden 
# resultar en un p-value significativo, por lo que es importante complementar con gráficos y 
# medidas de asimetría y curtosis para obtener una comprensión más completa de la distribución de la variable.

# 9) Datos atipicos (boxplot)
ggplot(data, aes(y = age)) +
  geom_boxplot(fill = "orange") +
  theme_minimal()

# 10) Numerica vs categorica (boxplot)
ggplot(data, aes(x = income_status, y = age, fill = income_status)) +
  geom_boxplot() +
  theme_minimal() +
  theme(legend.position = "none")

# 11a) Faltantes por columna (tabla)
# NOTA: Este dataset no tiene faltantes, pero se muestra el codigo para que lo puedan usar en otros casos
faltantes <- data %>%
  summarise(across(everything(), ~ mean(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "prop_na")
faltantes$porcentaje <- faltantes$prop_na * 100
faltantes$totales <- faltantes$prop_na * nrow(data)
faltantes

# 11b) Grafico de faltantes por columna
ggplot(faltantes, aes(x = reorder(variable, -prop_na), y = prop_na)) +
  geom_col(fill = "purple") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 12) Matriz de correlacion
cor_mat <- data %>%
  select(all_of(vars_numericas)) %>%
  cor(use = "complete.obs")

round(cor_mat, 2)

cor_df <- as.data.frame(as.table(cor_mat))
cor_df %>%
  filter(Var1 != Var2) %>%
  ggplot(aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = round(Freq, 2)), color = "black") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  theme_minimal()
