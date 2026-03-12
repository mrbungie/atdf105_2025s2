# ========================================================
# EJERCICIO GUÍADO: ANÁLISIS DE EFICIENCIA SOLAR CON PCA
# ========================================================
# Objetivo: Comprender el proceso de fuentes de información → ETL → PCA
# AE: Aplicar técnicas de limpieza e imputación (AE 2.1-2.3)
# Contexto: Dataset solar_efficiency.csv recibe datos integrados de TI
# ========================================================

# Cargar librerías necesarias
library(dplyr)
library(tidyr)
library(ggplot2)
library(corrplot)
library(readr)

# ========================================================
# 1. CARGA DE DATOS
# ========================================================
# Leer el dataset integrado desde el proceso ETL
cat("Leyendo dataset solar_efficiency.csv...\n")
datos <- read_csv("solar_efficiency.csv", show_col_types = FALSE)

cat("✓ Dataset cargado:\n")
cat("  • Filas:", nrow(datos), "\n")
cat("  • Columnas:", ncol(datos), "\n")
cat("  • Variables:", paste(names(datos), collapse = ", "), "\n\n")

# ======================================================= IMPRIMIR
# VERIFICACIÓN DE LA CALIDAD DE DATOS   AE 2.1
# ========================================================
cat("2. Verificando calidad de datos...\n\n")

# 2.1 Identificar valores faltantes (NA)
cat("A) VALORES FALTANTES (NA):\n")
na_por_variable <- datos %>%
  summarise_all(~sum(is.na(.))) %>%
  gather(key = "variable", value = "na_count") %>%
  filter(na_count > 0) %>%
  arrange(desc(na_count))

if(nrow(na_por_variable) > 0) {
  print(na_por_variable)
  cat("\nObservación: Algunas variables presentan valores faltantes.\n")
  cat("Esto puede ocurrir por fallas en sensores o momentos sin datos.\n\n")
} else {
  cat("✓ No se encontraron valores faltantes.\n\n")
}

# 2.2 Resumen estadístico básico
cat("B) RESUMEN ESTADÍSTICO DE VARIABLES CLAVE:\n")
cat("========================================\n")
datos %>%
  select(ambient_temp, module_temp, irradiation, efficiency_kwh_kwp) %>%
  summary() %>%
  print()

cat("\n")

# 2.3 Detectar valores atípicos visualmente
cat("C) VISUALIZACIÓN DE VALORES ATÍPICOS:\n")
cat("(Gráficos de caja para detectar outliers)\n\n")

# Gráfico 1: Variables meteorológicas
p1 <- datos %>%
  select(ambient_temp, module_temp, irradiation) %>%
  gather(key = "variable", value = "valor") %>%
  filter(!is.na(valor)) %>%
  ggplot(aes(x = variable, y = valor)) +
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  labs(title = "Distribución de Variables Meteorológicas",
       x = "Variable",
       y = "Valor") +
  theme_minimal()

print(p1)
cat("\nAnálisis: Revisar puntos fuera de los bigotes (outliers potenciales)\n\n")

# Gráfico 2: Eficiencia
p2 <- datos %>%
  mutate(plant_id = as.factor(plant_id)) %>%
  ggplot(aes(x = plant_id, y = efficiency_kwh_kwp)) +
  geom_boxplot(fill = "lightgreen", alpha = 0.7) +
  labs(title = "Distribución de Eficiencia por Planta",
       x = "Planta",
       y = "Eficiencia (kWh/kWp)") +
  theme_minimal()

print(p2)
cat("\n")

# =======================================================
# 3. LIMPIEZA E IMPUTACIÓN DE DATOS   AE 2.2
# =======================================================
cat("3. Limpiando e imputando datos...\n\n")

# 3.1 Seleccionar variables numéricas para análisis PCA
cat("A) SELECCIÓN DE VARIABLES PARA PCA:\n")
cat("====================================\n")
cat("Variables seleccionadas (características meteorológicas):\n")
cat("  • ambient_temp\n")
cat("  • module_temp\n")
cat("  • irradiation\n")
cat("  • temp_diff_module_ambient\n")
cat("  • temp_excess\n")
cat("  • efficiency_kwh_kwp\n\n")

# Extraer solo variables numéricas continuas relevantes
variables_pca <- datos %>%
  select(ambient_temp, module_temp, irradiation, 
         temp_diff_module_ambient, temp_excess, efficiency_kwh_kwp)

cat("Dimensiones del subconjunto:", nrow(variables_pca), "filas ×", ncol(variables_pca), "columnas\n\n")

