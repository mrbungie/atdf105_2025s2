# ============================================================
# Hierarchical Clustering (Clustering Jerárquico) - Versión Simple
# ============================================================

# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "factoextra", "cluster", "gridExtra"))

# Cargar librerías necesarias
library(tidyverse)
library(factoextra)
library(cluster)
library(gridExtra)

# Establecer semilla para reproducibilidad
set.seed(42)

# ------------------------------------------------------------
# Cargar y preparar datos
# ------------------------------------------------------------
iris_data <- read_csv("data/iris.csv")
iris_data$variety <- as.factor(iris_data$variety)

# Explorar estructura de los datos
glimpse(iris_data)
summary(iris_data)

# Seleccionar solo las variables numéricas para clustering
iris_numerico <- iris_data %>%
  select(where(is.numeric))

# Normalizar los datos (importante para clustering jerárquico)
iris_normalizado <- scale(iris_numerico)

# ------------------------------------------------------------
# Configuración de parámetros (modificar aquí)
# ------------------------------------------------------------
# Distancia: "euclidean", "manhattan", "maximum", "minkowski"
distancia <- "euclidean"

# Método de enlace (solo para aglomerativo): "complete", "average", "single", "ward.D2"
linkage <- "complete"

# Tipo de clustering: "aglomerativo" o "divisivo"
tipo <- "aglomerativo"

# Número de clusters
k <- 3

# ------------------------------------------------------------
# Clustering Jerárquico
# ------------------------------------------------------------
cat("\n=== Clustering Jerárquico ===\n")
cat(paste("Distancia:", distancia, "\n"))
cat(paste("Linkage:", linkage, "\n"))
cat(paste("Tipo:", tipo, "\n"))
cat(paste("Número de clusters:", k, "\n\n"))

# Calcular matriz de distancias
if (distancia == "minkowski") {
  dist_matrix <- dist(iris_normalizado, method = distancia, p = 3)
} else {
  dist_matrix <- dist(iris_normalizado, method = distancia)
}

# Realizar clustering según el tipo
if (tipo == "aglomerativo") {
  # Clustering Aglomerativo
  if (linkage == "ward.D2" && distancia != "euclidean") {
    stop("Ward.D2 solo funciona con distancia euclidiana")
  }
  
  hclust_result <- hclust(dist_matrix, method = linkage)
  clusters <- cutree(hclust_result, k = k)
  dendrograma <- hclust_result
  
} else if (tipo == "divisivo") {
  # Clustering Divisivo (DIANA)
  # Nota: diana() solo soporta euclidean y manhattan
  if (!distancia %in% c("euclidean", "manhattan")) {
    stop("Clustering divisivo solo soporta distancias 'euclidean' y 'manhattan'")
  }
  
  diana_result <- diana(iris_normalizado, metric = distancia)
  clusters <- cutree(diana_result, k = k)
  dendrograma <- diana_result
  
} else {
  stop("Tipo debe ser 'aglomerativo' o 'divisivo'")
}

# ------------------------------------------------------------
# Visualización: Dendrograma
# ------------------------------------------------------------
titulo_dend <- paste("Dendrograma -", 
                     ifelse(tipo == "aglomerativo", 
                            paste("Aglomerativo (", linkage, ")", sep = ""),
                            "Divisivo (DIANA)"),
                     "- Distancia:", distancia)

p_dend <- fviz_dend(dendrograma, k = k,
                    cex = 0.6,
                    k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                    color_labels_by_k = TRUE,
                    rect = TRUE,
                    main = titulo_dend)

print(p_dend)

# ------------------------------------------------------------
# Visualización: Plot 2D con clusters y grupos originales
# ------------------------------------------------------------
plot_data <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters),
    variety = iris_data$variety
  )

titulo_2d <- paste("Clusters -", 
                   ifelse(tipo == "aglomerativo", 
                          paste("Aglomerativo (", linkage, ")", sep = ""),
                          "Divisivo (DIANA)"),
                   "- Distancia:", distancia)

p_2d <- ggplot(plot_data, aes(x = petal.length, y = petal.width, 
                               color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), 
                     name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = titulo_2d, x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))

print(p_2d)

# Mostrar ambos plots juntos
grid.arrange(p_dend, p_2d, ncol = 2)

# ------------------------------------------------------------
# Comparación con clases reales
# ------------------------------------------------------------
cat("\n--- Tabla de Contingencia: Clusters vs Variedades Reales ---\n")
tabla_contingencia <- table(clusters, iris_data$variety)
print(tabla_contingencia)


cat("\n=== Análisis completado ===\n")

