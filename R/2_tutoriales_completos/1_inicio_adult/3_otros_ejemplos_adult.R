library(tidyverse)

# Cargar datos
data <- read_csv("adult.csv", show_col_types = FALSE)

# 1) Informacion basica del dataset
nrow(data)
ncol(data)
names(data)
glimpse(data)

# 2) Introduccion (codigo simple para revisar calidad inicial)
head(data)
summary(data)

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
ggplot(cor_df, aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = round(Freq, 2)), color = "white") +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  theme_minimal()
