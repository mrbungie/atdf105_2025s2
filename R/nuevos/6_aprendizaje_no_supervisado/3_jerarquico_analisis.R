# ============================================================
# Hierarchical Clustering (Clustering Jerárquico)
# ============================================================

# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "factoextra", "cluster", "dendextend", "gridExtra", "cowplot"))

# Cargar librerías necesarias
library(tidyverse)
library(factoextra)
library(cluster)
library(dendextend)
library(gridExtra)
library(cowplot)

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
# PARTE 1: Clustering Jerárquico con Distancia Euclidiana
# ------------------------------------------------------------
cat("\n=== PARTE 1: Clustering con Distancia Euclidiana ===\n\n")

# Calcular matriz de distancias euclidianas
dist_euclidiana <- dist(iris_normalizado, method = "euclidean")

# ------------------------------------------------------------
# Clustering Aglomerativo (Agglomerative)
# ------------------------------------------------------------
cat("--- Clustering Aglomerativo ---\n")

# Métodos de enlace disponibles para aglomerativo
metodos_aglomerativo <- c("complete", "average", "single", "ward.D2")

# Crear dendrogramas aglomerativos con distancia euclidiana
dend_agg_complete <- hclust(dist_euclidiana, method = "complete")
dend_agg_average <- hclust(dist_euclidiana, method = "average")
dend_agg_single <- hclust(dist_euclidiana, method = "single")
dend_agg_ward <- hclust(dist_euclidiana, method = "ward.D2")

# Obtener clusters con k=3 para cada método aglomerativo
clusters_agg_complete <- cutree(dend_agg_complete, k = 3)
clusters_agg_average <- cutree(dend_agg_average, k = 3)
clusters_agg_single <- cutree(dend_agg_single, k = 3)
clusters_agg_ward <- cutree(dend_agg_ward, k = 3)

# Visualizar cada método: dendrograma + plot 2D
# Complete Linkage
p_dend_complete <- fviz_dend(dend_agg_complete, k = 3,
                             cex = 0.5,
                             k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                             color_labels_by_k = TRUE,
                             rect = TRUE,
                             main = "Dendrograma - Complete Linkage")
plot_data_complete <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters_agg_complete),
    variety = iris_data$variety
  )
p_2d_complete <- ggplot(plot_data_complete, aes(x = petal.length, y = petal.width, 
                                                 color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = "Clusters - Complete Linkage", x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))
grid.arrange(p_dend_complete, p_2d_complete, ncol = 2)

# Average Linkage
p_dend_average <- fviz_dend(dend_agg_average, k = 3,
                            cex = 0.5,
                            k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                            color_labels_by_k = TRUE,
                            rect = TRUE,
                            main = "Dendrograma - Average Linkage")
plot_data_average <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters_agg_average),
    variety = iris_data$variety
  )
p_2d_average <- ggplot(plot_data_average, aes(x = petal.length, y = petal.width, 
                                               color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = "Clusters - Average Linkage", x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))
grid.arrange(p_dend_average, p_2d_average, ncol = 2)

# Single Linkage
p_dend_single <- fviz_dend(dend_agg_single, k = 3,
                           cex = 0.5,
                           k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                           color_labels_by_k = TRUE,
                           rect = TRUE,
                           main = "Dendrograma - Single Linkage")
plot_data_single <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters_agg_single),
    variety = iris_data$variety
  )
p_2d_single <- ggplot(plot_data_single, aes(x = petal.length, y = petal.width, 
                                             color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = "Clusters - Single Linkage", x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))
grid.arrange(p_dend_single, p_2d_single, ncol = 2)

# Ward's Method
p_dend_ward <- fviz_dend(dend_agg_ward, k = 3,
                         cex = 0.5,
                         k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                         color_labels_by_k = TRUE,
                         rect = TRUE,
                         main = "Dendrograma - Ward's Method")
plot_data_ward <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters_agg_ward),
    variety = iris_data$variety
  )
p_2d_ward <- ggplot(plot_data_ward, aes(x = petal.length, y = petal.width, 
                                         color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = "Clusters - Ward's Method", x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))
grid.arrange(p_dend_ward, p_2d_ward, ncol = 2)

