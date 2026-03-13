# Documentación Técnica - Data Engineer

## 📐 Especificación del Dataset Final

**Archivo:** `solar_efficiency.csv`  
**Formato:** CSV estándar con separador de coma  
**Encoding:** UTF-8  
**Header:** Sí (primera fila contiene nombres de columnas)

---

## 🗂️ Esquema de Datos

### Dimensiones
- **Filas:** 6,417 observaciones
- **Columnas:** 24 variables
- **Tamaño estimado:** ~1.4 MB

### Distribución Temporal
- **Fecha inicio:** 2020-05-15 00:00:00
- **Fecha fin:** 2020-06-17 23:45:00
- **Frecuencia:** 15 minutos (96 registros por día)
- **Periodicidad:** Continua (sin gaps mayores a frecuencia base)

### Distribución por Planta
- **Planta 1 (4135001):** 3,158 observaciones
- **Planta 2 (4136001):** 3,259 observaciones

---

## 📊 Catálogo de Variables

### Tipo de Datos y Ranges

#### 1. Variables de Identificación

| Variable | Tipo | Formato | Descripción | Ejemplo |
|----------|------|---------|-------------|---------|
| `timestamp` | DateTime | ISO 8601 | Timestamp de observación | `2020-05-15T00:00:00Z` |
| `plant_id` | Factor | Categórico | ID de planta (2 niveles) | `4135001`, `4136001` |
| `date` | Date | YYYY-MM-DD | Fecha de observación | `2020-05-15` |

**Validaciones:**
- `timestamp`: No nulos, formato consistente
- `plant_id`: Solo valores válidos (4135001, 4136001)
- `date`: Derivado de timestamp, consistente

---

#### 2. Variables Temporales

| Variable | Tipo | Range | Descripción | Unidades |
|----------|------|-------|-------------|----------|
| `hour` | Integer | 0-23 | Hora del día (24h format) | Horas |
| `month` | Integer | 5-6 | Mes del año | Número |
| `weekday` | Factor | 7 niveles | Día de la semana | Mon-Sun |
| `day_of_year` | Integer | 136-169 | Día juliano del año | Número |
| `time_category` | Factor | 4 niveles | Categoría horaria | Morning/Peak_Hours/Afternoon/Night_Low |

**Lógica de `time_category`:**
- `Morning`: 06:00-09:59
- `Peak_Hours`: 10:00-13:59
- `Afternoon`: 14:00-17:59
- `Night_Low`: Resto de horas

---

#### 3. Variables Meteorológicas (Input Features)

| Variable | Tipo | Range Típico | Unidades | Descripción |
|----------|------|-------------|----------|-------------|
| `ambient_temp` | Numeric | 20-35 | °C | Temperatura del aire ambiente |
| `module_temp` | Numeric | 20-60 | °C | Temperatura de módulos solares |
| `irradiation` | Numeric | 0-1.2 | kW/m² | Intensidad de irradiación solar |
| `temp_diff_module_ambient` | Numeric | -5 a +30 | °C | Diferencia térmica (módulo - ambiente) |
| `temp_excess` | Numeric | 0-20 | °C | Exceso sobre umbral crítico (40°C) |
| `irradiance_category` | Factor | 4 niveles | Categórico | Clasificación por intensidad |

**Lógica de `irradiance_category`:**
- `Night`: irradiation = 0
- `Low`: 0 < irradiation < 0.2
- `Medium`: 0.2 ≤ irradiation < 0.5
- `High`: irradiation ≥ 0.5

**Propiedades Físicas:**
- `ambient_temp`: Rango esperado 15-40°C en desierto de Atacama
- `module_temp`: Típicamente 5-20°C mayor que ambiente cuando irradia
- `irradiation`: Máximo teórico ~1.0 kW/m² (condiciones óptimas)

---

#### 4. Variables de Generación (Target Features)

