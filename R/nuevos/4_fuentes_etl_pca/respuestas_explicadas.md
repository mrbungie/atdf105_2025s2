# ✅ Respuestas Explicadas: Fuentes de Información, ETL y PCA

## Respuestas Preguntas 1-5

---

### Pregunta 1: ¿Cuál NO es una fuente de información?

**Respuesta Correcta: c) Base de datos corporativa**

**Explicación:**
Las fuentes de información son los **instrumentos o recursos originales** que generan datos nuevos. Las bases de datos corporativas son **repositorios** que almacenan información procesada, no fuentes en sí mismas.

- ✅ **Sensores SCADA**: Fuente primaria (medición directa)
- ✅ **Documentales técnicos**: Fuente secundaria (análisis de información existente)
- ❌ **Base de datos corporativa**: Repositorio, no fuente
- ✅ **Entrevistas a operadores**: Fuente primaria (observación directa)

**Concepto clave:** Fuente ≠ Repositorio

---

### Pregunta 2: Datos de sensores como fuente

**Respuesta Correcta: a) Fuentes primarias**

**Explicación:**
Los datos provenientes de sensores que miden radiación y temperatura son **fuentes primarias** porque:

- Se obtienen mediante **observación directa** y medición in-situ
- No han sido procesados ni interpretados previamente
- Son datos originales capturados en tiempo real
- Corresponden a mediciones físicas del ambiente

**Ejemplos en el caso solar:**
- Sensores meteorológicos → temperatura ambiente, radiación solar
- Sensores SCADA → potencia DC/AC generada
- Todos son fuentes primarias porque miden directamente

---

### Pregunta 3: Acción válida en Transformación ETL

**Respuesta Correcta: a) Eliminar duplicados**

**Explicación:**
La fase de **Transformación (T)** del ETL incluye operaciones de limpieza y preparación de datos:

✅ **Eliminar duplicados**: Parte de la limpieza de datos  
❌ **Definir hipótesis**: Etapa previa al ETL (planificación)  
❌ **Recolectar datos**: Etapa de Extracción (E)  
❌ **Publicar informe**: Etapa posterior al análisis

**Otras acciones válidas en Transformación:**
- Estandarizar formatos de fecha
- Unificar unidades de medida
- Imputar valores faltantes
- Validar rangos esperados
- Agregar datos por grupo

---

### Pregunta 4: Qué NO corresponde al tratamiento de datos faltantes

**Respuesta Correcta: d) Crear modelo predictivo sin limpieza previa**

**Explicación:**
Crear un modelo predictivo sin limpieza previa es una **mala práctica** que conduce a:

- Modelos con resultados sesgados o erróneos
- Errores en las predicciones
- Interpretaciones incorrectas
- Pérdida de confiabilidad

**Opciones válidas para datos faltantes:**
✅ **Imputar media o mediana**: Estrategia común para variables numéricas  
✅ **Eliminar registros**: Si los NA son pocos y no representativos  
✅ **Ignorar casos según criterio**: Si los NA son informativos (ej: noche → irradiación = 0)

**Concepto clave:** Siempre limpiar antes de modelar

---

### Pregunta 5: Orden de componentes en PCA

**Respuesta Correcta: b) La varianza que explican**

**Explicación:**
En el Análisis de Componentes Principales (PCA), los componentes se ordenan por **varianza explicada** de mayor a menor:

- **PC1**: Explica la mayor varianza
- **PC2**: Explica la segunda mayor varianza
- Y así sucesivamente...

**Razón:**
El objetivo del PCA es capturar la **mayor información posible** en los primeros componentes, reduciendo dimensionalidad manteniendo la variabilidad.

**Ejemplo práctico:**
- Si PC1 explica 60% de la varianza y PC2 explica 25%, juntos explican 85%
- Esto permite reducir 6 variables a 2 componentes con poca pérdida de información

---

## Respuestas Preguntas 6-10

---

### Pregunta 6: Definición de fuente primaria

**Respuesta Correcta: b) Lecturas de sensores SCADA**

**Explicación:**
Una **fuente primaria** se caracteriza por:

- **Observación directa**: Datos capturados sin intermediarios
- **Originalidad**: Información nueva, no derivada
- **Actualidad**: Refleja el estado actual del fenómeno estudiado

**Clasificación de las opciones:**
- ❌ **Reportes internos**: Fuente secundaria (resumen de datos primarios)
- ✅ **Lecturas de sensores SCADA**: Fuente primaria (medición directa)
- ❌ **Artículo académico**: Fuente secundaria (análisis de información existente)
- ❌ **Guía de catálogo**: Fuente terciaria (índice de fuentes)

**En el contexto solar:**
Los sensores SCADA miden directamente la potencia generada por los inversores, sin procesamiento previo → Fuente primaria.

---

### Pregunta 7: Características de fuentes secundarias

**Respuesta Correcta: b) Derivarse de documentos primarios y analizar información existente**