# 3.2 Estrategia de imputación por variable
cat("B) ESTRATEGIA DE IMPUTACIÓN:\n")
cat("============================\n")

# Verificar NA en variables seleccionadas
na_pca <- variables_pca %>%
  summarise_all(~sum(is.na(.))) %>%
  gather(key = "variable", value = "na_count") %>%
  filter(na_count > 0)

if(nrow(na_pca) > 0) {
  cat("Variables con NA:\n")
  print(na_pca)
  cat("\n")
  
  # Imputar valores faltantes
  cat("Aplicando imputación:\n")
  
  variables_pca_limpio <- variables_pca %>%
    mutate(
      # Imputar temperatura ambiente con media
      ambient_temp = ifelse(is.na(ambient_temp), 
                           mean(ambient_temp, na.rm = TRUE), 
                           ambient_temp),
      
      # Imputar temperatura módulo con media
      module_temp = ifelse(is.na(module_temp), 
                          mean(module_temp, na.rm = TRUE), 
                          module_temp),
      
      # Imputar irradiación con 0 (si no hay sol, irradiación = 0)
      irradiation = ifelse(is.na(irradiation), 0, irradiation),
      
      # Recalcular diferencias de temperatura después de imputar
      temp_diff_module_ambient = module_temp - ambient_temp,
      
      # Recalcular exceso de temperatura
      temp_excess = pmax(0, module_temp - 40)
    )
  
  cat("✓ Imputación completada:\n")
  cat("  • Temperaturas: imputadas con media\n")
  cat("  • Irradiación: imputadas con 0\n")
  cat("  • Variables derivadas: recalculadas\n\n")
} else {
  variables_pca_limpio <- variables_pca
  cat("✓ No se requirió imputación.\n\n")
}

# 3.3 Verificar filas completas
filas_completas <- sum(complete.cases(variables_pca_limpio))
cat("C) VERIFICACIÓN POST-IMPUTACIÓN:\n")
cat("Filas completas:", filas_completas, "de", nrow(variables_pca_limpio), "\n\n")

# Eliminar filas con NA restantes (si las hay)
variables_pca_final <- variables_pca_limpio %>%
  filter(complete.cases(.))

cat("✓ Dataset final para PCA:", nrow(variables_pca_final), "filas completas\n\n")

# =======================================================
# 4. ESTANDARIZACIÓN DE VARIABLES   AE 2.3
# =======================================================
cat("4. Estandarizando variables...\n\n")

cat("A) ¿POR QUÉ ESTANDARIZAR?\n")
cat("Las variables tienen diferentes escalas:\n")
cat("  • Temperaturas: ~20-60 °C\n")
cat("  • Irradiación: ~0-1.2 kW/m²\n")
cat("  • Eficiencia: ~0-1.0\n\n")
cat("Estandarización permite comparar variables con diferentes unidades.\n\n")

# Estandarizar variables (media = 0, desviación = 1)
variables_estandarizadas <- variables_pca_final %>%
  mutate_at(vars(-efficiency_kwh_kwp), scale)

cat("B) ESTANDARIZACIÓN APLICADA:\n")
cat("Método: escala Z (media = 0, desviación estándar = 1)\n")
cat("Fórmula: (valor - media) / desviación_estándar\n\n")

cat("Verificación (primeras filas):\n")
head(variables_estandarizadas) %>%
  print()

cat("\n")

# =======================================================
# 5. ANÁLISIS DE COMPONENTES PRINCIPALES (PCA)
# =======================================================
cat("5. Aplicando Análisis de Componentes Principales (PCA)...\n\n")

cat("A) OBJETIVO DEL PCA:\n")
cat("========================\n")
cat("• Reducir dimensionalidad (6 variables → 2-3 componentes)\n")
cat("• Identificar qué factores explican mayor variabilidad\n")
cat("• Eliminar redundancia entre variables correlacionadas\n\n")

# Seleccionar solo variables independientes (sin efficiency_kwh_kwp)
variables_independientes <- variables_estandarizadas %>%
  select(-efficiency_kwh_kwp)

# Aplicar PCA
pca_resultado <- prcomp(variables_independientes, center = FALSE, scale. = FALSE)

cat("B) RESULTADOS DEL PCA:\n")
cat("======================\n")
cat("Componentes principales generados:", ncol(pca_resultado$x), "\n")
cat("Variables originales:", ncol(pca_resultado$rotation), "\n\n")

# 5.1 Scree Plot (varianza explicada)
cat("C) VARIANZA EXPLICADA POR COMPONENTE:\n")
cat("======================================\n")

