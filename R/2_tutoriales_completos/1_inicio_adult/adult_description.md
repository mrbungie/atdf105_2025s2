# Adult Census Income Dataset

> Predice si el ingreso anual de un individuo supera los $50K/año a partir de datos del censo. También conocido como *"Census Income"* dataset.

* Fuente: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Adult)
* Autor: Barry Becker (University of California, Irvine) - Extracted from the 1994 Census database

## Características del Dataset

| Propiedad               | Valor                  |
|-------------------------|------------------------|
| Tipo de dataset         | Multivariado           |
| Área temática           | Ciencias Sociales      |
| Tarea asociada          | Clasificación          |
| Tipos de variables      | Categórica, Entero     |
| N.° de instancias       | 48,842                 |
| N.° de variables        | 14                     |
| Valores faltantes       | Sí                     |

## Información del Dataset

La extracción fue realizada por **Barry Becker** a partir de la base de datos del Censo de 1994. Se extrajeron registros razonablemente limpios usando las siguientes condiciones:

```
(AAGE > 16) && (AGI > 100) && (AFNLWGT > 1) && (HRSWK > 0)
```

El objetivo de predicción es determinar si el ingreso anual de una persona supera los **$50,000**.

## Variables

| Variable         | Rol     | Tipo        | Demográfica      | Descripción                                                                                                                                                             | Valores faltantes |
|------------------|---------|-------------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| `age`            | Feature | Integer     | Edad             | N/A                                                                                                                                                                     | no                |
| `workclass`      | Feature | Categorical | Ingreso          | Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked                                                                  | sí                |
| `fnlwgt`         | Feature | Integer     | —                | Peso final (ponderación censal)                                                                                                                                         | no                |
| `education`      | Feature | Categorical | Nivel educativo  | Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool                | no                |
| `education-num`  | Feature | Integer     | Nivel educativo  | Representación numérica del nivel educativo                                                                                                                             | no                |
| `marital-status` | Feature | Categorical | Otro             | Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse                                                              | no                |
| `occupation`     | Feature | Categorical | Otro             | Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces | sí |
| `relationship`   | Feature | Categorical | Otro             | Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried                                                                                                     | no                |
| `race`           | Feature | Categorical | Raza             | White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black                                                                                                             | no                |
| `sex`            | Feature | Binary      | Sexo             | Female, Male                                                                                                                                                            | no                |
| `capital-gain`	| Feature | Integer     | —                | Ganancia de capital (ingresos por inversiones)                                                                                                                        | no                |
| `capital-loss`	| Feature | Integer     | —                | Pérdida de capital (pérdidas por inversiones)                                                                                                                        | no                |
| `hours-per-week`	| Feature | Integer     | —                | Número de horas trabajadas por semana                                                                                                                                    | no                |
| `native-country`	| Feature | Categorical | Otro             | United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands.	| |	si |
| `income`	| Target  | Binary      | Income	>50K, <=50K. | |		no                |