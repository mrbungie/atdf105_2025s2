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

## Estructura del dataset
- Observaciones: 1000
- Variables totales: 21
- Variables numericas: 8
- Variables categoricas: 13
- Variable(s) objetivo reportada(s): class
- Tareas tipicas: Classification

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
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('german_credit.csv')
print(dim(df))
print(head(df))
```

## Archivos en esta carpeta
- `german_credit.csv`
- `README.md`
- `descripcion_datos.md`
