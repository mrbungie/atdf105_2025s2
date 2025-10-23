# ========================================================
# ETL - DATASET DE ANÁLISIS DE EFICIENCIA SOLAR
# ========================================================
# Contexto: Planta de energía solar en el norte de Chile
# Objetivo: Crear dataset limpio para EDA, prueba de hipótesis y PCA
# Meta: Entender variables que afectan la eficiencia solar (kWh/kWp)
#
# IMPORTANTE PEDAGÓGICO:
# Este ETL está diseñado para dejar INTENCIONALMENTE algunos valores
# faltantes (NA) y posibles valores atípicos para que puedas practicar:
# - Detección de valores faltantes
# - Estrategias de imputación
# - Detección de outliers
# - Validación de rangos esperados
# ========================================================

# Cargar librerías requeridas
library(dplyr)
library(lubridate)
library(readr)
library(tidyr)

# ========================================================
# 1. EXTRACCIÓN DE DATOS (Leer archivos raw)
# ========================================================

cat("Iniciando proceso ETL...\n")
cat("1. Leyendo archivos de datos raw...\n")

# Leer datos de Planta 1
plant1_gen <- read_csv("raw_data/Plant_1_Generation_Data.csv", 
                       col_types = cols(DATE_TIME = col_character()))
plant1_weather <- read_csv("raw_data/Plant_1_Weather_Sensor_Data.csv",
                          col_types = cols(DATE_TIME = col_datetime()))

# Leer datos de Planta 2
plant2_gen <- read_csv("raw_data/Plant_2_Generation_Data.csv",
                       col_types = cols(DATE_TIME = col_character()))
plant2_weather <- read_csv("raw_data/Plant_2_Weather_Sensor_Data.csv",
                          col_types = cols(DATE_TIME = col_datetime()))

cat("   ✓ Cargados Datos Generación Planta 1: ", nrow(plant1_gen), " filas\n")
cat("   ✓ Cargados Datos Meteorológicos Planta 1: ", nrow(plant1_weather), " filas\n")
cat("   ✓ Cargados Datos Generación Planta 2: ", nrow(plant2_gen), " filas\n")
cat("   ✓ Cargados Datos Meteorológicos Planta 2: ", nrow(plant2_weather), " filas\n")

# ========================================================
# 2. TRANSFORMACIÓN DE DATOS
# ========================================================

cat("\n2. Transformando datos...\n")

# Función para estandarizar formato de fecha y agregar datos de generación
process_generation <- function(gen_data) {
  gen_data %>%
    # Corregir inconsistencia de formato de fecha - probar múltiples formatos
    mutate(DATE_TIME = case_when(
      grepl("^\\d{2}-\\d{2}-\\d{4}", DATE_TIME) ~ dmy_hm(DATE_TIME),
      grepl("^\\d{4}-\\d{2}-\\d{2}", DATE_TIME) ~ ymd_hms(DATE_TIME),
      TRUE ~ parse_date_time(DATE_TIME, orders = c("dmy HM", "ymd HMS"))
    )) %>%
    # Agregar por timestamp y planta (sumar todos los inversores)
    group_by(DATE_TIME, PLANT_ID) %>%
    summarise(
      total_dc_power = sum(DC_POWER, na.rm = TRUE),
      total_ac_power = sum(AC_POWER, na.rm = TRUE),
      total_daily_yield = sum(DAILY_YIELD, na.rm = TRUE),
      avg_total_yield = mean(TOTAL_YIELD, na.rm = TRUE),
      n_inverters = n(),
      .groups = 'drop'
    )
}

# Procesar datos de generación para ambas plantas
plant1_gen_agg <- process_generation(plant1_gen)
plant2_gen_agg <- process_generation(plant2_gen)

cat("   ✓ Agregados Planta 1: ", nrow(plant1_gen_agg), " timestamps únicos\n")
cat("   ✓ Agregados Planta 2: ", nrow(plant2_gen_agg), " timestamps únicos\n")

