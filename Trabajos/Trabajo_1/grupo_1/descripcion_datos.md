# Descripcion de datos: Abalone

## Resumen tecnico
- Grupo: grupo_1
- Filas: 4177
- Columnas: 9
- Numericas detectadas: 8
- Categoricas detectadas: 1
- Faltantes totales en `abalone.csv`: 0

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: Length
- Para barras categoricas: Sex
- Para boxplot numerica vs categorica: Length vs Sex

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| Sex | Feature | Categorical | no | M, F, and I (infant) |
| Length | Feature | Continuous | no | Longest shell measurement |
| Diameter | Feature | Continuous | no | perpendicular to length |
| Height | Feature | Continuous | no | with meat in shell |
| Whole_weight | Feature | Continuous | no | whole abalone |
| Shucked_weight | Feature | Continuous | no | weight of meat |
| Viscera_weight | Feature | Continuous | no | gut weight (after bleeding) |
| Shell_weight | Feature | Continuous | no | after being dried |
| Rings | Target | Integer | no | +1.5 gives the age in years |