varianza_explicada <- pca_resultado$sdev^2 / sum(pca_resultado$sdev^2) * 100
names(varianza_explicada) <- paste0("PC", seq_along(varianza_explicada))

cat("Varianza explicada (%):\n")
print(round(varianza_explicada, 2))

cat("\nInterpretación:\n")
cat("• PC1 explica", round(varianza_explicada[1], 2), "% de la varianza\n")
cat("• PC2 explica", round(varianza_explicada[2], 2), "% de la varianza\n")
cat("• PC1 + PC2 explican", round(sum(varianza_explicada[1:2]), 2), "% de la varianza\n\n")

# Scree plot visual
cat("D) VISUALIZACIÓN: SCREE PLOT\n")
scree_data <- data.frame(
  Componente = paste0("PC", seq_along(varianza_explicada)),
  Varianza_Explicada = varianza_explicada
)

p3 <- ggplot(scree_data, aes(x = Componente, y = Varianza_Explicada)) +
  geom_bar(stat = "identity", fill = "steelblue", alpha = 0.7) +
  geom_line(group = 1, color = "red", linewidth = 1) +
  geom_point(color = "red", size = 3) +
  labs(title = "Scree Plot - Varianza Explicada por Componente",
       x = "Componente Principal",
       y = "Varianza Explicada (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(p3)
cat("\nRegla práctica: Usar componentes hasta el 'codo' del gráfico.\n\n")

# 5.2 Matriz de cargas (loadings)
cat("E) MATRIZ DE CARGAS (LOADINGS):\n")
cat("===============================\n")
cat("Indica qué variables influyen en cada componente:\n\n")

# Mostrar solo primeros 3 componentes
loadings <- pca_resultado$rotation[, 1:3]
loadings_df <- as.data.frame(loadings)
loadings_df$Variable <- rownames(loadings_df)
loadings_df <- loadings_df %>% select(Variable, everything())

# Redondear solo las columnas numéricas
loadings_df[, 2:ncol(loadings_df)] <- round(loadings_df[, 2:ncol(loadings_df)], 3)
print(loadings_df)

cat("\nInterpretación:\n")
cat("• Valores cercanos a +1 o -1: alta influencia\n")
cat("• Valores cercanos a 0: baja influencia\n")
cat("• Signo: dirección de la relación\n\n")

# Identificar variables más influyentes en PC1
variable_pc1_max <- rownames(loadings)[which.max(abs(loadings[, 1]))]
cat("Variable más influyente en PC1:", variable_pc1_max, "\n")
cat("Carga:", round(loadings[variable_pc1_max, 1], 3), "\n\n")

# 5.3 Biplot
cat("F) VISUALIZACIÓN: BIPLOT\n")
cat("========================\n")
cat("Muestra observaciones y variables en el espacio de PC1-PC2:\n\n")

biplot(pca_resultado, choices = c(1, 2), 
       main = "Biplot - PC1 vs PC2",
       cex = 0.6)

cat("\nInterpretación:\n")
cat("• Flechas largas: variables con mayor varianza\n")
cat("• Flechas paralelas: variables correlacionadas\n")
cat("• Flechas perpendiculares: variables independientes\n")
cat("• Ángulos agudos: correlación positiva\n")
cat("• Ángulos obtusos: correlación negativa\n\n")

# =======================================================
# 6. INTERPRETACIÓN DE RESULTADOS
# =======================================================
cat("6. Interpretación de resultados...\n\n")

cat("A) RESUMEN DE HALLAZGOS:\n")
cat("=========================\n")
cat("1. Componentes principales generados:", ncol(pca_resultado$x), "\n")
cat("2. Varianza explicada por PC1:", round(varianza_explicada[1], 2), "%\n")
cat("3. Varianza explicada por PC2:", round(varianza_explicada[2], 2), "%\n")
cat("4. Variables más influyentes en PC1:", variable_pc1_max, "\n\n")

cat("B) CONCLUSIÓN:\n")
cat("==============\n")
cat("El PCA redujo la dimensionalidad de", ncol(variables_independientes), 
    "variables meteorológicas a", ncol(pca_resultado$x), "componentes principales.\n")
cat("Los primeros 2 componentes explican", round(sum(varianza_explicada[1:2]), 2), 
    "% de la variabilidad total.\n")
cat("Esto permite simplificar el análisis de eficiencia solar.\n\n")

cat("✓ Ejercicio completado\n")
cat("========================\n")

# =======================================================
# FIN DEL EJERCICIO
# =======================================================

