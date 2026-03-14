# Descripcion de datos: Credit Approval

## Resumen tecnico
- Grupo: grupo_4
- Filas: 690
- Columnas: 16
- Numericas detectadas: 6
- Categoricas detectadas: 10
- Faltantes totales en `credit_approval.csv`: 67

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| A16 | Target | Categorical | no | N/D |
| A15 | Feature | Continuous | no | N/D |
| A14 | Feature | Continuous | yes | N/D |
| A13 | Feature | Categorical | no | N/D |
| A12 | Feature | Categorical | no | N/D |
| A11 | Feature | Continuous | no | N/D |
| A10 | Feature | Categorical | no | N/D |
| A9 | Feature | Categorical | no | N/D |
| A8 | Feature | Continuous | no | N/D |
| A7 | Feature | Categorical | yes | N/D |
| A6 | Feature | Categorical | yes | N/D |
| A5 | Feature | Categorical | yes | N/D |
| A4 | Feature | Categorical | yes | N/D |
| A3 | Feature | Continuous | no | N/D |
| A2 | Feature | Continuous | yes | N/D |
| A1 | Feature | Categorical | yes | N/D |

## Diccionario de variables (con descripcion tentativa)

De ser necesario pueden usar la siguiente descripción tentiva según https://nycdatascience.com/blog/student-works/data-analysis-on-credit-card-approval/

| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| A1 | Feature | Categorical | yes | Gender (e.g., a, b). |
| A2 | Feature | Continuous | yes | Age. |
| A3 | Feature | Continuous | no | Debt (current outstanding debt). |
| A4 | Feature | Categorical | yes | Married (e.g., u, y, l, t). |
| A5 | Feature | Categorical | yes | Bank Customer (e.g., g, p, gg). |
| A6 | Feature | Categorical | yes | Education Level (e.g., c, d, cc, i, j, k, m, r, q, w, x, e, aa, ff). |
| A7 | Feature | Categorical | yes | Ethnicity (e.g., v, h, bb, j, n, z, dd, ff, o). |
| A8 | Feature | Continuous | no | Years Employed. |
| A9 | Feature | Binary | no | Prior Default (t=True, f=False). |
| A10 | Feature | Binary | no | Employed (t=True, f=False). |
| A11 | Feature | Continuous | no | Credit Score. |
| A12 | Feature | Binary | no | Drivers License (t=True, f=False). |
| A13 | Feature | Categorical | no | Citizen (e.g., g, p, s). |
| A14 | Feature | Continuous | yes | Zip Code. |
| A15 | Feature | Continuous | no | Income. |
| A16 | Target | Categorical | no | Approved Status ('+' or '-' / TRUE/FALSE). |