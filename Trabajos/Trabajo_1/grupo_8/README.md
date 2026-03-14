# Student Performance

## Grupo asignado
- grupo_8

## Descripcion de dominio
Educacion y analitica academica. El dataset contiene informacion sobre factores sociales, familiares y escolares, y su relacion con el rendimiento estudiantil.

## Fuente
- UCI Machine Learning Repository (ID: 320)
- Repositorio: https://archive.ics.uci.edu/dataset/320/student+performance

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Rendimiento_academico
- https://es.wikipedia.org/wiki/Educacion
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica
- https://es.wikipedia.org/wiki/Regresion_lineal

## Estructura del dataset
- Observaciones: 649
- Variables totales: 33
- Variables numericas: 16
- Variables categoricas: 17
- Variable(s) objetivo reportada(s): G1, G2, G3
- Tareas tipicas: Classification, Regression

## Cobertura de la pauta de diapositivas (i.e. pueden realizarse con este dataset)
- Graficos de barras (categoricas): SI
- Tabla estadistica de numericas: SI
- Histograma + densidad: SI
- Q-Q plot + prueba de normalidad: SI
- Boxplots (outliers y num-vs-cat): SI
- Faltantes por columna: SI (aunque tiene 0 faltantes)
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd
df = pd.read_csv('student_performance.csv')
print(df.shape)
print(df.head())
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('student_performance.csv')
print(dim(df))
print(head(df))
```

## Archivos en esta carpeta
- `student_performance.csv`
- `README.md`
- `descripcion_datos.md`
