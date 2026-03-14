# Online Shoppers Purchasing Intention Dataset

## Grupo asignado
- grupo_7

## Descripcion de dominio
Comercio electronico y comportamiento del consumidor. Este dataset permite analizar sesiones de navegacion en un sitio de e-commerce para estudiar factores asociados a la intencion de compra.

## Fuente
- UCI Machine Learning Repository (ID: 468)
- Repositorio: https://archive.ics.uci.edu/dataset/468/online+shoppers+purchasing+intention+dataset

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Comercio_electronico
- https://es.wikipedia.org/wiki/Comportamiento_del_consumidor
- https://es.wikipedia.org/wiki/Tasa_de_conversion
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica
- https://es.wikipedia.org/wiki/An%C3%A1lisis_de_grupos

## Sobre el dataset
- Observaciones: 12330
- Variables totales: 18
- Variables numericas: 14
- Variables categoricas: 4
- Variable(s) objetivo reportada(s): Revenue, que indica si la sesion de navegacion termina en compra o no
- Tareas tipicas: Classification, Clustering
- Tarea comun: predecir si una sesion de navegacion en un sitio de e-commerce termina en compra (Revenue) a partir de factores asociados a la sesion
- Preguntas tipicas:
    - ¿Cuales son los factores asociados a una mayor intencion de compra en un sitio de e-commerce? 
    - ¿Existen diferencias en los factores entre sesiones que terminan en compra y sesiones que no terminan en compra?
    - ¿Cual es la distribucion de sesiones que terminan en compra y sesiones que no terminan en compra en el dataset?

## Cobertura de la pauta de diapositivas
- Graficos de barras (categoricas): SI
- Tabla estadistica de numericas: SI
- Histograma + densidad: SI
- Q-Q plot + prueba de normalidad: SI
- Boxplots (outliers y num-vs-cat): SI
- Faltantes por columna: SI
- Matriz de correlacion: SI

## Carga rapida en Python
```python
import pandas as pd
df = pd.read_csv('online_shoppers_purchasing_intention.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `online_shoppers_purchasing_intention.csv`
- `README.md`
- `descripcion_datos.md`
