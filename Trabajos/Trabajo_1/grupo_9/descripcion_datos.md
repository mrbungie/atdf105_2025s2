# Descripcion de datos: Bank Marketing

## Resumen tecnico
- Grupo: grupo_9
- Filas: 45211
- Columnas: 17
- Numericas detectadas: 7
- Categoricas detectadas: 10
- Faltantes totales en `bank_marketing.csv`: 52124

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| age | Feature | Integer | no | N/A |
| job | Feature | Categorical | no | type of job (categorical: 'admin.','blue-collar','entrepreneur','housemaid','management','retired','self-employed','services','student','technician','unemployed','unknown') |
| marital | Feature | Categorical | no | marital status (categorical: 'divorced','married','single','unknown'; note: 'divorced' means divorced or widowed) |
| education | Feature | Categorical | no | (categorical: 'basic.4y','basic.6y','basic.9y','high.school','illiterate','professional.course','university.degree','unknown') |
| default | Feature | Categorical | no | has credit in default? |
| balance | Feature | Integer | no | average yearly balance |
| housing | Feature | Categorical | no | has housing loan? |
| loan | Feature | Categorical | no | has personal loan? |
| contact | Feature | Categorical | yes | contact communication type (categorical: 'cellular','telephone') |
| day_of_week | Feature | Integer | no | last contact day of the week |
| month | Feature | Categorical | no | last contact month of year (categorical: 'jan', 'feb', 'mar', ..., 'nov', 'dec') |
| duration | Feature | Integer | no | last contact duration, in seconds (numeric). Important note:  this attribute highly affects the output target (e.g., if duration=0 then y='no'). Yet, the duration is not known before a call is performed. Also, after the end of the call y is obviously known. Thus, this input should only be included for benchmark purposes and should be discarded if the intention is to have a realistic predictive model. |
| campaign | Feature | Integer | no | number of contacts performed during this campaign and for this client (numeric, includes last contact) |
| pdays | Feature | Integer | yes | number of days that passed by after the client was last contacted from a previous campaign (numeric; -1 means client was not previously contacted) |
| previous | Feature | Integer | no | number of contacts performed before this campaign and for this client |
| poutcome | Feature | Categorical | yes | outcome of the previous marketing campaign (categorical: 'failure','nonexistent','success') |
| y | Target | Categorical | no | has the client subscribed a term deposit? |