# Estandarizar formato de datos meteorológicos
process_weather <- function(weather_data) {
  weather_data %>%
    mutate(DATE_TIME = as_datetime(DATE_TIME)) %>%
    select(DATE_TIME, PLANT_ID, AMBIENT_TEMPERATURE, MODULE_TEMPERATURE, IRRADIATION)
}

plant1_weather_clean <- process_weather(plant1_weather)
plant2_weather_clean <- process_weather(plant2_weather)

# Combinar datos de generación y meteorológicos para cada planta
merge_plant_data <- function(gen_agg, weather_data) {
  left_join(gen_agg, weather_data, by = c("DATE_TIME", "PLANT_ID"))
}

plant1_data <- merge_plant_data(plant1_gen_agg, plant1_weather_clean)
plant2_data <- merge_plant_data(plant2_gen_agg, plant2_weather_clean)

# Combinar ambas plantas
solar_data <- bind_rows(plant1_data, plant2_data) %>%
  arrange(PLANT_ID, DATE_TIME)

cat("   ✓ Datasets combinados: ", nrow(solar_data), " filas totales\n")

# ========================================================
# 3. INGENIERÍA DE CARACTERÍSTICAS
# ========================================================

cat("\n3. Creando características...\n")

solar_data <- solar_data %>%
  mutate(
    # Extraer características temporales
    date = as_date(DATE_TIME),
    hour = hour(DATE_TIME),
    day_of_year = yday(DATE_TIME),
    month = month(DATE_TIME),
    weekday = wday(DATE_TIME, label = TRUE),
    
    # Métricas de eficiencia (kWh/kWp)
    # Asumir capacidad nominal: Planta 1 = 50000 kW, Planta 2 = 30000 kW
    nominal_capacity = ifelse(PLANT_ID == 4135001, 50000, 30000),
    efficiency_kwh_kwp = total_ac_power / nominal_capacity,
    capacity_factor = total_ac_power / nominal_capacity,
    
    # Ratios de potencia
    dc_ac_ratio = ifelse(total_ac_power > 0, total_dc_power / total_ac_power, NA),
    
    # Diferencial de temperatura (crítico para eficiencia)
    temp_diff_module_ambient = MODULE_TEMPERATURE - AMBIENT_TEMPERATURE,
    
    # Categorías de intensidad solar
    irradiance_category = case_when(
      IRRADIATION == 0 ~ "Night",
      IRRADIATION < 0.2 ~ "Low",
      IRRADIATION < 0.5 ~ "Medium",
      TRUE ~ "High"
    ),
    
    # Categorías de hora del día
    time_category = case_when(
      hour >= 6 & hour < 10 ~ "Morning",
      hour >= 10 & hour < 14 ~ "Peak_Hours",
      hour >= 14 & hour < 18 ~ "Afternoon",
      TRUE ~ "Night_Low"
    ),
    
    # Estado operacional
    is_operating = ifelse(total_ac_power > 0, 1, 0),
    
    # Indicadores de rendimiento
    yield_per_inverter = total_daily_yield / n_inverters,
    
    # Características derivadas de condiciones meteorológicas
    temp_excess = pmax(0, MODULE_TEMPERATURE - 40),  # Solo exceso positivo
    irradiance_power_ratio = ifelse(total_ac_power > 0, IRRADIATION / total_ac_power, NA)
  )

cat("   ✓ Creadas ", length(solar_data) - length(bind_rows(plant1_data, plant2_data)), " nuevas características\n")

# ========================================================
# 4. LIMPIEZA Y CALIDAD DE DATOS
# ========================================================

cat("\n4. Limpiando datos...\n")

# Eliminar duplicados
initial_rows <- nrow(solar_data)
solar_data <- solar_data %>%
  distinct(DATE_TIME, PLANT_ID, .keep_all = TRUE)
removed_duplicates <- initial_rows - nrow(solar_data)

# Manejar valores faltantes
cat("   • Verificando valores faltantes...\n")
na_summary <- solar_data %>%
  summarise_all(~sum(is.na(.))) %>%
  gather(key = "variable", value = "na_count") %>%
  filter(na_count > 0)

