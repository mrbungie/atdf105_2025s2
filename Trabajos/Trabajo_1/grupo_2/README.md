# Automobile

## Grupo asignado
- grupo_2

## Descripcion de dominio
Industria automotriz.  El dataset contiene caracteristicas tecnicas de vehiculos. Permite analizar relacion entre estas caracteristicas y su precio de mercado.

## Fuente
- UCI Machine Learning Repository (ID: 10)
- Repositorio: https://archive.ics.uci.edu/dataset/10/automobile

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Industria_automotriz
- https://es.wikipedia.org/wiki/Precio
- https://es.wikipedia.org/wiki/Regresion_lineal

## Sobre el dataset
- Observaciones: 205
- Variables totales: 26
- Variables numericas: 18
- Variables categoricas: 8
- Variable(s) objetivo reportada(s): symboling, que se relaciona con el riesgo de accidente del vehiculo (-3 a 3, donde -3 es el menos riesgoso y 3 el más riesgoso)
- Tareas tipicas: Regression
- Tarea comun: predecir el precio del vehiculo a partir de sus caracteristicas tecnicas
- Preguntas tipicas: 
    - ¿Cuales son las caracteristicas tecnicas más importantes para predecir el precio del vehiculo? 
    - ¿Existen diferencias en el precio entre diferentes marcas o tipos de vehiculos?
    - ¿Cual es la distribucion de precios de los vehiculos en el dataset?

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
df = pd.read_csv('automobile.csv')
print(df.shape)
print(df.head())
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('automobile.csv')
print(dim(df))
print(head(df))
```

## Archivos en esta carpeta
- `automobile.csv`
- `README.md`
- `descripcion_datos.md`
