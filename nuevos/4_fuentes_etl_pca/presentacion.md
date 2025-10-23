Perfecto, Germán.
Acá tienes la **versión consolidada completa** —lista para llevar a **slides** (PowerPoint o Quarto)— que une todos los elementos del módulo AE2:

* **Fuentes de información (Leal, 2021)**
* **ETL / Data Warehouse**
* **Tratamiento de datos ruidosos y anómalos**
* **Aplicación práctica en R (caso solar + PCA)**

Sin quiz, enfocada en contenido docente narrativo y coherente con los controles y la solemne (AE 2.1 → 2.3).
Es la secuencia ideal para una sesión de **90 min (15 + 40 + 35)**.

---

# 🎞️ SLIDE DECK – AE2: De las fuentes al análisis de datos

---

### **Slide 1 – Título y objetivos de la sesión**

**Título:** *Del dato a la decisión: Fuentes de información, ETL y análisis de datos con R*

**Objetivos:**

* Reconocer los tipos de **fuentes de información** y su confiabilidad.
* Comprender el rol del **ETL y Data Warehouse** en la minería de datos.
* Aplicar procedimientos de **limpieza y tratamiento de anomalías**.
* Observar un **análisis de componentes principales (PCA)** en un caso real de energía solar.

**Nota docente:** Conecta directamente con AE 2.1–2.3 del programa.

---

### **Slide 2 – Fuentes de información (Leal 2021)**

> Instrumentos o recursos que satisfacen una necesidad informativa.
> Su objetivo: permitir localizar y validar la información adecuada.

**Clasificación:**

| Tipo            | Características                | Ejemplos                                  |
| --------------- | ------------------------------ | ----------------------------------------- |
| **Primarias**   | Información original, directa  | Entrevistas, sensores SCADA, experimentos |
| **Secundarias** | Derivadas de fuentes primarias | Libros, informes, bases de datos externas |
| **Terciarias**  | Remiten a fuentes secundarias  | Catálogos, índices, directorios           |

**Importancia:** elegir el nivel adecuado según el problema a resolver.

---

### **Slide 3 – Valor y confiabilidad de las fuentes**

Una fuente es valiosa si:

* Proporciona información **útil y pertinente**.
* Su contenido proviene de **expertos o instituciones reconocidas**.

**Criterios de validación (Leal):**

* **Actualidad:** verificar la fecha de elaboración.
* **Objetividad:** ausencia de juicios de valor.

**Ejemplo:**

* Datos SCADA 2024 ✅ (actuales y directos).
* Blog sin autoría ❌ (no confiable).

---

### **Slide 4 – Del dato a la información: proceso ETL**

```
Fuentes  →  ETL (Extract – Transform – Load)  →  Data Warehouse  →  Análisis
```

| Etapa             | Acción                                 | Caso solar                        |
| ----------------- | -------------------------------------- | --------------------------------- |
| **E – Extract**   | Extrae datos de fuentes diversas       | Sensores SCADA, API meteorológica |
| **T – Transform** | Limpieza, homogeneización, integración | Unificar unidades, imputar NA     |
| **L – Load**      | Carga en repositorio analítico         | `solar_efficiency.csv`            |

**Nota docente:** Las *bases de datos* y *DW* son repositorios, no fuentes de información.

---

### **Slide 5 – Data Warehouse (DW)**

* Arquitectura de almacenamiento para análisis y toma de decisiones.
* Integra información histórica y heterogénea (ERP, CRM, sensores, archivos).
* Diseños comunes: **modelo estrella** y **snowflake**.
* Permite construir *datamarts* por área (finanzas, energía, clientes).

**Propiedades del DW:**

* Orientado a temas.
* Integrado.
* No volátil.
* Variante en el tiempo.

---

### **Slide 6 – Caso Solar Andes S.A. (contexto práctico)**

**Situación:**
La empresa opera dos plantas fotovoltaicas en el norte de Chile.
Un *data engineer* integró datos de:

* SCADA (primaria) → potencia AC/DC, alarmas.
* API meteorológica (secundaria) → radiación, temperatura, humedad.
* Documentos técnicos (terciaria) → coeficiente térmico ( α = –0.0045 / °C ).

**Resultado ETL:** `solar_efficiency.csv`
Variables clave:
• `ambient_temp`, `module_temp`, `irradiation`
• `temp_diff_module_ambient`, `temp_excess`
• `efficiency_kwh_kwp`, `total_dc_power`, `total_ac_power`

**Hipótesis de trabajo:**
1️⃣ La temperatura de módulo reduce la eficiencia.
2️⃣ Radiación y temperatura explican la mayor varianza del rendimiento.

