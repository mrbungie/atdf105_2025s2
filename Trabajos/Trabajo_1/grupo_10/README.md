# Predict Students' Dropout and Academic Success

## Grupo asignado
- grupo_10

## Descripcion de dominio
Educacion superior y analitica academica. El dataset integra variables personales, socioeconomicas y curriculares para estudiar abandono, permanencia y graduacion.

## Fuente
- UCI Machine Learning Repository (ID: 697)
- Repositorio: https://archive.ics.uci.edu/dataset/697/predict+students+dropout+and+academic+success

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Desercion_escolar
- https://es.wikipedia.org/wiki/Educacion_superior
- https://es.wikipedia.org/wiki/Clasificacion_estadistica
- https://es.wikipedia.org/wiki/Analitica_del_aprendizaje

## Sobre el dataset
- Observaciones: 4424
- Variables totales: 37
- Variables numericas: 36
- Variables categoricas: 1
- Variable(s) objetivo reportada(s): Target
- Tareas tipicas: Classification
- Tarea comun: predecir el estado academico final del estudiante (Target: Dropout, Enrolled o Graduate) a partir de sus caracteristicas
- Preguntas tipicas:
    - Que variables estan mas asociadas al abandono estudiantil?
    - Hay diferencias en variables academicas entre Dropout, Enrolled y Graduate?
    - Como se comportan los indicadores macroeconomicos frente al Target?

## Cobertura de la pauta de diapositivas (i.e. pueden realizarse con este dataset)
- Graficos de barras (categoricas): SI
- Tabla estadistica de numericas: SI
- Histograma + densidad: SI
- Q-Q plot + prueba de normalidad: SI
- Boxplots (outliers y num-vs-cat): SI
- Faltantes por columna: SI (faltantes totales detectados: 0)
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd
df = pd.read_csv('students_dropout_academic_success.csv')
print(df.shape)
print(df.head())
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('students_dropout_academic_success.csv')
print(dim(df))
print(head(df))
```

## Archivos en esta carpeta
- `students_dropout_academic_success.csv`
- `README.md`
- `descripcion_datos.md`