| Variable | Tipo | Range Típico | Unidades | Descripción |
|----------|------|-------------|----------|-------------|
| `total_dc_power` | Numeric | 0-50,000 | kW | Potencia DC total generada |
| `total_ac_power` | Numeric | 0-48,000 | kW | Potencia AC total entregada |
| `total_daily_yield` | Numeric | 0-1,000,000 | kWh | Rendimiento diario acumulado |
| `efficiency_kwh_kwp` | Numeric | 0-1.0 | ratio | **Métrica objetivo:** Eficiencia (kWh/kWp) |
| `capacity_factor` | Numeric | 0-1.0 | ratio | Factor de capacidad (AC/capacidad nominal) |

**Fórmulas:**
```
efficiency_kwh_kwp = total_ac_power / nominal_capacity
capacity_factor = total_ac_power / nominal_capacity
```

**Nota:** `capacity_factor` y `efficiency_kwh_kwp` son idénticos en esta implementación.

**Validaciones:**
- `total_dc_power` ≥ `total_ac_power` (siempre hay pérdidas de conversión)
- `efficiency_kwh_kwp` ≤ 1.0 (no puede exceder capacidad nominal)
- Valores nocturnos: Todos los poderes = 0

---

#### 5. Variables Operacionales

| Variable | Tipo | Range | Descripción |
|----------|------|-------|-------------|
| `n_inverters` | Integer | 20-24 | Número de inversores activos |
| `yield_per_inverter` | Numeric | 0-50,000 | kWh | Rendimiento promedio por inversor |
| `dc_ac_ratio` | Numeric | 8-12 | ratio | Ratio de conversión DC/AC |
| `is_operating` | Factor | 2 niveles | Estado operacional | 0=No, 1=Sí |

**Fórmulas:**
```
yield_per_inverter = total_daily_yield / n_inverters
dc_ac_ratio = total_dc_power / total_ac_power (si AC > 0)
```

**Validaciones:**
- `n_inverters`: Positivo, ≤ número total de inversores instalados
- `dc_ac_ratio`: Típicamente 10.0-10.5 (pérdidas de inversor ~4-5%)
- `is_operating`: Binario derivado de `total_ac_power > 0`

---

#### 6. Variables del Sistema

| Variable | Tipo | Valor | Descripción |
|----------|------|-------|-------------|
| `nominal_capacity` | Numeric | 50,000 o 30,000 | kW | Capacidad nominal instalada |

**Asignación:**
- Planta 1 (4135001): 50,000 kW
- Planta 2 (4136001): 30,000 kW

---

## 🔧 Transformaciones Aplicadas

### 1. Agregación de Datos
```r
# Múltiples inversores por timestamp → Total por planta
group_by(DATE_TIME, PLANT_ID) %>%
  summarise(
    total_dc_power = sum(DC_POWER),
    total_ac_power = sum(AC_POWER),
    n_inverters = n()
  )
```

### 2. Estandarización de Timestamps
```r
# Unificar formatos inconsistentes entre plantas
DATE_TIME = case_when(
  formato_planta1 ~ dmy_hm(DATE_TIME),
  formato_planta2 ~ ymd_hms(DATE_TIME)
)
```

### 3. Imputación de Valores Faltantes
```r
# Strategy: Mean imputation para sensores meteorológicos
AMBIENT_TEMPERATURE = ifelse(is.na(...), mean(...), ...)
MODULE_TEMPERATURE = ifelse(is.na(...), mean(...), ...)
IRRADIATION = ifelse(is.na(...), 0, ...)  # No irradiación = 0
```

### 4. Ingeniería de Características

