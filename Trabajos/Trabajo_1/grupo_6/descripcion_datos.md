# Descripcion de datos: Census Income

## Resumen tecnico
- Grupo: grupo_6
- Filas: 48842
- Columnas: 15
- Numericas detectadas: 6
- Categoricas detectadas: 9
- Faltantes totales en `census_income.csv`: 2203

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: age
- Para barras categoricas: workclass
- Para boxplot numerica vs categorica: age vs workclass

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| age | Feature | Integer | no | N/A |
| workclass | Feature | Categorical | yes | Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked. |
| fnlwgt | Feature | Integer | no | N/D |
| education | Feature | Categorical | no |  Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool. |
| education-num | Feature | Integer | no | N/D |
| marital-status | Feature | Categorical | no | Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse. |
| occupation | Feature | Categorical | yes | Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces. |
| relationship | Feature | Categorical | no | Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried. |
| race | Feature | Categorical | no | White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black. |
| sex | Feature | Binary | no | Female, Male. |
| capital-gain | Feature | Integer | no | N/D |
| capital-loss | Feature | Integer | no | N/D |
| hours-per-week | Feature | Integer | no | N/D |
| native-country | Feature | Categorical | yes | United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands. |
| income | Target | Binary | no | >50K, <=50K. |
