# Bank Marketing

## Grupo asignado
- grupo_9

## Descripcion de dominio
Marketing bancario y analitica comercial. El dataset registra informacion de clientes y contactos de campañas para estudiar la suscripcion a depositos a plazo.

## Fuente
- UCI Machine Learning Repository (ID: 222)
- Repositorio: https://archive.ics.uci.edu/dataset/222/bank+marketing

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Marketing_bancario
- https://es.wikipedia.org/wiki/Deposito_a_plazo_fijo
- https://es.wikipedia.org/wiki/Clasificacion_estadistica
- https://es.wikipedia.org/wiki/Correlacion

## Sobre el dataset
- Observaciones: 45211
- Variables totales: 17
- Variables numericas: 7
- Variables categoricas: 10
- Variable(s) objetivo reportada(s): y
- Tareas tipicas: Classification, Clustering
- Tarea comun: predecir si un cliente se suscribe a un deposito a plazo (y) a partir de variables demograficas, financieras y de contacto
- Preguntas tipicas:
    - Cuales son las caracteristicas mas importantes para estimar la suscripcion a un deposito a plazo?
    - Existen diferencias claras entre clientes que responden yes y no?
    - Como se distribuyen las variables numericas clave segun el resultado y?

## Cobertura de la pauta de diapositivas (i.e. pueden realizarse con este dataset)
- Graficos de barras (categoricas): SI
- Tabla estadistica de numericas: SI
- Histograma + densidad: SI
- Q-Q plot + prueba de normalidad: SI
- Boxplots (outliers y num-vs-cat): SI
- Faltantes por columna: SI (faltantes totales detectados: 52124)
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd
df = pd.read_csv('bank_marketing.csv')
print(df.shape)
print(df.head())
```

## Carga rapida en R
```R
library(tidyverse)
df <- read_csv('bank_marketing.csv')
print(dim(df))
print(head(df))
```

## Archivos en esta carpeta
- `bank_marketing.csv`
- `README.md`
- `descripcion_datos.md`