if(nrow(na_summary) > 0) {
  cat("   ⚠ Valores faltantes encontrados:\n")
  print(na_summary)
  
  # ESTRATEGIA PEDAGÓGICA: Imputar SOLO algunas variables, dejar otras con NA para práctica
  cat("   • Imputando parcialmente valores faltantes (dejando algunos NA intencionalmente)...\n")
  
  solar_data <- solar_data %>%
    mutate(
      # Imputar temperatura ambiente (variable importante)
      AMBIENT_TEMPERATURE = ifelse(is.na(AMBIENT_TEMPERATURE), 
                                   mean(AMBIENT_TEMPERATURE, na.rm = TRUE), 
                                   AMBIENT_TEMPERATURE),
      
      # DEJAR temperatura de módulo con NA en algunos casos (para práctica)
      # No imputar MODULE_TEMPERATURE - dejar NA intencionalmente
      
      # Imputar irradiación con 0 (sin sol = 0)
      IRRADIATION = ifelse(is.na(IRRADIATION), 0, IRRADIATION),
      
      # DEJAR temp_diff con NA cuando module_temp es NA (para práctica)
      temp_diff_module_ambient = ifelse(is.na(temp_diff_module_ambient) & !is.na(MODULE_TEMPERATURE),
                                       MODULE_TEMPERATURE - AMBIENT_TEMPERATURE,
                                       temp_diff_module_ambient)
      # Nota: temp_excess también quedará con NA si module_temp es NA
    )
  cat("   ✓ Algunos valores imputados, otros dejados como NA para análisis\n")
}

# Filtrar valores extremadamente inválidos (dejar algunos errores sutiles para práctica)
cat("   • Filtrando valores extremadamente inválidos...\n")
solar_data <- solar_data %>%
  filter(
    total_ac_power >= 0,
    total_dc_power >= 0,
    # Permitir temperaturas más amplias para detectar posibles errores
    is.na(AMBIENT_TEMPERATURE) | (AMBIENT_TEMPERATURE >= -15 & AMBIENT_TEMPERATURE <= 70),
    is.na(MODULE_TEMPERATURE) | (MODULE_TEMPERATURE >= -15 & MODULE_TEMPERATURE <= 90),
    IRRADIATION >= 0 & IRRADIATION <= 2.0,  # Permitir hasta 2.0 para detectar outliers
    efficiency_kwh_kwp >= 0 & efficiency_kwh_kwp <= 2.0  # Permitir hasta 2.0 para detectar anomalías
  )

removed_invalid <- initial_rows - removed_duplicates - nrow(solar_data)

cat("   ✓ Eliminadas ", removed_duplicates, " filas duplicadas\n")
cat("   ✓ Eliminadas ", removed_invalid, " filas inválidas\n")
cat("   ✓ Dataset final: ", nrow(solar_data), " filas\n")

# ========================================================
# 5. CREAR DATASET ANALÍTICO FINAL
# ========================================================

cat("\n5. Creando dataset analítico final...\n")

# Seleccionar características clave para análisis
solar_efficiency <- solar_data %>%
  select(
    # Identificadores
    timestamp = DATE_TIME,
    plant_id = PLANT_ID,
    date,
    
    # Características temporales
    hour,
    month,
    weekday,
    day_of_year,
    time_category,
    
    # Variables meteorológicas (independientes)
    ambient_temp = AMBIENT_TEMPERATURE,
    module_temp = MODULE_TEMPERATURE,
    irradiation = IRRADIATION,
    temp_diff_module_ambient,
    temp_excess,
    irradiance_category,
    
    # Variables de generación (dependientes)
    total_dc_power,
    total_ac_power,
    total_daily_yield,
    efficiency_kwh_kwp,
    capacity_factor,
    
    # Características operacionales
    n_inverters,
    yield_per_inverter,
    dc_ac_ratio,
    is_operating,
    
    # Características del sistema
    nominal_capacity
  ) %>%
  # Convertir categóricas a factores
  mutate(
    plant_id = as.factor(plant_id),
    weekday = as.factor(weekday),
    time_category = as.factor(time_category),
    irradiance_category = as.factor(irradiance_category),
    is_operating = as.factor(is_operating)
  )