# ------------------------------------------------------------
# Clustering Divisivo (Divisive)
# ------------------------------------------------------------
cat("\n--- Clustering Divisivo ---\n")

# Clustering divisivo usando diana() del paquete cluster
# Nota: diana() usa distancia euclidiana por defecto
diana_result <- diana(iris_normalizado, metric = "euclidean")

# Obtener clusters con k=3
clusters_div <- cutree(diana_result, k = 3)

# Visualizar: dendrograma + plot 2D
p_dend_div <- fviz_dend(diana_result, k = 3,
                        cex = 0.5,
                        k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                        color_labels_by_k = TRUE,
                        rect = TRUE,
                        main = "Dendrograma - Divisivo (DIANA)")
plot_data_div <- iris_numerico %>%
  mutate(
    cluster = as.factor(clusters_div),
    variety = iris_data$variety
  )
p_2d_div <- ggplot(plot_data_div, aes(x = petal.length, y = petal.width, 
                                       color = cluster, shape = variety)) +
  geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
  scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
  scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
  labs(title = "Clusters - Divisivo (DIANA)", x = "Petal Length", y = "Petal Width") +
  theme_bw() +
  theme(legend.position = "right",
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11))
grid.arrange(p_dend_div, p_2d_div, ncol = 2)

# Comparar con clases reales
cat("\n--- Comparación Aglomerativo vs Clases Reales ---\n")
table(clusters_agg_ward, iris_data$variety)

cat("\n--- Comparación Divisivo vs Clases Reales ---\n")
table(clusters_div, iris_data$variety)

# ------------------------------------------------------------
# PARTE 2: Matriz de Comparación - Todas las Distancias vs Aglomerativo/Divisivo
# ------------------------------------------------------------
cat("\n\n=== PARTE 2: Comparación de Distancias y Métodos ===\n\n")

# Definir diferentes métricas de distancia
# Nota: "maximum" es la distancia de Chebyshev en R
distancias <- c("euclidean", "manhattan", "maximum", "minkowski")

# Métodos de enlace para aglomerativo (focus en average, single, complete)
metodos_aglomerativo_comparacion <- c("complete", "average", "single")

# Crear lista para almacenar resultados
resultados <- list()

# Generar todas las combinaciones de distancia y método
for (distancia in distancias) {
  cat(paste("Procesando distancia:", distancia, "\n"))
  
  # Calcular matriz de distancias
  if (distancia == "minkowski") {
    dist_matrix <- dist(iris_normalizado, method = distancia, p = 3)
  } else {
    dist_matrix <- dist(iris_normalizado, method = distancia)
  }
  
  # Clustering aglomerativo para cada método de enlace (complete, average, single)
  for (metodo in metodos_aglomerativo_comparacion) {
    hclust_result <- hclust(dist_matrix, method = metodo)
    clusters <- cutree(hclust_result, k = 3)
    
    key <- paste(distancia, metodo, "agg", sep = "_")
    resultados[[key]] <- list(
      distancia = distancia,
      metodo = metodo,
      tipo = "aglomerativo",
      clusters = clusters,
      dendrograma = hclust_result
    )
  }
  
  # Clustering divisivo (DIANA)
  # Nota: diana() solo soporta euclidean, manhattan, gower
  if (distancia %in% c("euclidean", "manhattan")) {
    diana_result <- diana(iris_normalizado, metric = distancia)
    clusters_div <- cutree(diana_result, k = 3)
    
    key <- paste(distancia, "diana", "div", sep = "_")
    resultados[[key]] <- list(
      distancia = distancia,
      metodo = "diana",
      tipo = "divisivo",
      clusters = clusters_div,
      dendrograma = diana_result
    )
  }
}

# ------------------------------------------------------------
# Crear matriz de comparación: Dendrograma + Plot 2D para cada combinación
# ------------------------------------------------------------
cat("\nGenerando matriz de comparación completa...\n")
cat("(Esto puede tomar unos momentos)\n\n")

