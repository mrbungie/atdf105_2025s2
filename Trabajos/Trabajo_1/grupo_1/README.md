# Abalone

## Grupo asignado
- grupo_1

## Descripcion de dominio
Biologia marina y acuicultura. El objetivo habitual es estimar la edad de abalones a partir de medidas fisicas.

## Fuente
- UCI Machine Learning Repository (ID: 1)
- Repositorio: https://archive.ics.uci.edu/dataset/1/abalone

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Haliotis
- https://es.wikipedia.org/wiki/Acuicultura
- https://es.wikipedia.org/wiki/Regresion_lineal

## Estructura del dataset
- Observaciones: 4177
- Variables totales: 9
- Variables numericas: 8
- Variables categoricas: 1
- Variable(s) objetivo reportada(s): Rings
- Tareas tipicas: Classification, Regression

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
df = pd.read_csv('abalone.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `abalone.csv`
- `README.md`
- `descripcion_datos.md`
