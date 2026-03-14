# Statlog (German Credit Data)

## Grupo asignado
- grupo_5

## Descripcion de dominio
Banca y scoring de credito. El dataset contiene informacion sobre perfiles de clientes para predecir la calidad del credito.

## Fuente
- UCI Machine Learning Repository (ID: 144)
- Repositorio: https://archive.ics.uci.edu/dataset/144/statlog+german+credit+data

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Credito_(economia)
- https://es.wikipedia.org/wiki/Banco
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica

## Sobre el dataset
- Observaciones: 1000
- Variables totales: 21
- Variables numericas: 8
- Variables categoricas: 13
- Variable(s) objetivo reportada(s): class, que indica si el credito es bueno (1) o malo (2)
- Tareas tipicas: Classification
- Tarea comun: predecir si se aprueba o rechaza un credito a partir de las caracteristicas del solicitante
- Preguntas tipicas: 
    - ¿Cuales son las caracteristicas más importantes para predecir si se aprueba o rechaza un credito? 
    - ¿Existen diferencias en las caracteristicas entre creditos aprobados y rechazados?
    - ¿Cual es la distribucion de creditos aprobados y rechazados en el dataset?

## Cobertura de la pauta de diapositivas (i.e. pueden realizarse con este dataset)
- Graficos de barras (categoricas): SI
- Tabla estadistica de numericas: SI
- Histograma + densidad: SI
- Q-Q plot + prueba de normalidad: SI
- Boxplots (outliers y num-vs-cat): SI
- Faltantes por columna: SI (no tiene faltantes, pero se puede mostrar la tabla de conteo de faltantes por columna)
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd
df = pd.read_csv('german_credit.csv')
print(df.shape)
print(df.head())

# Es posible renombrar las columnas para facilitar el análisis, aunque no es necesario para cumplir con la pauta de diapositivas. Por ejemplo:
df = df.rename(columns={
    'A1': 'checking_account_status',
    'A2': 'duration_months',
    'A3': 'credit_history',
    'A4': 'purpose',
    'A5': 'credit_amount',
    'A6': 'savings_account_status',
    'A7': 'employment_since',
    'A8': 'installment_rate_percent',
    'A9': 'personal_status_and_sex',
    'A10': 'other_debtors',
    'A11': 'residence_since',
    'A12': 'property',
    'A13': 'age',
    'A14': 'other_installment_plans',
    'A15': 'housing',
    'A16': 'number_of_existing_credits',
    'A17': 'job',
    'A18': 'people_liable_for',
    'A19': 'telephone',
    'A20': 'foreign_worker',
    'class': 'credit_risk'
})
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('german_credit.csv')
print(dim(df))
print(head(df))

# Es posible renombrar las columnas para facilitar el análisis, aunque no es necesario para cumplir con la pauta de diapositivas. Por ejemplo:
df <- df %>%
  rename(
    checking_account_status = A1,
    duration_months = A2,
    credit_history = A3,
    purpose = A4,
    credit_amount = A5,
    savings_account_status = A6,
    employment_since = A7,
    installment_rate_percent = A8,
    personal_status_and_sex = A9,
    other_debtors = A10,
    residence_since = A11,
    property = A12,
    age = A13,
    other_installment_plans = A14,
    housing = A15,
    number_of_existing_credits = A16,
    job = A17,
    people_liable_for = A18,
    telephone = A19,
    foreign_worker = A20,
    credit_risk = class
  )
```

## Archivos en esta carpeta
- `german_credit.csv`
- `README.md`
- `descripcion_datos.md`