**Características derivadas creadas:**
1. `date` - Extraído de timestamp
2. `hour` - Extraído de timestamp
3. `day_of_year` - Día juliano
4. `time_category` - Clasificación horaria
5. `nominal_capacity` - Capacidad según planta
6. `efficiency_kwh_kwp` - Ratio de eficiencia
7. `capacity_factor` - Factor de capacidad
8. `dc_ac_ratio` - Ratio DC/AC
9. `temp_diff_module_ambient` - Diferencia térmica
10. `irradiance_category` - Categoría de irradiación
11. `is_operating` - Estado operacional
12. `yield_per_inverter` - Rendimiento por inversor
13. `temp_excess` - Exceso de temperatura
14. `irradiance_power_ratio` - Ratio irradiación/potencia

---

## 🚨 Calidad de Datos

### Valores Faltantes (Missing Values)

**⚠️ PEDAGÓGICO:** Este dataset contiene valores faltantes INTENCIONALES para práctica.

| Variable | Instancias Faltantes | Razón | Estrategia Sugerida |
|----------|---------------------|-------|---------------------|
| `module_temp` | 1 | Sensor averiado (simulado) | Imputación con media o regresión |
| `temp_diff_module_ambient` | 1 | Derivado de module_temp NA | Calcular o imputar |
| `temp_excess` | 1 | Derivado de module_temp NA | Calcular o imputar |
| `dc_ac_ratio` | 3,007 | AC = 0 (noches) | Dejar NA o calcular con división protegida |

**Nota:** Algunos sensores meteorológicos fueron imputados en el ETL, pero module_temp se dejó intencionalmente con 1 NA para práctica de técnicas de imputación.

### Filtrado y Errores Intencionales

**⚠️ PEDAGÓGICO:** Este dataset contiene errores sutiles INTENCIONALES para práctica de detección.

**Criterios de filtrado aplicados (relajados intencionalmente):**
```r
filter(
  total_ac_power >= 0,
  total_dc_power >= 0,
  # Rangos más amplios para permitir detección de outliers
  AMBIENT_TEMPERATURE >= -15 & AMBIENT_TEMPERATURE <= 70,
  MODULE_TEMPERATURE >= -15 & MODULE_TEMPERATURE <= 90,
  IRRADIATION >= 0 & IRRADIATION <= 2.0,
  efficiency_kwh_kwp >= 0 & efficiency_kwh_kwp <= 2.0
)
```

**Errores introducidos intencionalmente (sección 5.5 del ETL):**

1. **Temperaturas atípicas:** ~1% de module_temp modificadas con ±5°C
2. **Eficiencias anómalas:** ~0.5% multiplicadas por 1.5
3. **Ratios DC/AC inconsistentes:** ~0.8% con ratios extremos (5 o 15)
4. **Irradiación negativa:** ~0.3% de valores negativos (físicamente imposible)
5. **Eficiencias imposibles:** ~0.4% con valores > 2.0 (range 2.5-5.0)
6. **Inconsistencias térmicas:** ~0.6% con temperatura módulo < temperatura ambiente
7. **Potencia AC > DC:** ~0.5% con inversión de sentido físico
8. **Irradiación excesiva:** ~0.3% con valores > 2.0 kW/m² (2.5-4.0)
9. **Inconsistencias temporales:** ~0.7% con irradiación > 0 en horas nocturnas
10. **Ratios imposibles:** ~0.4% con ratios DC/AC < 1
11. **Temperaturas extremas:** ~0.3% con módulos > 90°C (95-120°C)
12. **Temperaturas ambiente extremas:** ~0.3% con valores < -15°C (-25 a -20°C)
13. **Patrones discretos:** ~0.2% con irradiación en múltiplos improbables

**Total de tipos de errores:** 13

**Filas eliminadas:** 0 (errores sutiles mantenidos para análisis)

**Ejercicio recomendado:** Detectar estos errores con boxplots, scatter plots, histogramas, validación de business rules y análisis de outliers antes del análisis principal.

---

## 📈 Estadísticas Descriptivas

### Por Planta

