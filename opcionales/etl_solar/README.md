# Dataset de Eficiencia Solar - Documentación Completa

## 📊 Descripción del Dataset

**Archivo:** `solar_efficiency.csv`  
**Propósito:** Dataset listo para análisis para entender factores de eficiencia de paneles solares  
**Contexto:** Plantas de energía solar en el norte de Chile (Región de Atacama, Mayo-Junio 2020)

---

## 🎯 Contexto del Negocio

### Situación
Eres analista de datos en una empresa de energía solar con plantas en el norte de Chile (Región de Atacama). La gerencia quiere entender qué variables climáticas y operativas afectan la eficiencia de generación eléctrica (kWh/kWp).

El dataset consolidado proviene de distintos sistemas operacionales:

**Sensores meteorológicos:**
- Radiación solar (kW/m²)
- Temperatura ambiente (°C)
- Temperatura de módulos (°C)

**SCADA de planta:**
- Potencia DC generada por inversores (kW)
- Potencia AC entregada (kW)
- Rendimiento diario acumulado (kWh)
- Conteo de inversores activos

**Período de análisis:**
- Fechas: 15 Mayo - 17 Junio 2020
- Frecuencia: Intervalos de 15 minutos
- Plantas: 2 instalaciones (capacidades 50MW y 30MW)

El ETL realizado por el área TI unifica todos estos datos en una tabla llamada `solar_efficiency.csv`.

**Tu tarea:** Limpiar, imputar, explorar y analizar los datos con PCA para descubrir qué factores explican la mayor variación en la eficiencia de generación.

---

## 📋 Estructura del Dataset

### Dimensiones
- **6,417 observaciones** (filas)
- **24 variables** (columnas)
- **2 plantas** (Planta 1: 4135001, Planta 2: 4136001)
- **Período:** 15 Mayo - 17 Junio 2020 (33 días)
- **Frecuencia:** Intervalos de 15 minutos

### Variables por Categoría

#### 🌡️ Variables Meteorológicas (Independientes)
| Variable | Descripción | Unidades |
|----------|-------------|----------|
| `ambient_temp` | Temperatura del aire ambiente | °C |
| `module_temp` | Temperatura de los módulos solares | °C |
| `irradiation` | Intensidad de irradiación solar | kW/m² |
| `temp_diff_module_ambient` | Diferencia de temperatura (módulo - ambiente) | °C |
| `temp_excess` | Temperatura excesiva sobre umbral de 40°C | °C |
| `irradiance_category` | Clasificación categórica | Night/Low/Medium/High |

#### ⚡ Variables de Generación (Dependientes - Objetivo del Análisis)
| Variable | Descripción | Unidades |
|----------|-------------|----------|
| `total_dc_power` | Potencia DC total generada | kW |
| `total_ac_power` | Potencia AC total entregada | kW |
| `total_daily_yield` | Rendimiento energético diario acumulado | kWh |
| `efficiency_kwh_kwp` | **Métrica clave:** Ratio de eficiencia | kWh/kWp |
| `capacity_factor` | Potencia AC / capacidad nominal | ratio |

#### 🔧 Características Operacionales
| Variable | Descripción |
|----------|-------------|
| `n_inverters` | Número de inversores activos |
| `yield_per_inverter` | Rendimiento promedio por inversor | kWh |
| `dc_ac_ratio` | Ratio de conversión DC a AC |
| `is_operating` | Estado operacional binario |

#### 📅 Características Temporales
| Variable | Descripción |
|----------|-------------|
| `timestamp` | Marca de tiempo completa (intervalos de 15 min) |
| `date` | Fecha |
| `hour` | Hora del día (0-23) |
| `month` | Mes (5-6) |
| `weekday` | Día de la semana |
| `day_of_year` | Día juliano |
| `time_category` | Categórico: Morning/Peak_Hours/Afternoon/Night_Low |

#### 🏭 Características del Sistema
| Variable | Descripción |
|----------|-------------|
| `plant_id` | Identificador de planta (factor) |
| `nominal_capacity` | Capacidad nominal de la planta | kW |

---

## 🔍 Resumen de Métricas Clave

### Comparación de Rendimiento entre Plantas
- **Planta 1 (4135001):**
  - Capacidad nominal: 50,000 kW
  - Eficiencia promedio: 0.134 kWh/kWp
  - Eficiencia máxima: 0.583 kWh/kWp
  - Irradiación promedio: 0.348 kW/m²
  - Temperatura de módulo promedio: 32.1°C