# ------------------------------------------------------------
# Matriz de comparación por distancia
# Para cada distancia, mostrar: complete, average, single (aglomerativo) + divisivo (si aplica)
# ------------------------------------------------------------
for (distancia in distancias) {
  cat(paste("\n--- Comparación para distancia:", distancia, "---\n"))
  
  plots_dend <- list()
  plots_2d <- list()
  
  # Agregar métodos aglomerativos (complete, average, single)
  for (metodo in metodos_aglomerativo_comparacion) {
    key <- paste(distancia, metodo, "agg", sep = "_")
    if (key %in% names(resultados)) {
      resultado <- resultados[[key]]
      titulo <- paste(distancia, "-", metodo)
      
      # Crear dendrograma
      p_dend <- fviz_dend(resultado$dendrograma, k = 3,
                         cex = 0.4,
                         k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                         color_labels_by_k = TRUE,
                         rect = TRUE,
                         main = paste("Dendrograma\n", titulo))
      
      # Crear plot 2D con clusters y grupos originales
      plot_data_temp <- iris_numerico %>%
        mutate(
          cluster = as.factor(resultado$clusters),
          variety = iris_data$variety
        )
      p_2d <- ggplot(plot_data_temp, aes(x = petal.length, y = petal.width, 
                                         color = cluster, shape = variety)) +
        geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
        scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
        scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
        labs(title = paste("Clusters\n", titulo), x = "Petal Length", y = "Petal Width") +
        theme_bw() +
        theme(legend.position = "right", 
              plot.title = element_text(size = 11, face = "bold"),
              axis.text = element_text(size = 9),
              axis.title = element_text(size = 10),
              legend.text = element_text(size = 8),
              legend.title = element_text(size = 9))
      
      plots_dend[[metodo]] <- p_dend
      plots_2d[[metodo]] <- p_2d
    }
  }
  
  # Agregar divisivo si está disponible
  key_div <- paste(distancia, "diana", "div", sep = "_")
  if (key_div %in% names(resultados)) {
    resultado <- resultados[[key_div]]
    titulo <- paste(distancia, "- Divisivo")
    
    # Crear dendrograma
    p_dend <- fviz_dend(resultado$dendrograma, k = 3,
                       cex = 0.4,
                       k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                       color_labels_by_k = TRUE,
                       rect = TRUE,
                       main = paste("Dendrograma\n", titulo))
    
    # Crear plot 2D con clusters y grupos originales
    plot_data_temp <- iris_numerico %>%
      mutate(
        cluster = as.factor(resultado$clusters),
        variety = iris_data$variety
      )
    p_2d <- ggplot(plot_data_temp, aes(x = petal.length, y = petal.width, 
                                       color = cluster, shape = variety)) +
      geom_point(size = 2.5, alpha = 0.8) +
      scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
      scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
      labs(title = paste("Clusters\n", titulo), x = "Petal Length", y = "Petal Width") +
      theme_bw() +
      theme(legend.position = "right", plot.title = element_text(size = 10))
    
    plots_dend[["divisivo"]] <- p_dend
    plots_2d[["divisivo"]] <- p_2d
  }
  
  # Mostrar dendrogramas en matriz 2x2
  if (length(plots_dend) > 0) {
    # Asegurar que tenemos exactamente 4 plots (rellenar con NULL si es necesario)
    plots_dend_4 <- plots_dend
    while (length(plots_dend_4) < 4) {
      plots_dend_4[[length(plots_dend_4) + 1]] <- NULL
    }
    plots_dend_4 <- plots_dend_4[1:4]  # Tomar solo los primeros 4
    
    dev.new(width = 12, height = 12)
    p_dend_final <- do.call(grid.arrange, c(plots_dend_4, ncol = 2, nrow = 2,
                            top = paste("Dendrogramas - Distancia:", distancia)))
    print(p_dend_final)
  }
  
  # Mostrar plots 2D en matriz 2x2
  if (length(plots_2d) > 0) {
    # Asegurar que tenemos exactamente 4 plots (rellenar con NULL si es necesario)
    plots_2d_4 <- plots_2d
    while (length(plots_2d_4) < 4) {
      plots_2d_4[[length(plots_2d_4) + 1]] <- NULL
    }
    plots_2d_4 <- plots_2d_4[1:4]  # Tomar solo los primeros 4
    
    dev.new(width = 12, height = 12)
    p_2d_final <- do.call(grid.arrange, c(plots_2d_4, ncol = 2, nrow = 2,
                            top = paste("Clusters 2D - Distancia:", distancia)))
    print(p_2d_final)
  }
}

