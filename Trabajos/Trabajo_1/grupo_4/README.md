# Credit Approval

## Grupo asignado
- grupo_4

## Descripcion de dominio
Riesgo crediticio y decisiones financieras. Se estudian variables de solicitantes para aprobar o rechazar credito.

## Fuente
- UCI Machine Learning Repository (ID: 27)
- Repositorio: https://archive.ics.uci.edu/dataset/27/credit+approval

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Riesgo_crediticio
- https://es.wikipedia.org/wiki/Puntaje_de_credito
- https://es.wikipedia.org/wiki/Clasificacion_binaria

## Estructura del dataset
- Observaciones: 690
- Variables totales: 16
- Variables numericas: 6
- Variables categoricas: 10
- Variable(s) objetivo reportada(s): A16
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
df = pd.read_csv('credit_approval.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `credit_approval.csv`
- `README.md`
- `descripcion_datos.md`
