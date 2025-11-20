# ============================================================
# K-Means Clustering
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

# Normalizar los datos (importante para K-means)
iris_normalizado <- scale(iris_numerico)

# ------------------------------------------------------------
# Determinar número óptimo de clusters
# ------------------------------------------------------------
# Método del codo (Elbow Method)
fviz_nbclust(iris_normalizado, kmeans, method = "wss") +
  labs(title = "Método del Codo (Elbow Method)")

# Método de la silueta (Silhouette Method)
fviz_nbclust(iris_normalizado, kmeans, method = "silhouette") +
  labs(title = "Método de la Silueta")

# Método gap statistic
fviz_nbclust(iris_normalizado, kmeans, method = "gap_stat", nboot = 50) +
  labs(title = "Gap Statistic Method")

# ------------------------------------------------------------
# Aplicar K-means con k=3 (sabemos que hay 3 especies)
# ------------------------------------------------------------
k <- 3
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
                                 color = cluster, shape = variety)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "K-means Clusters: Sepal Length vs Sepal Width",
       x = "Sepal Length", y = "Sepal Width") +
  theme_minimal()

# Visualización 2D: Petal Length vs Petal Width
p2 <- ggplot(iris_clusters, aes(x = petal.length, y = petal.width, 
                                 color = cluster, shape = variety)) +
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

do.call(grid.arrange, c(plots_k, ncol = 2))

