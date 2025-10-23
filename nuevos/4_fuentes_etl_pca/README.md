# 📊 Ejercicio: Análisis de Eficiencia Solar con PCA

## 🎯 Contexto del Ejercicio

### Situación Empresarial
Eres analista de datos en **Solar Andes S.A.**, una empresa de energía solar con plantas en el norte de Chile (Región de Atacama). La gerencia necesita entender qué variables climáticas y operativas afectan la eficiencia de generación eléctrica de las plantas solares.

### El Proceso de Datos

```
Fuentes de Información → ETL → Dataset Integrado → Análisis con PCA
```

### 📍 Fuentes de Información Disponibles

| Tipo | Ejemplos | Uso en este Proyecto |
|------|----------|----------------------|
| **Primarias** | Lecturas de sensores, registros SCADA | Radiación solar, temperatura, producción eléctrica |
| **Secundarias** | Reportes técnicos, API meteorológica | Benchmarks de eficiencia, datos de referencia |
| **Terciarias** | Catálogos técnicos, guías | Especificaciones de paneles y coeficientes |

**En este caso:**
- **Sensores meteorológicos** miden radiación solar, temperatura ambiente y temperatura de módulos
- **Sistema SCADA** registra potencia DC/AC generada por inversores
- Los datos fueron integrados por el equipo de TI mediante un proceso ETL

### 🔄 Proceso ETL (Extract-Transform-Load)

El área de TI realizó las siguientes operaciones:

| Etapa | Acción | Resultado |
|-------|--------|-----------|
| **Extract** | Leer datos de sensores y SCADA | Archivos CSV con datos brutos |
| **Transform** | Limpiar, unificar unidades, agregar por planta | Dataset homogenizado |
| **Load** | Exportar dataset unificado | `solar_efficiency.csv` |

### 📦 Dataset Recibido

**Archivo:** `solar_efficiency.csv`

**Características:**
- **6,417 observaciones** (intervalos de 15 minutos durante 33 días)
- **24 variables** (meteorológicas, de generación, temporales, operacionales)
- **2 plantas** con diferentes capacidades instaladas
- **Período:** Mayo-Junio 2020

**Variables Meteorológicas (Input):**
- `ambient_temp`: Temperatura ambiente (°C)
- `module_temp`: Temperatura de módulos solares (°C)
- `irradiation`: Irradiación solar (kW/m²)
- `temp_diff_module_ambient`: Diferencia de temperatura (°C)
- `temp_excess`: Exceso de temperatura sobre 40°C (°C)

**Variable Objetivo (Output):**
- `efficiency_kwh_kwp`: Eficiencia de generación (kWh/kWp)

---

## 🎓 Objetivos de Aprendizaje

Este ejercicio está diseñado para lograr los siguientes **Aprendizajes Esperados**:

### AE 2.1: Identificar valores faltantes y atípicos
- Detectar valores NA en el dataset
- Visualizar valores atípicos con gráficos de caja
- Reconocer patrones anómalos en las distribuciones

### AE 2.2: Aplicar técnicas de imputación
- Seleccionar estrategia de imputación según tipo de variable
- Imputar valores faltantes (media, mediana, valores por defecto)
- Verificar la calidad de la imputación

### AE 2.3: Estandarizar variables numéricas
- Comprender la necesidad de estandarización
- Aplicar escalado Z (media = 0, desviación = 1)
- Preparar datos para técnicas de reducción de dimensionalidad

### AE 2.4: Aplicar Análisis de Componentes Principales (PCA)
- Reducir dimensionalidad de variables correlacionadas
- Interpretar varianza explicada por componentes
- Analizar cargas (loadings) de las variables
- Visualizar resultados con scree plot y biplot

---

## 📋 Estructura de la Sesión (90 minutos)

| Bloque | Tiempo | Actividad |
|--------|--------|-----------|
| **1. Introducción teórica** | 10-15 min | Slides sobre fuentes de información, ETL y PCA |
| **2. Ejercicio guiado** | 35-40 min | Ejecutar script R y comentar resultados |
| **3. Quiz de evaluación** | 30 min | Responder preguntas sobre fuentes, ETL y PCA |

---

## 🚀 Instrucciones de Uso

### Prerrequisitos
- R instalado con las librerías: `dplyr`, `ggplot2`, `corrplot`, `readr`
- Dataset `solar_efficiency.csv` en el mismo directorio

### Ejecución
1. Abrir el archivo `ejercicio_solar_pca.R` en RStudio
2. Ejecutar sección por sección, leyendo los comentarios
3. Observar los gráficos generados
4. Responder el quiz `preguntas_quiz.md`
5. Verificar respuestas en `respuestas_explicadas.md`

### Lo que Deberías Observar
- **Valores faltantes**: Algunas variables pueden tener NA
- **Outliers**: Puntos fuera de los bigotes en los boxplots
- **Varianza explicada**: PC1 y PC2 deberían explicar >70% de la varianza
- **Componentes principales**: 6 variables meteorológicas → 6 componentes
- **Cargas**: Variables con alta influencia en los primeros componentes

---

## 🧩 Conceptos Clave

### ¿Qué es PCA?
El **Análisis de Componentes Principales** es una técnica de reducción de dimensionalidad que:
- Transforma variables correlacionadas en nuevas variables independientes
- Mantiene la mayor varianza posible en los primeros componentes
- Facilita la visualización y el análisis de datos multivariados

### ¿Por qué Estandarizar?
- Las variables tienen diferentes escalas (temperaturas en °C, irradiación en kW/m²)
- Sin estandarización, las variables con mayores rangos dominarían el análisis
- La estandarización permite comparar variables equitativamente

### Interpretación de Resultados
- **Scree Plot**: Muestra la varianza explicada por cada componente
- **Loadings**: Indican qué variables influyen en cada componente
- **Biplot**: Visualiza observaciones y variables en el espacio reducido

---

## 📚 Recursos Adicionales

### Bibliografía Sugerida
- Clasificación de fuentes de información (primarias, secundarias, terciarias)
- Procesos ETL en minería de datos
- Análisis de Componentes Principales (PCA)
- Técnicas de imputación de valores faltantes

### Datos del Ejercicio
- Dataset: `solar_efficiency.csv` (6,417 filas × 24 columnas)
- Plantas solares: Norte de Chile (Atacama)
- Período: Mayo-Junio 2020
- Variables: Meteorológicas, de generación, temporales

---

## ✅ Resultados Esperados

Al completar este ejercicio, deberías ser capaz de:

1. ✅ Identificar tipos de fuentes de información (primarias, secundarias, terciarias)
2. ✅ Comprender el proceso ETL en minería de datos
3. ✅ Detectar y manejar valores faltantes en un dataset
4. ✅ Estandarizar variables numéricas para análisis multivariado
5. ✅ Aplicar PCA y interpretar sus resultados
6. ✅ Visualizar relaciones entre variables usando biplots
7. ✅ Evaluar la varianza explicada por componentes principales

---

**Creado para:** Curso de Minería de Datos  
**Versión:** 1.0  
**Fecha:** 2024

