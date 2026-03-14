# Credit Approval

## Grupo asignado
- grupo_4

## Descripcion de dominio
Riesgo crediticio y decisiones financieras. El dataset contiene variables de solicitantes para aprobar o rechazar credito. 

NOTA: Este dataset ha sido anonimizado y las variables se nombran como A1, A2, ..., A16 sin una descripcion clara de su significado. Sin embargo, se pueden realizar los analisis exploratorios y visualizaciones solicitados en la pauta utilizando estas variables, aunque no se pueda interpretar su significado real. **ESTO NO TIENE NINGUNA RELEVANCIA FRENTE AL PROYECTO, PERO SE INCLUYEN NOMBRES ALTERNATIVOS SI ES QUE SE PREFIEREN UTILIZAR.**

## Fuente
- UCI Machine Learning Repository (ID: 27)
- Repositorio: https://archive.ics.uci.edu/dataset/27/credit+approval

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Riesgo_crediticio
- https://es.wikipedia.org/wiki/Puntaje_de_credito
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica

## Sobre el dataset
- Observaciones: 690
- Variables totales: 16
- Variables numericas: 6
- Variables categoricas: 10
- Variable(s) objetivo reportada(s): A16, que indica si se aprueba (+) o rechaza (-) un credito
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
- Faltantes por columna: SI (aunque alguna columna puede tener 0 faltantes)
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd

df = pd.read_csv('credit_approval.csv')
print(df.shape)
print(df.head())

# Renombrar columnas para facilitar el trabajo posterior (opcional)
df = df.rename(columns={
    'A1': 'gender',
    'A2': 'age',
    'A3': 'debt',
    'A4': 'married',
    'A5': 'bank_customer',
    'A6': 'education_level',
    'A7': 'ethnicity',
    'A8': 'years_employed',
    'A9': 'prior_default',
    'A10': 'employed',
    'A11': 'credit_score',
    'A12': 'drivers_license',
    'A13': 'citizen',
    'A14': 'zip_code',
    'A15': 'income',
    'A16': 'approved'
})

# Continuar con el análisis exploratorio y visualizaciones utilizando las columnas renombradas....
```

## Carga rapida en R
```R
library(tidyverse)

df <- read_csv('credit_approval.csv')
print(dim(df))
print(head(df))

# Renombrar columnas para facilitar el trabajo posterior (opcional)
df <- df %>%
  rename(
    gender = A1,
    age = A2,
    debt = A3,
    married = A4,
    bank_customer = A5,
    education_level = A6,
    ethnicity = A7,
    years_employed = A8,
    prior_default = A9,
    employed = A10,
    credit_score = A11,
    drivers_license = A12,
    citizen = A13,
    zip_code = A14,
    income = A15,
    approved = A16
  )

# Continuar con el análisis exploratorio y visualizaciones utilizando las columnas renombradas....
```

## Archivos en esta carpeta
- `credit_approval.csv`
- `README.md`
- `descripcion_datos.md`
