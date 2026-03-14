# Estimation of Obesity Levels

## Grupo asignado
- grupo_7

## Descripcion de dominio
Salud publica, nutricion y habitos de vida. Relaciona comportamiento alimentario y actividad fisica con niveles de obesidad.

## Fuente
- UCI Machine Learning Repository (ID: 544)
- Repositorio: https://archive.ics.uci.edu/dataset/544/estimation+of+obesity+levels+based+on+eating+habits+and+physical+condition

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Obesidad
- https://es.wikipedia.org/wiki/Nutricion
- https://es.wikipedia.org/wiki/Actividad_fisica
- https://es.wikipedia.org/wiki/Regresion_lineal
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica
- https://es.wikipedia.org/wiki/An%C3%A1lisis_de_grupos

## Estructura del dataset
- Observaciones: 2111
- Variables totales: 17
- Variables numericas: 8
- Variables categoricas: 9
- Variable(s) objetivo reportada(s): NObeyesdad
- Tareas tipicas: Classification, Regression, Clustering

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
df = pd.read_csv('obesity_levels.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `obesity_levels.csv`
- `README.md`
- `descripcion_datos.md`