**Explicación:**
Las **fuentes secundarias**:

- **Se basan en fuentes primarias**: Procesan, analizan o interpretan datos originales
- **Agregan valor mediante análisis**: Contextualizan, comparan o sintetizan información
- **Proporcionan perspectiva interpretativa**: No son meros repositorios

**Ejemplos en investigación solar:**
- Reportes de NREL sobre eficiencia solar
- Artículos que analizan correlaciones temperatura-eficiencia
- Estudios comparativos entre plantas
- Tesis que sintetizan datos de múltiples plantas

**Opciones incorrectas:**
- ❌ Observación directa → Fuente primaria
- ❌ Solo resúmenes → Fuente terciaria
- ❌ Sin autoría → No es criterio de clasificación

---

### Pregunta 8: Actualidad y objetividad como criterios

**Respuesta Correcta: b) Evaluar su valor y confiabilidad**

**Explicación:**
La **actualidad** y **objetividad** son criterios para **evaluar la calidad** de una fuente:

**Actualidad:**
- ¿Los datos son recientes?
- ¿Reflejan el estado actual del fenómeno?
- ¿Siguen siendo relevantes?

**Objetividad:**
- ¿Son datos verificables?
- ¿Están libres de sesgo?
- ¿Son reproducibles?

**Otros criterios de evaluación:**
- Autoridad: ¿Quién generó los datos?
- Relevancia: ¿Responden a la pregunta de investigación?
- Cobertura: ¿Abarcan el fenómeno completo?

**Aplicación práctica:**
Un sensor meteorológico actualizado con calibración reciente tiene mayor valor y confiabilidad que una medición de hace 5 años.

---

### Pregunta 9: Propósito del ETL

**Respuesta Correcta: b) Transformar y cargar datos provenientes de fuentes diversas para su análisis**

**Explicación:**
El proceso **ETL (Extract-Transform-Load)** tiene como objetivo integrar datos de **múltiples fuentes** para crear un dataset unificado y limpio.

**Proceso completo:**
1. **Extract (E)**: Extraer datos de fuentes diversas (sensores, APIs, bases de datos)
2. **Transform (T)**: Limpiar, estandarizar, imputar, agregar
3. **Load (L)**: Cargar al repositorio final (Data Warehouse, dataset analítico)

**En el caso solar:**
- Extract: Leer datos de sensores meteorológicos y SCADA
- Transform: Unificar formatos, eliminar duplicados, imputar NA
- Load: Exportar `solar_efficiency.csv` para análisis

**Opciones incorrectas:**
- ❌ Formular hipótesis → Planificación previa al ETL
- ❌ Crear componentes principales → Técnica de análisis posterior
- ❌ Evaluar hipótesis → Análisis posterior al ETL

---

### Pregunta 10: Características de los componentes en PCA

**Respuesta Correcta: b) Independientes y ordenadas por varianza explicada**

**Explicación:**
Los **componentes principales** generados por PCA tienen dos características fundamentales:

**1. Independientes (no correlacionados):**
- Cada componente es ortogonal a los demás
- No hay redundancia entre componentes
- Esto contrasta con las variables originales que pueden estar correlacionadas

**2. Ordenados por varianza explicada:**
- PC1 explica la mayor varianza
- PC2 explica la segunda mayor varianza
- Etc.

**Propiedades matemáticas:**
- Los componentes son combinaciones lineales de las variables originales
- Suman la misma varianza total que las variables originales
- Permiten reducir dimensionalidad manteniendo la información clave

**Ejemplo práctico:**
Si temperatura y irradiación están correlacionadas, PCA puede combinarlas en un solo componente (PC1) que capture su relación → Reducción de 2 variables a 1 componente.

---

## 📊 Resumen de Respuestas

| Pregunta | Respuesta Correcta | Concepto Clave |
|----------|-------------------|----------------|
| 1 | c) Base de datos | Fuente ≠ Repositorio |
| 2 | a) Fuentes primarias | Observación directa |
| 3 | a) Eliminar duplicados | Etapa Transformación ETL |
| 4 | d) Modelo sin limpieza | Buenas prácticas |
| 5 | b) Varianza explicada | Ordenamiento PCA |
| 6 | b) Sensores SCADA | Definición fuente primaria |
| 7 | b) Derivarse y analizar | Características fuentes secundarias |
| 8 | b) Evaluar valor y confiabilidad | Criterios de calidad |
| 9 | b) Transformar y cargar | Propósito ETL |
| 10 | b) Independientes por varianza | Propiedades componentes PCA |

---

## 🎓 Reflexión Final

**Del dato a la decisión:** Una línea de aprendizaje basada en fuentes validadas y procesos reproducibles.

Las fuentes de información alimentan el proceso ETL.  
El ETL genera datasets confiables para minería de datos.  
Técnicas como PCA permiten analizar relaciones sin redundar información.

