# Automobile

## Grupo asignado
- grupo_2

## Descripcion de dominio
Industria automotriz. Permite analizar relacion entre caracteristicas tecnicas del vehiculo y su precio de mercado.

## Fuente
- UCI Machine Learning Repository (ID: 10)
- Repositorio: https://archive.ics.uci.edu/dataset/10/automobile

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Industria_automotriz
- https://es.wikipedia.org/wiki/Precio
- https://es.wikipedia.org/wiki/Analisis_de_regresion

## Estructura del dataset
- Observaciones: 205
- Variables totales: 26
- Variables numericas: 18
- Variables categoricas: 8
- Variable(s) objetivo reportada(s): symboling
- Tareas tipicas: Regression

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
df = pd.read_csv('automobile.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `automobile.csv`
- `README.md`
- `descripcion_datos.md`