cat("   ✓ Estructura del dataset final:\n")
cat("   • Filas: ", nrow(solar_efficiency), "\n")
cat("   • Columnas: ", ncol(solar_efficiency), "\n")
cat("   • Plantas: ", length(unique(solar_efficiency$plant_id)), "\n")
cat("   • Rango de fechas: ", min(solar_efficiency$date), " a ", max(solar_efficiency$date), "\n")

# ========================================================
# 5.5. INTRODUCIR ERRORES INTENCIONALES PARA PRÁCTICA (PEDAGÓGICO)
# ========================================================

cat("\n5.5. Introduciendo errores sutiles para práctica...\n")

set.seed(123)  # Para reproducibilidad
n_rows <- nrow(solar_efficiency)

# Introducir algunos valores problemáticos para detectar
solar_efficiency <- solar_efficiency %>%
  mutate(
    # 1. Introducir algunas temperaturas atípicas (pero dentro de rango permisivo)
    module_temp = ifelse(runif(n()) < 0.01, 
                         module_temp + sample(c(-5, 5), n(), replace = TRUE),
                         module_temp),
    
    # 2. Introducir algunos valores de eficiencia sospechosamente altos
    efficiency_kwh_kwp = ifelse(runif(n()) < 0.005 & efficiency_kwh_kwp > 0,
                                 efficiency_kwh_kwp * 1.5,  # Multiplicar por 1.5 algunas eficiencias
                                 efficiency_kwh_kwp),
    
    # 3. Introducir algunas potencias DC inconsistentes con AC
    total_dc_power = ifelse(runif(n()) < 0.008 & total_ac_power > 0,
                            total_ac_power * sample(c(15, 5), n(), replace = TRUE),  # Ratios anómalos
                            total_dc_power),
    
    # ====================================
    # 10 ERRORES ADICIONALES PARA PRÁCTICA
    # ====================================
    
    # 4. Introducir valores negativos de irradiación (físicamente imposible)
    irradiation = ifelse(runif(n()) < 0.003,
                         -abs(runif(n(), 0.1, 0.5)),
                         irradiation),
    
    # 5. Introducir eficiencias imposibles (> 2.0)
    efficiency_kwh_kwp = ifelse(runif(n()) < 0.004 & efficiency_kwh_kwp > 0,
                                 runif(n(), 2.5, 5.0),
                                 efficiency_kwh_kwp),
    
    # 6. Introducir casos donde temperatura módulo < temperatura ambiente (físicamente improbable)
    module_temp = ifelse(runif(n()) < 0.006 & !is.na(ambient_temp) & !is.na(module_temp),
                         ambient_temp - abs(runif(n(), 5, 15)),
                         module_temp),
    
    # 7. Introducir potencias AC mayores que DC (inconsistente)
    total_ac_power = ifelse(runif(n()) < 0.005 & total_dc_power > 0,
                            total_dc_power * runif(n(), 1.2, 2.0),
                            total_ac_power),
    
    # 8. Introducir irradiación excesivamente alta (> 2.0 kW/m²)
    irradiation = ifelse(runif(n()) < 0.003,
                         runif(n(), 2.5, 4.0),
                         irradiation),
    
    # 9. Introducir inconsistencias temporales: irradiación > 0 en horas nocturnas
    irradiation = ifelse(runif(n()) < 0.007 & (hour >= 19 | hour <= 5),
                         runif(n(), 0.3, 0.8),
                         irradiation),
    
    # 10. Introducir ratios DC/AC físicamente imposibles
    total_dc_power = ifelse(runif(n()) < 0.004 & total_ac_power > 0,
                            total_ac_power * runif(n(), 0.1, 0.5),  # Ratios menores a 1 son imposibles
                            total_dc_power),
    
    # 11. Introducir temperaturas módulo extremadamente altas (> 90°C)
    module_temp = ifelse(runif(n()) < 0.003,
                         runif(n(), 95, 120),
                         module_temp),
    
    # 12. Introducir temperaturas ambiente extremadamente bajas (< -15°C)
    ambient_temp = ifelse(runif(n()) < 0.003,
                          runif(n(), -25, -20),
                          ambient_temp),
    
    # 13. Introducir valores de irradiación en múltiplos improbables
    irradiation = ifelse(runif(n()) < 0.002,
                         round(irradiation * 10) / 10,  # Crear patrones discretos sospechosos
                         irradiation)
  )