#### Planta 1 (4135001)
```
Observaciones:           3,158
Rango de fechas:         33 días
Eficiencia promedio:     0.134 kWh/kWp
Eficiencia máxima:       0.583 kWh/kWp
Irradiación promedio:    0.348 kW/m²
Temp módulo promedio:    32.1°C
Horas operando:          1,447
```

#### Planta 2 (4136001)
```
Observaciones:           3,259
Rango de fechas:         33 días
Eficiencia promedio:     0.167 kWh/kWp
Eficiencia máxima:       0.866 kWh/kWp
Irradiación promedio:    0.417 kW/m²
Temp módulo promedio:    28.8°C
Horas operando:          1,445
```

---

## 🎯 Casos de Uso para Modelado

### 1. Modelos de Regresión
**Variables predictoras:**
- `ambient_temp`, `module_temp`, `irradiation`
- `temp_diff_module_ambient`, `temp_excess`
- `hour`, `time_category`

**Variable objetivo:**
- `efficiency_kwh_kwp`

### 2. Clasificación
**Objetivo:** Predecir período operacional (`is_operating`)
**Features:** Variables meteorológicas + temporales

### 3. PCA
**Variables continuas seleccionadas:**
- Todas las meteorológicas
- Variables de generación
- Excluir: IDs, factores categóricos

### 4. Series Temporales
**Orden temporal:** `timestamp` (orden natural)
**Frecuencia:** 15 minutos
**Variables:** Todas las numéricas

---

## 🔄 Pipeline de Producción

### Flujo ETL Completo

```
Raw Data (raw_data/)
    ↓
[EXTRACT]  → Read 4 CSV files
    ↓
[TRANSFORM] → Aggregate → Merge → Engineer features
    ↓
[CLEAN]    → Impute → Filter → Validate
    ↓
[LOAD]     → Export solar_efficiency.csv
```

### Datos de Entrada
- `Plant_1_Generation_Data.csv` (68,778 filas)
- `Plant_1_Weather_Sensor_Data.csv` (3,182 filas)
- `Plant_2_Generation_Data.csv` (67,698 filas)
- `Plant_2_Weather_Sensor_Data.csv` (3,259 filas)

### Datos de Salida
- `solar_efficiency.csv` (6,417 filas × 24 columnas)

### Reducción de Dimensionalidad
- Raw: ~140,000 filas → Final: 6,417 filas (agregación temporal)
- Raw: ~10 variables → Final: 24 variables (ingeniería de características)

---

## ⚠️ Consideraciones Técnicas

### 1. Unidades Consistencia
- **Temperatura:** Celsius (°C) en todas las variables
- **Potencia:** Kilowatts (kW) para DC y AC
- **Energía:** Kilowatt-hora (kWh) para yields
- **Radiación:** Kilowatts por metro cuadrado (kW/m²)

### 2. Precisión de Decimales
- **Temperaturas:** 2-3 decimales
- **Potencia:** Enteros o 1 decimal
- **Ratios:** 4-6 decimales
- **Irradiación:** Hasta 8 decimales (precisión científica)

### 3. Timezone
- **Timestamp:** UTC (ISO 8601 con 'Z')
- **Horas locales:** Aproximadamente UTC-3 (Chile continental)

### 4. Factor de Conversión DC-AC
```
DC Power → AC Power
Expected ratio: ~0.95 (5% pérdidas típicas en inversor)
Observed range: 0.90-0.98
```

---

## 📝 Metadatos Adicionales

### Versionamiento
- **Versión del dataset:** 1.0
- **Fecha de creación:** Mayo-Junio 2020
- **Script de generación:** `etl.R`
- **Dependencias:** dplyr, lubridate, readr, tidyr

### Contacto Técnico
Para preguntas sobre el dataset:
- **Tipo de datos:** Serie temporal de energía solar
- **Dominio:** Energía renovable / Fotovoltaica
- **Licencia:** Uso interno para análisis

---

**Última actualización:** 2020-06-17  
**Responsable ETL:** Área TI  
**Próxima revisión:** Trimestral

