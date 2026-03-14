# Statlog (German Credit Data)

## Grupo asignado
- grupo_5

## Descripcion de dominio
Banca y scoring de credito. Analiza perfiles de clientes para predecir calidad del credito.

## Fuente
- UCI Machine Learning Repository (ID: 144)
- Repositorio: https://archive.ics.uci.edu/dataset/144/statlog+german+credit+data

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Credito_(economia)
- https://es.wikipedia.org/wiki/Banco
- https://es.wikipedia.org/wiki/Modelo_predictivo

## Estructura del dataset
- Observaciones: 1000
- Variables totales: 21
- Variables numericas: 8
- Variables categoricas: 13
- Variable(s) objetivo reportada(s): class
- Tareas tipicas: Classification

## Cobertura de la pauta de diapositivas
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
df = pd.read_csv('german_credit.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `german_credit.csv`
- `README.md`
- `descripcion_datos.md`
