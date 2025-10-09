# Instalar paquetes
# install.packages(c("tidyverse","skimr"))

library(tidyverse)
library(skimr)
library(ggplot2)

data <- read_csv("adult.csv")

head(data)

# Characters a factores
data$workclass <- as.factor(data$workclass)
data$marital_status <- as.factor(data$marital_status)
data$occupation <- as.factor(data$occupation)
data$relationship <- as.factor(data$relationship)
data$race <- as.factor(data$race)
data$gender <- as.factor(data$gender)
data$native_country <- as.factor(data$native_country)
data$income_status <- as.factor(data$income_status)

# Revision inicial de la data
view(data)
head(data)
tail(data)

describe(data)
skim(data)

# Solo juego previo a descriptiva (i.e. sin hipotesis)
# Par de hipotesis
# Hipotesis 1: La clase trabajadora "Self-emp-inc", tiene mayor propensión a mayores ingresos (i.e. income status >50K)
# NOTA: Se rechaza a p-value < 0.05
# Aplica test χ² (i.e. en palabras simples, las tasas condicionales son indistintas de la no condicional)
# Creamos tabla de contingencia

tab <- table(data$workclass == "Self-emp-inc", data$income_status)

# Tasa no condicional
100 * prop.table(colSums(tab))

# Tasas condicionales
100 * prop.table(tab,1)           # proporción global

# Test χ²
chisq_test_workclass <- chisq.test(tab)
chisq_test_workclass$expected # El mundo esperado de la H0
chisq_test_workclass$observed # El mundo actual
chisq_test_workclass

# Se rechaza hipotesis nula <0.05, la evidencia es estadisticamente significativa.
# El efecto también parece ser importante (i.e. esa marca es suficientemente discriminatoria)

# Hipotesis 2: Aquellos que ganan sobre 50K son más viejos que los que no.
boxplot(age ~ income_status, data = data,
        col = c("lightblue", "lightgreen"),
        main = "Age distribution by Income Group",
        xlab = "Income Status",
        ylab = "Age")

ggplot(data, aes(x = income_status, y = age, fill = income_status)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.1, outlier.shape = NA) +
  labs(title = "Age vs Income Status",
       x = "Income Status", y = "Age") +
  theme_minimal()

t_test_age <- t.test(age ~ income_status, data = data)
t_test_age