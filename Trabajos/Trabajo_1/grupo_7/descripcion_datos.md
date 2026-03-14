# Descripcion de datos: Estimation of Obesity Levels

## Resumen tecnico
- Grupo: grupo_7
- Filas: 2111
- Columnas: 17
- Numericas detectadas: 8
- Categoricas detectadas: 9
- Faltantes totales en `obesity_levels.csv`: 0

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: Age
- Para barras categoricas: Gender
- Para boxplot numerica vs categorica: Age vs Gender

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| Gender | Feature | Categorical | no | N/D |
| Age | Feature | Continuous | no | N/D |
| Height | Feature | Continuous | no | N/D |
| Weight | Feature | Continuous | no | N/D |
| family_history_with_overweight | Feature | Binary | no | Has a family member suffered or suffers from overweight? |
| FAVC | Feature | Binary | no | Do you eat high caloric food frequently? |
| FCVC | Feature | Integer | no | Do you usually eat vegetables in your meals? |
| NCP | Feature | Continuous | no | How many main meals do you have daily? |
| CAEC | Feature | Categorical | no | Do you eat any food between meals? |
| SMOKE | Feature | Binary | no | Do you smoke? |
| CH2O | Feature | Continuous | no | How much water do you drink daily? |
| SCC | Feature | Binary | no | Do you monitor the calories you eat daily? |
| FAF | Feature | Continuous | no | How often do you have physical activity? |
| TUE | Feature | Integer | no | How much time do you use technological devices such as cell phone, videogames, television, computer and others? |
| CALC | Feature | Categorical | no | How often do you drink alcohol? |
| MTRANS | Feature | Categorical | no | Which transportation do you usually use? |
| NObeyesdad | Target | Categorical | no | Obesity level |
