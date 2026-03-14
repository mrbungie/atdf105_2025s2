# Descripcion de datos: Student Performance

## Resumen tecnico
- Grupo: grupo_8
- Filas: 649
- Columnas: 33
- Numericas detectadas: 16
- Categoricas detectadas: 17
- Faltantes totales en `student_performance.csv`: 0

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: age
- Para barras categoricas: school
- Para boxplot numerica vs categorica: age vs school

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| school | Feature | Categorical | no | student's school (binary: 'GP' - Gabriel Pereira or 'MS' - Mousinho da Silveira) |
| sex | Feature | Binary | no | student's sex (binary: 'F' - female or 'M' - male) |
| age | Feature | Integer | no | student's age (numeric: from 15 to 22) |
| address | Feature | Categorical | no | student's home address type (binary: 'U' - urban or 'R' - rural) |
| famsize | Feature | Categorical | no | family size (binary: 'LE3' - less or equal to 3 or 'GT3' - greater than 3) |
| Pstatus | Feature | Categorical | no | parent's cohabitation status (binary: 'T' - living together or 'A' - apart) |
| Medu | Feature | Integer | no | mother's education (numeric: 0 - none,  1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education) |
| Fedu | Feature | Integer | no | father's education (numeric: 0 - none,  1 - primary education (4th grade), 2 â€“ 5th to 9th grade, 3 â€“ secondary education or 4 â€“ higher education) |
| Mjob | Feature | Categorical | no | mother's job (nominal: 'teacher', 'health' care related, civil 'services' (e.g. administrative or police), 'at_home' or 'other') |
| Fjob | Feature | Categorical | no | father's job (nominal: 'teacher', 'health' care related, civil 'services' (e.g. administrative or police), 'at_home' or 'other') |
| reason | Feature | Categorical | no | reason to choose this school (nominal: close to 'home', school 'reputation', 'course' preference or 'other') |
| guardian | Feature | Categorical | no | student's guardian (nominal: 'mother', 'father' or 'other') |
| traveltime | Feature | Integer | no | home to school travel time (numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour) |
| studytime | Feature | Integer | no | weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours) |
| failures | Feature | Integer | no | number of past class failures (numeric: n if 1<=n<3, else 4) |
| schoolsup | Feature | Binary | no | extra educational support (binary: yes or no) |
| famsup | Feature | Binary | no | family educational support (binary: yes or no) |
| paid | Feature | Binary | no | extra paid classes within the course subject (Math or Portuguese) (binary: yes or no) |
| activities | Feature | Binary | no | extra-curricular activities (binary: yes or no) |
| nursery | Feature | Binary | no | attended nursery school (binary: yes or no) |
| higher | Feature | Binary | no | wants to take higher education (binary: yes or no) |
| internet | Feature | Binary | no | Internet access at home (binary: yes or no) |
| romantic | Feature | Binary | no | with a romantic relationship (binary: yes or no) |
| famrel | Feature | Integer | no | quality of family relationships (numeric: from 1 - very bad to 5 - excellent) |
| freetime | Feature | Integer | no | free time after school (numeric: from 1 - very low to 5 - very high) |
| goout | Feature | Integer | no | going out with friends (numeric: from 1 - very low to 5 - very high) |
| Dalc | Feature | Integer | no | workday alcohol consumption (numeric: from 1 - very low to 5 - very high) |
| Walc | Feature | Integer | no | weekend alcohol consumption (numeric: from 1 - very low to 5 - very high) |
| health | Feature | Integer | no | current health status (numeric: from 1 - very bad to 5 - very good) |
| absences | Feature | Integer | no | number of school absences (numeric: from 0 to 93) |
| G1 | Target | Categorical | no | first period grade (numeric: from 0 to 20) |
| G2 | Target | Categorical | no | second period grade (numeric: from 0 to 20) |
| G3 | Target | Integer | no | final grade (numeric: from 0 to 20, output target) |
