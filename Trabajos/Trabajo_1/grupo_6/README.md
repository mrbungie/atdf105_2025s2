# Census Income

## Grupo asignado
- grupo_6

## Descripcion de dominio
Socioeconomia y mercado laboral. Permite estudiar factores demograficos y laborales asociados al nivel de ingreso.

## Fuente
- UCI Machine Learning Repository (ID: 20)
- Repositorio: https://archive.ics.uci.edu/dataset/20/census+income

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Censo
- https://es.wikipedia.org/wiki/Ingreso
- https://es.wikipedia.org/wiki/Demografia

## Estructura del dataset
- Observaciones: 48842
- Variables totales: 15
- Variables numericas: 6
- Variables categoricas: 9
- Variable(s) objetivo reportada(s): income
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
df = pd.read_csv('census_income.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `census_income.csv`
- `README.md`
- `descripcion_datos.md`