- **Planta 2 (4136001):**
  - Capacidad nominal: 30,000 kW
  - Eficiencia promedio: 0.167 kWh/kWp
  - Eficiencia máxima: 0.866 kWh/kWp
  - Irradiación promedio: 0.417 kW/m²
  - Temperatura de módulo promedio: 28.8°C

---

## 🔹 Fuentes de Conocimiento de Dominio

### Tabla de Fuentes de Información

| Fuente | Descripción | Tipo | Relevancia para el Análisis |
|--------|-------------|------|----------------------------|
| **Sensores Meteorológicos** | Datos de radiación solar, temperatura ambiente y temperatura de módulos medidos in-situ | Primaria | Variable principal: temperatura del módulo afecta rendimiento (-0.45%/°C) |
| **Sistema SCADA** | Potencia real generada (DC/AC kW) y estado de inversores desde sistema de control | Primaria | Variable dependiente: medición directa de eficiencia operacional |
| **Datos NREL PVWatts** | Calculator de energía solar - coeficientes de rendimiento estándar | Secundaria | Validación de métricas de eficiencia esperadas |
| **NASA POWER API** | Datos meteorológicos satelitales para validación de irradiación | Secundaria | Comparación con datos de sensores locales |
| **Manual Técnico Paneles** | Coeficiente térmico de potencia: -0.45% por cada °C sobre temperatura de referencia | Terciaria | Hipótesis fundamentada: alta temperatura reduce eficiencia |
| **Normativa IRENA** | Estándares de factor de capacidad para plantas solares (Chile: 25-35%) | Terciaria | Benchmark de rendimiento esperado |
| **Artículos Científicos** | "Impact of Temperature on PV Module Efficiency" - Estudios en climas desérticos | Terciaria | Marco teórico para interpretación de resultados |

### Fuentes Específicas Recomendadas

1. **Coeficiente Térmico de Rendimiento**
   - Fuente: Especificaciones técnicas de paneles fotovoltaicos
   - Relevancia: Establece relación directa entre temperatura del módulo y pérdida de eficiencia
   - Aplicación: Validar hipótesis H1 sobre correlación negativa temperatura-eficiencia

2. **Factor de Capacidad Solar (Chile)**
   - Fuente: IRENA Renewable Energy Statistics 2020
   - Benchmark: 25-35% para plantas en desierto de Atacama
   - Aplicación: Comparar efficiency_kwh_kwp con estándares internacionales

3. **Irradiación Promedio Atacama**
   - Fuente: SolarGIS / NASA POWER
   - Valor esperado: 7-8 kWh/m²/día en Atacama
   - Aplicación: Validar rangos de irradiación en dataset (verificar outliers)

4. **Patrones Temporales**
   - Fuente: Estudios de comportamiento diurno de plantas solares
   - Observación esperada: Máxima generación entre 10:00-14:00 hrs (horas pico)
   - Aplicación: Validar hipótesis H3 sobre horas de máxima eficiencia

---

## 🔹 Hipótesis de Trabajo

### Hipótesis Principales

**H1: Efecto de Temperatura**
- La temperatura del módulo tiene correlación negativa con la eficiencia
- Coeficiente esperado: -0.45% por cada °C sobre 25°C
- Métrica a analizar: `temp_excess` vs `efficiency_kwh_kwp`

**H2: Efecto de Irradiación**
- Mayor irradiación aumenta la generación de potencia
- Relación esperada: lineal hasta punto de saturación
- Métrica a analizar: `irradiation` vs `total_ac_power`

**H3: Patrón Temporal**
- Las horas pico (10:00-14:00) muestran máxima eficiencia
- Correlación con posición solar y temperatura óptima
- Métrica a analizar: `time_category` vs `efficiency_kwh_kwp`

**H4: Diferencias entre Plantas**
- La Planta 2 supera a la Planta 1 en eficiencia por capacidad instalada
- Diferencia esperada: arquitectura o tecnología de inversores
- Métrica a analizar: `plant_id` como factor en modelos

---

## 🎯 Aplicaciones del Análisis

Este dataset está optimizado para:

### 1. **Análisis Exploratorio de Datos (EDA)**
- Distribuciones univariadas de métricas de eficiencia
- Relaciones bivariadas (temperatura vs eficiencia, irradiación vs potencia)
- Comparaciones multi-planta
- Patrones temporales (ciclos diurnos, tendencias estacionales)

