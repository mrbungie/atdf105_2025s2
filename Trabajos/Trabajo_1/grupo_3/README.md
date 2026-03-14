# Breast Cancer Wisconsin (Diagnostic)

## Grupo asignado
- grupo_3

## Descripcion de dominio
Salud y apoyo al diagnostico medico. Se usan medidas obtenidas de imagenes para clasificar tumores en benignos o malignos.

## Fuente
- UCI Machine Learning Repository (ID: 17)
- Repositorio: https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Cancer_de_mama
- https://es.wikipedia.org/wiki/Diagnostico_medico
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica

## Estructura del dataset
- Observaciones: 569
- Variables totales: 31
- Variables numericas: 30
- Variables categoricas: 1
- Variable(s) objetivo reportada(s): Diagnosis
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
df = pd.read_csv('breast_cancer_wisconsin_diagnostic.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `breast_cancer_wisconsin_diagnostic.csv`
- `README.md`
- `descripcion_datos.md`
