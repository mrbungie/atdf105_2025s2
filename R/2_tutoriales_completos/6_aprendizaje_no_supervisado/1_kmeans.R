# ============================================================
# K-Means Clustering
# ============================================================

# Instalar paquetes necesarios (ejecutar solo una vez)
# install.packages(c("tidyverse", "factoextra", "cluster", "gridExtra", "mclust"))

# Cargar librerías necesarias
library(tidyverse)
library(factoextra)
library(cluster)
library(gridExtra)
library(mclust)

# Establecer semilla para reproducibilidad
set.seed(42)

# ------------------------------------------------------------
# Cargar y preparar datos
# ------------------------------------------------------------
iris_data <- read_csv("iris.csv")
iris_data$variety <- as.factor(iris_data$variety)

# Explorar estructura de los datos
glimpse(iris_data)
summary(iris_data)
View(iris_data)

# Seleccionar solo las variables numéricas para clustering
iris_numerico <- iris_data %>%
  select(where(is.numeric))

# Normalizar los datos (importante para K-means)
iris_normalizado <- scale(iris_numerico)
View(iris_normalizado)

# ------------------------------------------------------------
# Determinar número óptimo de clusters
# ------------------------------------------------------------
# El alumno puede elegir qué métricas revisar de una lista más amplia.
metricas_disponibles <- c("wss", "silhouette", "gap_stat", "calinski_harabasz", "davies_bouldin", "adjusted_rand_index")
metricas_seleccionadas <- c("wss", "silhouette", "calinski_harabasz", "davies_bouldin")
stopifnot(all(metricas_seleccionadas %in% metricas_disponibles))

# Las tres primeras métricas ya tienen soporte directo en factoextra.
if ("wss" %in% metricas_seleccionadas) {
  fviz_nbclust(iris_normalizado, kmeans, method = "wss") +
    labs(title = "Método del Codo (Elbow Method)")
}

if ("silhouette" %in% metricas_seleccionadas) {
  fviz_nbclust(iris_normalizado, kmeans, method = "silhouette") +
    labs(title = "Método de la Silueta")
}

if ("gap_stat" %in% metricas_seleccionadas) {
  fviz_nbclust(iris_normalizado, kmeans, method = "gap_stat", nboot = 50) +
    labs(title = "Gap Statistic Method")
}

# Para el resto calculamos métricas manualmente sobre varios valores de k.
calinski_harabasz <- function(x, clusters) {
  x <- as.matrix(x)
  clusters <- as.factor(clusters)
  n <- nrow(x)
  k <- nlevels(clusters)
  global_center <- colMeans(x)
  centers <- rowsum(x, clusters) / as.vector(table(clusters))
  wss <- 0
  bss <- 0

  for (cluster_id in levels(clusters)) {
    puntos <- x[clusters == cluster_id, , drop = FALSE]
    centro <- centers[cluster_id, ]
    wss <- wss + sum(rowSums((puntos - matrix(centro, nrow = nrow(puntos), ncol = ncol(x), byrow = TRUE))^2))
    bss <- bss + nrow(puntos) * sum((centro - global_center)^2)
  }

  (bss / (k - 1)) / (wss / (n - k))
}

davies_bouldin <- function(x, clusters) {
  x <- as.matrix(x)
  clusters <- as.factor(clusters)
  centers <- rowsum(x, clusters) / as.vector(table(clusters))
  scatter <- sapply(levels(clusters), function(cluster_id) {
    puntos <- x[clusters == cluster_id, , drop = FALSE]
    centro <- centers[cluster_id, ]
    mean(sqrt(rowSums((puntos - matrix(centro, nrow = nrow(puntos), ncol = ncol(x), byrow = TRUE))^2)))
  })

  db_vals <- sapply(seq_along(levels(clusters)), function(i) {
    max(sapply(seq_along(levels(clusters)), function(j) {
      if (i == j) return(NA_real_)
      dist_centros <- sqrt(sum((centers[i, ] - centers[j, ])^2))
      (scatter[i] + scatter[j]) / dist_centros
    }), na.rm = TRUE)
  })

  mean(db_vals)
}