---

### **Slide 7 – Tratamiento de datos ruidosos y anómalos (AE 2.2)**

> Los valores anómalos no siempre son errores; pueden reflejar casos especiales.
> El objetivo es decidir si conservar, corregir o eliminar.

**Estrategias comunes (Leal + curso):**

| Estrategia           | Descripción                                  | Ejemplo solar                         |
| -------------------- | -------------------------------------------- | ------------------------------------- |
| **Ignorar**          | Dejar pasar si el modelo es robusto          | Árbol de decisión que tolera outliers |
| **Filtrar columna**  | Eliminar o reemplazar por indicador discreto | Crear `temp_erronea = 1/0`            |
| **Filtrar fila**     | Suprimir registros problemáticos             | Días con sensores defectuosos         |
| **Reemplazar valor** | Sustituir por media, mediana o estimado      | Imputar `ambient_temp` con media      |
| **Discretizar**      | Convertir continuo → categórico              | `irradiation` → categorías baja/media/alta |

---

### **Slide 8 – Recomendaciones de limpieza**

* Analizar la causa antes de eliminar.
* Documentar el criterio aplicado.
* Evitar introducir sesgos por filtrado excesivo.
* Priorizar columnas con datos de mayor calidad.

**Recordar:**

* Eliminar filas puede sesgar resultados.
* Una buena imputación depende del contexto del atributo.

---

### **Slide 9 – Errores críticos e inconsistencias**

* Los errores son graves cuando afectan variables **clase** o **objetivo** del modelo.
* Ejemplo: dos registros idénticos excepto en la etiqueta → *inconsistencia*.
* Algunos métodos de ML no las “digerirán”, generando fallas.
  **Solución:**
* Eliminar todos los ejemplos inconsistentes o decidir cuál conservar.

---

### **Slide 10 – Flujo analítico en R (demostrativo)**

```r
# 1. Cargar y explorar
datos <- read_csv("solar_efficiency.csv")
summary(datos)

# 2. Diagnóstico de NA y outliers
boxplot(datos$ambient_temp)
boxplot(datos$module_temp)

# 3. Tratamiento e imputación
datos$ambient_temp <- ifelse(is.na(datos$ambient_temp),
                            mean(datos$ambient_temp, na.rm=TRUE),
                            datos$ambient_temp)
datos$irradiation <- ifelse(is.na(datos$irradiation), 0, datos$irradiation)

# 4. Estandarización y PCA
variables_pca <- datos %>% select(ambient_temp, module_temp, irradiation,
                                 temp_diff_module_ambient, temp_excess)
variables_estandarizadas <- scale(variables_pca)
pca <- prcomp(variables_estandarizadas, center=FALSE, scale.=FALSE)
screeplot(pca, type="lines")
```

**Objetivo docente:** entender el propósito de cada bloque (no ejecutar el código).

---

### **Slide 11 – ¿Qué hace el PCA? (AE 2.3)**

* Reduce la dimensionalidad del conjunto de datos.
* Crea nuevas variables (*componentes principales*) **independientes**.
* Los componentes se ordenan por **varianza explicada**.
* Facilita descubrir relaciones entre variables (sin redundancia).

**Interpretación solar:**
PC1 dominado por `irradiation` (+), `module_temp` (–) → confirma H1 y H2.

---

### **Slide 12 – Síntesis integradora**

```
Fuentes (Prim., Sec., Terc.)  
   ↓
ETL (Extract – Transform – Load)  
   ↓
Dataset analítico  
   ↓
Limpieza / imputación / tratamiento de anomalías  
   ↓
PCA y análisis exploratorio
```

**Aprendizajes clave:**

* Evaluar origen y confiabilidad de datos.
* Aplicar limpieza según tipo de error.
* Reconocer el rol del PCA en la exploración y reducción de variables.

---

### **Slide 13 – Cierre**

> **Del dato crudo a la información útil:**
>
> * Las fuentes aportan materia prima.
> * El ETL la transforma en información estructurada.
> * La limpieza asegura confiabilidad.
> * El análisis (PCA) genera conocimiento.
>
> “De fuentes confiables surgen datos limpios;
> de datos limpios, decisiones inteligentes.” — Leal (2021)

---

¿Quieres que te lo exporte a formato **PowerPoint (.pptx)** o **Quarto (.qmd)** con diseño limpio (colores UNAB, íconos de base de datos, sensor, engranaje, gráfico PCA)?
Así podrías presentarlo directamente en la sesión práctica.
