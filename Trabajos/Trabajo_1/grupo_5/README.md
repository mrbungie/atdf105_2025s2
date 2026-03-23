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
    'Attribute1': 'checking_account_status',
    'Attribute2': 'duration_months',
    'Attribute3': 'credit_history',
    'Attribute4': 'purpose',
    'Attribute5': 'credit_amount',
    'Attribute6': 'savings_account_status',
    'Attribute7': 'employment_since',
    'Attribute8': 'installment_rate_percent',
    'Attribute9': 'personal_status_and_sex',
    'Attribute10': 'other_debtors',
    'Attribute11': 'residence_since',
    'Attribute12': 'property',
    'Attribute13': 'age',
    'Attribute14': 'other_installment_plans',
    'Attribute15': 'housing',
    'Attribute16': 'number_of_existing_credits',
    'Attribute17': 'job',
    'Attribute18': 'people_liable_for',
    'Attribute19': 'telephone',
    'Attribute20': 'foreign_worker',
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
    checking_account_status = Attribute1,
    duration_months = Attribute2,
    credit_history = Attribute3,
    purpose = Attribute4,
    credit_amount = Attribute5,
    savings_account_status = Attribute6,
    employment_since = Attribute7,
    installment_rate_percent = Attribute8,
    personal_status_and_sex = Attribute9,
    other_debtors = Attribute10,
    residence_since = Attribute11,
    property = Attribute12,
    age = Attribute13,
    other_installment_plans = Attribute14,
    housing = Attribute15,
    number_of_existing_credits = Attribute16,
    job = Attribute17,
    people_liable_for = Attribute18,
    telephone = Attribute19,
    foreign_worker = Attribute20,
    credit_risk = class
  )
```

## Archivos en esta carpeta
- `german_credit.csv`
- `README.md`
- `descripcion_datos.md`