k_values_metricas <- 2:10
metricas_k <- tibble()
for (k_val in k_values_metricas) {
  kmeans_temp <- kmeans(iris_normalizado, centers = k_val, nstart = 25)
  fila <- tibble(k = k_val)

  if ("silhouette" %in% metricas_seleccionadas) {
    fila$silhouette <- mean(silhouette(kmeans_temp$cluster, dist(iris_normalizado))[, 3])
  }
  if ("calinski_harabasz" %in% metricas_seleccionadas) {
    fila$calinski_harabasz <- calinski_harabasz(iris_normalizado, kmeans_temp$cluster)
  }
  if ("davies_bouldin" %in% metricas_seleccionadas) {
    fila$davies_bouldin <- davies_bouldin(iris_normalizado, kmeans_temp$cluster)
  }
  if ("adjusted_rand_index" %in% metricas_seleccionadas) {
    fila$adjusted_rand_index <- adjustedRandIndex(kmeans_temp$cluster, iris_data$variety)
  }

  metricas_k <- bind_rows(metricas_k, fila)
}

print(metricas_k)

# ------------------------------------------------------------
# Aplicar K-means con k=3 (sabemos que hay 3 especies)
# ------------------------------------------------------------
k <- 3
help(kmeans)
kmeans_result <- kmeans(iris_normalizado, centers = k, nstart = 25, iter.max = 100)

# Ver información del modelo
print(kmeans_result)

# Centroides de los clusters
print("Centroides de los clusters:")
print(kmeans_result$centers)

# Tamaño de cada cluster
print("Tamaño de cada cluster:")
print(kmeans_result$size)

# Suma de cuadrados dentro de los clusters (WCSS)
print("Suma de cuadrados dentro de los clusters:")
print(kmeans_result$withinss)

# Suma total de cuadrados dentro de los clusters
print("Suma total de cuadrados dentro de los clusters:")
print(kmeans_result$tot.withinss)

# ------------------------------------------------------------
# Visualización de los clusters
# ------------------------------------------------------------
# Agregar asignaciones de clusters a los datos originales
iris_clusters <- iris_data %>%
  mutate(cluster = as.factor(kmeans_result$cluster))

# Visualización 2D: Sepal Length vs Sepal Width
p1 <- ggplot(iris_clusters, aes(x = sepal.length, y = sepal.width, 
                                 color = cluster)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "K-means Clusters: Sepal Length vs Sepal Width",
       x = "Sepal Length", y = "Sepal Width") +
  theme_minimal()

# Visualización 2D: Petal Length vs Petal Width
p2 <- ggplot(iris_clusters, aes(x = petal.length, y = petal.width, 
                                 color = cluster)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "K-means Clusters: Petal Length vs Petal Width",
       x = "Petal Length", y = "Petal Width") +
  theme_minimal()

# Mostrar ambas visualizaciones
grid.arrange(p1, p2, ncol = 2)

# Visualización usando factoextra
fviz_cluster(kmeans_result, data = iris_normalizado,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800"),
             geom = "point",
             ellipse.type = "convex",
             ggtheme = theme_bw())

# ------------------------------------------------------------
# Comparación con las clases reales
# ------------------------------------------------------------
# Matriz de confusión (comparando clusters con variedades reales)
table(iris_clusters$cluster, iris_clusters$variety)


# ------------------------------------------------------------
# Prueba con diferentes valores de k
# ------------------------------------------------------------
# Probar k = 2, 3, 4, 5
k_values <- 2:5
results_k <- list()

for (k_val in k_values) {
  kmeans_temp <- kmeans(iris_normalizado, centers = k_val, nstart = 25)
  results_k[[k_val]] <- kmeans_temp
  
  print(paste("k =", k_val, 
              "| WCSS =", round(kmeans_temp$tot.withinss, 2)))
}

# Visualizar comparación de diferentes valores de k
plots_k <- list()
for (k_val in k_values) {
  plots_k[[k_val]] <- fviz_cluster(results_k[[k_val]], data = iris_normalizado,
                                   geom = "point",
                                   main = paste("k =", k_val),
                                   ggtheme = theme_bw())
}
plots_k
