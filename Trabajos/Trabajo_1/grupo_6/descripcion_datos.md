# Descripcion de datos: Diabetes 130-US Hospitals for Years 1999-2008

## Resumen tecnico
- Grupo: grupo_6
- Filas: 101766
- Columnas: 48
- Numericas detectadas: 11
- Categoricas detectadas: 37
- Faltantes totales en `diabetes_hospitals.csv`: 374017

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: admission_type_id
- Para barras categoricas: race
- Para boxplot numerica vs categorica: admission_type_id vs race

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| race | Feature | Categorical | yes | Values: Caucasian, Asian, African American, Hispanic, and other |
| gender | Feature | Categorical | no | Values: male, female, and unknown/invalid |
| age | Feature | Categorical | no | Grouped in 10-year intervals: [0, 10), [10, 20),..., [90, 100) |
| weight | Feature | Categorical | yes | Weight in pounds. |
| admission_type_id | Feature | Categorical | no | Integer identifier corresponding to 9 distinct values, for example, emergency, urgent, elective, newborn, and not available |
| discharge_disposition_id | Feature | Categorical | no | Integer identifier corresponding to 29 distinct values, for example, discharged to home, expired, and not available |
| admission_source_id | Feature | Categorical | no | Integer identifier corresponding to 21 distinct values, for example, physician referral, emergency room, and transfer from a hospital |
| time_in_hospital | Feature | Integer | no | Integer number of days between admission and discharge |
| payer_code | Feature | Categorical | yes | Integer identifier corresponding to 23 distinct values, for example, Blue Cross/Blue Shield, Medicare, and self-pay |
| medical_specialty | Feature | Categorical | yes | Integer identifier of a specialty of the admitting physician, corresponding to 84 distinct values, for example, cardiology, internal medicine, family/general practice, and surgeon |
| num_lab_procedures | Feature | Integer | no | Number of lab tests performed during the encounter |
| num_procedures | Feature | Integer | no | Number of procedures (other than lab tests) performed during the encounter |
| num_medications | Feature | Integer | no | Number of distinct generic names administered during the encounter |
| number_outpatient | Feature | Integer | no | Number of outpatient visits of the patient in the year preceding the encounter |
| number_emergency | Feature | Integer | no | Number of emergency visits of the patient in the year preceding the encounter |
| number_inpatient | Feature | Integer | no | Number of inpatient visits of the patient in the year preceding the encounter |
| diag_1 | Feature | Categorical | yes | The primary diagnosis (coded as first three digits of ICD9); 848 distinct values |
| diag_2 | Feature | Categorical | yes | Secondary diagnosis (coded as first three digits of ICD9); 923 distinct values |
| diag_3 | Feature | Categorical | yes | Additional secondary diagnosis (coded as first three digits of ICD9); 954 distinct values |
| number_diagnoses | Feature | Integer | no | Number of diagnoses entered to the system |
| max_glu_serum | Feature | Categorical | no | Indicates the range of the result or if the test was not taken. Values: >200, >300, normal, and none if not measured |
| A1Cresult | Feature | Categorical | no | Indicates the range of the result or if the test was not taken. Values: >8 if the result was greater than 8%, >7 if the result was greater than 7% but less than 8%, normal if the result was less than 7%, and none if not measured. |
| metformin | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| repaglinide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| nateglinide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| chlorpropamide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glimepiride | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| acetohexamide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glipizide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glyburide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| tolbutamide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| pioglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| rosiglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| acarbose | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| miglitol | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| troglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| tolazamide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| examide | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| citoglipton | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| insulin | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glyburide-metformin | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glipizide-metformin | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| glimepiride-pioglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| metformin-rosiglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| metformin-pioglitazone | Feature | Categorical | no | The feature indicates whether the drug was prescribed or there was a change in the dosage. Values: up if the dosage was increased during the encounter, down if the dosage was decreased, steady if the dosage did not change, and no if the drug was not prescribed |
| change | Feature | Categorical | no | Indicates if there was a change in diabetic medications (either dosage or generic name). Values: change and no change |
| diabetesMed | Feature | Categorical | no | Indicates if there was any diabetic medication prescribed. Values: yes and no |
| readmitted | Target | Categorical | no | Days to inpatient readmission. Values: <30 if the patient was readmitted in less than 30 days, >30 if the patient was readmitted in more than 30 days, and No for no record of readmission. |