### 2. **Prueba de Hipótesis**
Las hipótesis H1-H4 pueden ser validadas mediante análisis estadísticos:
- Correlaciones y regresiones para temperatura e irradiación
- Tests de diferencias de medias entre plantas
- Análisis de varianza por categorías temporales

### 3. **Análisis de Componentes Principales (PCA)**
Reducción de dimensionalidad para identificar:
- Qué variables meteorológicas explican la mayor varianza en eficiencia
- Factores latentes que impulsan diferencias de rendimiento
- Agrupamiento de condiciones operativas

### 4. **Modelado con Regresión**
- Predecir eficiencia a partir de variables meteorológicas
- Cuantificar el impacto del exceso de temperatura en el rendimiento
- Modelar la generación de potencia como función de la irradiación

### 5. **Análisis de Series Temporales**
- Patrones de generación diaria
- Tendencias de eficiencia estacional
- Detección de anomalías en la generación de potencia

---

## 📝 Notas sobre Calidad de Datos

### Pasos de Pre-procesamiento
1. ✅ **Agregación:** Múltiples lecturas de inversores agregadas a totales de planta
2. ✅ **Estandarización de fechas:** Formatos de fecha inconsistentes corregidos entre plantas
3. ✅ **Imputación de valores faltantes:** Gaps de sensores meteorológicos rellenados con valores promedio
4. ✅ **Eliminación de outliers:** Valores inválidos de temperatura y potencia filtrados
5. ✅ **Ingeniería de características:** Creadas 16 características derivadas para análisis

### Valores Faltantes Intencionales (Para Práctica)
**IMPORTANTE:** Este dataset fue diseñado PEDAGÓGICAMENTE para dejar algunos valores faltantes:

- **`module_temp`**: 1 valor faltante (NA) - Simula sensor averiado
- **`temp_diff_module_ambient`**: 1 valor faltante - Derivado de module_temp faltante
- **`temp_excess`**: 1 valor faltante - Derivado de module_temp faltante
- **`dc_ac_ratio`**: 3,007 valores faltantes - Esperado cuando AC = 0 (noches)

**Nota:** El ETL imputa parcialmente algunos valores pero deja otros intencionalmente como NA para que practiques técnicas de imputación.

### Errores Intencionales para Detección
El dataset también contiene errores sutiles introducidos intencionalmente:
- Algunas temperaturas de módulo ligeramente atípicas
- Algunos valores de eficiencia sospechosamente altos
- Algunas inconsistencias entre potencia DC y AC

**Ejercicio recomendado:** Usa EDA para detectar estos errores antes del análisis principal.

### Variables NO Incluidas
- Humedad relativa (no disponible en datos fuente)
- Presión atmosférica (no disponible en datos fuente)
- Registros de mantenimiento (cleaning dates, module replacement)
- Reportes de incidencias (fallas, cortes, mantenimiento preventivo)
- Ventosidad (velocidad/dirección del viento)

---

## 🚀 Ejemplo de Uso

```r
# Cargar el dataset
library(dplyr)
library(ggplot2)

data <- read_csv("solar_efficiency.csv")

# EDA rápido
data %>%
  filter(is_operating == 1) %>%
  ggplot(aes(x = module_temp, y = efficiency_kwh_kwp, color = plant_id)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm") +
  labs(title = "Eficiencia Solar vs Temperatura del Módulo",
       x = "Temperatura del Módulo (°C)",
       y = "Eficiencia (kWh/kWp)")

# Prueba de hipótesis: Efecto de temperatura
model <- lm(efficiency_kwh_kwp ~ module_temp + irradiation + plant_id, 
            data = filter(data, is_operating == 1))
summary(model)
```

---

## 📊 Comparación con Otros Datasets

Este dataset es **similar en estructura** a:
- ✅ **iris.csv** (datos continuos multivariados para PCA)
- ✅ **adult.csv** (características mixtas categóricas + continuas)

**Diferencia clave:** Estos son datos de series temporales con resolución de 15 minutos, ideales para:
- Análisis transversal (relaciones entre variables)
- Análisis de series temporales (patrones temporales)

---

## 📁 Archivos del Proyecto

- `etl.R` - Script ETL (extracción, transformación, carga)
- `Data_Engineer.md` - Documentación técnica detallada de variables
- `solar_efficiency.csv` - Dataset final limpio (6,417 filas × 24 columnas)
- `raw_data/` - Archivos fuente originales (4 archivos CSV)

---

**Creado:** Dataset de Análisis de Energía Solar para EDA, Prueba de Hipótesis y PCA  
**Versión:** 1.0  
**Fecha:** Mayo-Junio 2020