# ------------------------------------------------------------
# Matriz de comparación por método
# Para cada método (complete, average, single), mostrar todas las distancias
# ------------------------------------------------------------
cat("\n--- Comparación por Método de Enlace ---\n")

for (metodo in metodos_aglomerativo_comparacion) {
  cat(paste("\n--- Método:", metodo, "---\n"))
  
  plots_dend_metodo <- list()
  plots_2d_metodo <- list()
  
  for (distancia in distancias) {
    key <- paste(distancia, metodo, "agg", sep = "_")
    if (key %in% names(resultados)) {
      resultado <- resultados[[key]]
      titulo <- paste(distancia, "-", metodo)
      
      # Crear dendrograma
      p_dend <- fviz_dend(resultado$dendrograma, k = 3,
                         cex = 0.4,
                         k_colors = c("#2E9FDF", "#00AFBB", "#E7B800"),
                         color_labels_by_k = TRUE,
                         rect = TRUE,
                         main = paste("Dendrograma\n", titulo))
      
      # Crear plot 2D con clusters y grupos originales
      plot_data_temp <- iris_numerico %>%
        mutate(
          cluster = as.factor(resultado$clusters),
          variety = iris_data$variety
        )
      p_2d <- ggplot(plot_data_temp, aes(x = petal.length, y = petal.width, 
                                         color = cluster, shape = variety)) +
        geom_point(size = 3.5, alpha = 0.9, stroke = 0.5) +
        scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
        scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
        labs(title = paste("Clusters\n", titulo), x = "Petal Length", y = "Petal Width") +
        theme_bw() +
        theme(legend.position = "right", 
              plot.title = element_text(size = 11, face = "bold"),
              axis.text = element_text(size = 9),
              axis.title = element_text(size = 10),
              legend.text = element_text(size = 8),
              legend.title = element_text(size = 9))
      
      plots_dend_metodo[[distancia]] <- p_dend
      plots_2d_metodo[[distancia]] <- p_2d
    }
  }
  
  # Mostrar dendrogramas en matriz 2x2
  if (length(plots_dend_metodo) > 0) {
    # Asegurar que tenemos exactamente 4 plots (rellenar con NULL si es necesario)
    plots_dend_4 <- plots_dend_metodo
    while (length(plots_dend_4) < 4) {
      plots_dend_4[[length(plots_dend_4) + 1]] <- NULL
    }
    plots_dend_4 <- plots_dend_4[1:4]  # Tomar solo los primeros 4
    
    dev.new(width = 12, height = 12)
    p_dend_final <- do.call(grid.arrange, c(plots_dend_4, ncol = 2, nrow = 2,
                            top = paste("Dendrogramas - Método:", metodo)))
    print(p_dend_final)
  }
  
  # Mostrar plots 2D en matriz 2x2
  if (length(plots_2d_metodo) > 0) {
    # Asegurar que tenemos exactamente 4 plots (rellenar con NULL si es necesario)
    plots_2d_4 <- plots_2d_metodo
    while (length(plots_2d_4) < 4) {
      plots_2d_4[[length(plots_2d_4) + 1]] <- NULL
    }
    plots_2d_4 <- plots_2d_4[1:4]  # Tomar solo los primeros 4
    
    dev.new(width = 12, height = 12)
    p_2d_final <- do.call(grid.arrange, c(plots_2d_4, ncol = 2, nrow = 2,
                            top = paste("Clusters 2D - Método:", metodo)))
    print(p_2d_final)
  }
}

# ------------------------------------------------------------
# Comparación Aglomerativo vs Divisivo para distancias soportadas
# ------------------------------------------------------------
cat("\n--- Comparación Aglomerativo vs Divisivo ---\n")

