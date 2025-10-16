library(tidyverse)

data <- read_delim("bank.csv", delim=";")

# 0. Agregar un ID de fila (para ver duplicados más adelante)
data <- data %>% mutate(row_id = row_number())

# 1. Cambiar tipos a factor
data$job <- as.factor(data$job)
data$marital <- as.factor(data$marital)
data$education <- as.factor(data$education)
data$contact <- as.factor(data$contact)
data$month <- as.factor(data$month)

# 2. Queremos cambiar un tipo de dato por otro
# Cambiaremos el mes a numero
# Usando 
# mutate (mutar una columna en este caso)
# case_when (aplicar cambios segun condiciones)
data <- data %>%
  mutate(month_num = case_when(
    month == "jan" ~ 1,
    month == "feb" ~ 2,
    month == "mar" ~ 3,
    month == "apr" ~ 4,
    month == "may" ~ 5,
    month == "jun" ~ 6,
    month == "jul" ~ 7,
    month == "aug" ~ 8,
    month == "sep" ~ 9,
    month == "oct" ~ 10,
    month == "nov" ~ 11,
    month == "dec" ~ 12,
    TRUE           ~ NA_real_
  ))

# 3. Queremos cambiar todos los yes/no por 0/1 o booleanos
# podemos usar una combinacion de
# mutate (mutar el dataset)
# across (sobre varias columnas)
# ifelse (if else)
# para llevar a cabo este cambio
data <- data %>%
  mutate(across(c(default, housing, loan, y),
                ~ ifelse(. == "yes", TRUE, FALSE)))

# 5. Crear una nueva variable 
data <- data %>%
  mutate(segmento_sociodemo = factor(case_when(
    age < 30 & marital == "single"               ~ "Joven soltero",
    age >= 30 & age < 50 & marital == "married"  ~ "Adulto casado",
    age >= 30 & age < 50 & marital == "single"  ~ "Adulto soltero",
    age >= 50 & marital == "married"             ~ "Senior casado",
    age >= 50 & marital == "single"             ~ "Senior soltero",
    TRUE                                         ~ "Otros"
  )))

summary(data)

# Ejemplo uso segmento_sociodemo
data %>%
  group_by(segmento_sociodemo) %>%        # o cluster3, marital, etc.
  summarise(
    n = n(),                    # número de casos en cada grupo
    mean_balance = mean(balance, na.rm = TRUE)   # promedio de balance
  )

# 6. : duplicados
# Este dataset no los tiene, pero los vamos a generar adrede

# SOLO PARA DUPLICAR
data_duplicada <- data %>%
  bind_rows(slice(., 2))

data_duplicada %>%
  group_by(across(everything())) %>%
  tally() %>%
  filter(n > 1)

# Todos los datos
distinct(data_duplicada, .keep_all = TRUE)

# En base a una o dos columna
data_duplicada %>% distinct(row_id, .keep_all = TRUE)
data_duplicada %>% distinct(row_id, balance, .keep_all = TRUE)

# 7. Filtrar por una variable