cat("   ✓ 13 tipos de errores introducidos para práctica de detección:\n")
cat("     • Temperaturas atípicas y extremas\n")
cat("     • Eficiencias imposibles\n")
cat("     • Potencias DC/AC inconsistentes\n")
cat("     • Irradiación negativa o excesiva\n")
cat("     • Inconsistencias temporales\n")
cat("     • Ratios físicamente imposibles\n")
cat("     • Patrones sospechosos discretos\n")

# ========================================================
# 6. CARGA DE DATOS (Exportar)
# ========================================================

cat("\n6. Exportando dataset final...\n")

write_csv(solar_efficiency, "solar_efficiency.csv")

cat("   ✓ Guardado en: solar_efficiency.csv\n")

# ========================================================
# 7. RESUMEN DE PERFILADO DE DATOS
# ========================================================

cat("\n7. Generando resumen de datos...\n")

summary_data <- solar_efficiency %>%
  group_by(plant_id) %>%
  summarise(
    n_observations = n(),
    date_range_days = as.numeric(max(date) - min(date)),
    avg_efficiency = mean(efficiency_kwh_kwp, na.rm = TRUE),
    max_efficiency = max(efficiency_kwh_kwp, na.rm = TRUE),
    avg_irradiation = mean(irradiation, na.rm = TRUE),
    avg_module_temp = mean(module_temp, na.rm = TRUE),
    operating_hours = sum(is_operating == 1),
    .groups = 'drop'
  )

cat("\n=== RESUMEN DEL DATASET ===\n")
print(summary_data)

cat("\n=== DESCRIPCIÓN DE CARACTERÍSTICAS ===\n")
cat("VARIABLES METEOROLÓGICAS (Independientes):\n")
cat("  • ambient_temp: Temperatura ambiente en °C\n")
cat("  • module_temp: Temperatura de módulos solares en °C\n")
cat("  • irradiation: Irradiación solar en kW/m²\n")
cat("  • temp_diff_module_ambient: Diferencia de temperatura (°C)\n")
cat("  • temp_excess: Temperatura excesiva sobre 40°C\n")
cat("  • irradiance_category: Categórico (Night/Low/Medium/High)\n\n")

cat("VARIABLES DE GENERACIÓN (Dependientes):\n")
cat("  • total_dc_power: Potencia DC total generada (kW)\n")
cat("  • total_ac_power: Potencia AC total generada (kW)\n")
cat("  • efficiency_kwh_kwp: Ratio de eficiencia (kWh/kWp)\n")
cat("  • capacity_factor: Potencia AC / capacidad nominal\n")
cat("  • total_daily_yield: Rendimiento energético diario (kWh)\n\n")

cat("CARACTERÍSTICAS OPERACIONALES:\n")
cat("  • n_inverters: Número de inversores activos\n")
cat("  • yield_per_inverter: Rendimiento promedio por inversor\n")
cat("  • dc_ac_ratio: Ratio de conversión DC a AC\n")
cat("  • is_operating: Binario (operando/no operando)\n\n")

cat("CARACTERÍSTICAS TEMPORALES:\n")
cat("  • hour: Hora del día (0-23)\n")
cat("  • month: Mes (1-12)\n")
cat("  • weekday: Día de la semana\n")
cat("  • time_category: Categórico (Morning/Peak_Hours/Afternoon/Night_Low)\n\n")

cat("=== LISTO PARA ANÁLISIS ===\n")
cat("✓ Dataset apropiado para:\n")
cat("  • Análisis Exploratorio de Datos (EDA)\n")
cat("  • Prueba de hipótesis (clima vs eficiencia)\n")
cat("  • Análisis de Componentes Principales (PCA)\n")
cat("  • Modelado con regresión\n")
cat("  • Análisis de series temporales\n")

cat("\n¡Proceso ETL completado exitosamente! ✓\n")
