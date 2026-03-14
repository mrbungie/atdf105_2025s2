# Diabetes 130-US Hospitals for Years 1999-2008

## Grupo asignado
- grupo_6

## Descripcion de dominio
Salud y gestion hospitalaria. El dataset contiene registros de pacientes diabeticos en hospitales de EE.UU. y permite estudiar factores clinicos y administrativos asociados a resultados de atencion y readmision.

## Fuente
- UCI Machine Learning Repository (ID: 296)
- Repositorio: https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008

## Contexto para profundizar (Wikipedia)
- https://es.wikipedia.org/wiki/Diabetes_mellitus
- https://es.wikipedia.org/wiki/Hospital
- https://es.wikipedia.org/wiki/Reingreso_hospitalario
- https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estad%C3%ADstica
- https://es.wikipedia.org/wiki/An%C3%A1lisis_de_grupos

## Estructura del dataset
- Observaciones: 101766
- Variables totales: 48
- Variables numericas: 11
- Variables categoricas: 37
- Variable(s) objetivo reportada(s): readmitted
- Tareas tipicas: Classification, Clustering

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
df = pd.read_csv('diabetes_hospitals.csv')
print(df.shape)
print(df.head())
```

## Archivos en esta carpeta
- `diabetes_hospitals.csv`
- `README.md`
- `descripcion_datos.md`
