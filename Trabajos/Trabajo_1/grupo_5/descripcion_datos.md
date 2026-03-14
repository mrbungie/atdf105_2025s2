# Descripcion de datos: Statlog (German Credit Data)

## Resumen tecnico
- Grupo: grupo_5
- Filas: 1000
- Columnas: 21
- Numericas detectadas: 8
- Categoricas detectadas: 13
- Faltantes totales en `german_credit.csv`: 0

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: Attribute2
- Para barras categoricas: Attribute1
- Para boxplot numerica vs categorica: Attribute2 vs Attribute1

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| Attribute1 | Feature | Categorical | no | Status of existing checking account |
| Attribute2 | Feature | Integer | no | Duration |
| Attribute3 | Feature | Categorical | no | Credit history |
| Attribute4 | Feature | Categorical | no | Purpose |
| Attribute5 | Feature | Integer | no | Credit amount |
| Attribute6 | Feature | Categorical | no | Savings account/bonds |
| Attribute7 | Feature | Categorical | no | Present employment since |
| Attribute8 | Feature | Integer | no | Installment rate in percentage of disposable income |
| Attribute9 | Feature | Categorical | no | Personal status and sex |
| Attribute10 | Feature | Categorical | no | Other debtors / guarantors |
| Attribute11 | Feature | Integer | no | Present residence since |
| Attribute12 | Feature | Categorical | no | Property |
| Attribute13 | Feature | Integer | no | Age |
| Attribute14 | Feature | Categorical | no | Other installment plans |
| Attribute15 | Feature | Categorical | no | Housing |
| Attribute16 | Feature | Integer | no | Number of existing credits at this bank |
| Attribute17 | Feature | Categorical | no | Job |
| Attribute18 | Feature | Integer | no | Number of people being liable to provide maintenance for |
| Attribute19 | Feature | Binary | no | Telephone |
| Attribute20 | Feature | Binary | no | foreign worker |
| class | Target | Binary | no | 1 = Good, 2 = Bad |