for (distancia in c("euclidean", "manhattan")) {
  cat(paste("\n--- Distancia:", distancia, "---\n"))
  
  # Crear lista de plots para esta distancia
  plots_comparacion <- list()
  
  # Agregar métodos aglomerativos
  for (metodo in metodos_aglomerativo_comparacion) {
    key <- paste(distancia, metodo, "agg", sep = "_")
    if (key %in% names(resultados)) {
      resultado <- resultados[[key]]
      plot_data_temp <- iris_numerico %>%
        mutate(
          cluster = as.factor(resultado$clusters),
          variety = iris_data$variety
        )
      p_2d <- ggplot(plot_data_temp, aes(x = petal.length, y = petal.width, 
                                         color = cluster, shape = variety)) +
        geom_point(size = 2.5, alpha = 0.8) +
        scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
        scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
        labs(title = paste(distancia, "-", metodo), x = "Petal Length", y = "Petal Width") +
        theme_bw() +
        theme(legend.position = "right", plot.title = element_text(size = 10))
      plots_comparacion[[metodo]] <- p_2d
    }
  }
  
  # Agregar divisivo
  key_div <- paste(distancia, "diana", "div", sep = "_")
  if (key_div %in% names(resultados)) {
    resultado <- resultados[[key_div]]
    plot_data_temp <- iris_numerico %>%
      mutate(
        cluster = as.factor(resultado$clusters),
        variety = iris_data$variety
      )
    p_2d <- ggplot(plot_data_temp, aes(x = petal.length, y = petal.width, 
                                       color = cluster, shape = variety)) +
      geom_point(size = 2.5, alpha = 0.8) +
      scale_color_manual(values = c("#2E9FDF", "#00AFBB", "#E7B800"), name = "Cluster", drop = FALSE) +
      scale_shape_manual(values = c(16, 17, 18), name = "Variedad", drop = FALSE) +
      labs(title = paste(distancia, "- Divisivo"), x = "Petal Length", y = "Petal Width") +
      theme_bw() +
      theme(legend.position = "right", plot.title = element_text(size = 10))
    plots_comparacion[["divisivo"]] <- p_2d
  }
  
  # Mostrar comparación en matriz 2x2
  if (length(plots_comparacion) > 0) {
    # Asegurar que tenemos exactamente 4 plots (rellenar con NULL si es necesario)
    plots_comp_4 <- plots_comparacion
    while (length(plots_comp_4) < 4) {
      plots_comp_4[[length(plots_comp_4) + 1]] <- NULL
    }
    plots_comp_4 <- plots_comp_4[1:4]  # Tomar solo los primeros 4
    
    dev.new(width = 12, height = 12)
    p_comparacion_final <- do.call(grid.arrange, c(plots_comp_4, ncol = 2, nrow = 2,
                            top = paste("Comparación Aglomerativo vs Divisivo - Distancia:", distancia)))
    print(p_comparacion_final)
  }
}

# ------------------------------------------------------------
# Resumen de métricas de calidad
# ------------------------------------------------------------
cat("\n\n=== Resumen de Métricas de Calidad ===\n\n")

# Calcular silueta promedio para cada combinación
metricas_resumen <- tibble()

for (key in names(resultados)) {
  resultado <- resultados[[key]]
  
  # Calcular distancia para silueta
  if (resultado$distancia == "minkowski") {
    dist_sil <- dist(iris_normalizado, method = "minkowski", p = 3)
  } else {
    dist_sil <- dist(iris_normalizado, method = resultado$distancia)
  }
  
  silueta <- silhouette(resultado$clusters, dist_sil)
  silueta_promedio <- mean(silueta[, 3])
  
  metricas_resumen <- metricas_resumen %>%
    bind_rows(tibble(
      Distancia = resultado$distancia,
      Metodo = resultado$metodo,
      Tipo = resultado$tipo,
      Silueta_Promedio = silueta_promedio
    ))
}

# Ordenar por silueta promedio
metricas_resumen <- metricas_resumen %>%
  arrange(desc(Silueta_Promedio))

print("Top 10 combinaciones por Silueta Promedio:")
print(head(metricas_resumen, 10))

# Visualizar comparación de siluetas
ggplot(metricas_resumen, aes(x = reorder(paste(Distancia, Metodo, Tipo, sep = "_"), 
                                          Silueta_Promedio), 
                              y = Silueta_Promedio, 
                              fill = Tipo)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Comparación de Silueta Promedio",
       x = "Combinación (Distancia_Método_Tipo)",
       y = "Silueta Promedio") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 7))

cat("\n=== Análisis completado ===\n")

