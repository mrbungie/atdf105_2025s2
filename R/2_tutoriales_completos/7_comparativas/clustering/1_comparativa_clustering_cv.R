# install.packages(c("tidyverse", "cluster", "randomForest", "mclust"))

# ## 1) Librerias
# Este script compara los métodos de clustering ya usados en la unidad, pero ahora con validación cruzada por folds.
# En clustering la CV no evalúa predicción futura como en supervisado; se usa para ver si la calidad del agrupamiento es estable cuando cambia la muestra.
library(tidyverse)
library(cluster)
library(mclust)

# ## 2) Cargar y preparar datos
data <- read_csv("iris.csv", show_col_types = FALSE)
data$variety <- as.factor(data$variety)
print(head(data))
glimpse(data)

iris_numerico <- data %>% select(where(is.numeric))
X <- scale(iris_numerico)
y_real <- data$variety

# ## 3) Definir métricas y grilla
metricas_disponibles <- c("silhouette", "calinski_harabasz", "davies_bouldin", "adjusted_rand_index")
metricas_seleccionadas <- c("silhouette", "calinski_harabasz", "davies_bouldin")
stopifnot(all(metricas_seleccionadas %in% metricas_disponibles))

comparison_grid <- tribble(
  ~modelo, ~version,
  "KMeans", "k=3",
  "KMeans", "k=4",
  "Jerárquico", "complete",
  "Jerárquico", "average",
  "Jerárquico", "single",
  "Jerárquico", "ward.D2"
)
print(comparison_grid)

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

crear_folds <- function(n, k = 5, seed = 42) {
  set.seed(seed)
  idx <- sample(seq_len(n))
  split(idx, rep(1:k, length.out = n))
}

obtener_clusters <- function(modelo, version, x_fold) {
  if (modelo == "KMeans") {
    k_val <- ifelse(version == "k=3", 3, 4)
    kmeans(x_fold, centers = k_val, nstart = 25)$cluster
  } else {
    dist_matrix <- dist(x_fold, method = "euclidean")
    hc <- hclust(dist_matrix, method = version)
    cutree(hc, k = 3)
  }
}

# ## 4) Validación cruzada
folds <- crear_folds(nrow(X), k = 5, seed = 42)
resultados <- list()

for (i in seq_len(nrow(comparison_grid))) {
  modelo <- comparison_grid$modelo[i]
  version <- comparison_grid$version[i]
  metricas_folds <- list()

  for (fold_id in seq_along(folds)) {
    idx_valid <- folds[[fold_id]]
    x_fold <- X[idx_valid, , drop = FALSE]
    y_fold <- y_real[idx_valid]
    clusters <- obtener_clusters(modelo, version, x_fold)

    fila <- tibble(fold = fold_id)

    if (length(unique(clusters)) > 1 && "silhouette" %in% metricas_seleccionadas) {
      fila$silhouette <- mean(silhouette(clusters, dist(x_fold))[, 3])
    }
    if (length(unique(clusters)) > 1 && "calinski_harabasz" %in% metricas_seleccionadas) {
      fila$calinski_harabasz <- calinski_harabasz(x_fold, clusters)
    }
    if (length(unique(clusters)) > 1 && "davies_bouldin" %in% metricas_seleccionadas) {
      fila$davies_bouldin <- davies_bouldin(x_fold, clusters)
    }
    if ("adjusted_rand_index" %in% metricas_seleccionadas) {
      fila$adjusted_rand_index <- adjustedRandIndex(clusters, y_fold)
    }

    metricas_folds[[fold_id]] <- fila
  }

  tabla_folds <- bind_rows(metricas_folds)
  fila_resumen <- tibble(modelo = modelo, version = version)
  for (metrica in metricas_seleccionadas) {
    fila_resumen[[paste0("cv_mean_", metrica)]] <- mean(tabla_folds[[metrica]], na.rm = TRUE)
    fila_resumen[[paste0("cv_std_", metrica)]] <- sd(tabla_folds[[metrica]], na.rm = TRUE)
  }

  resultados[[i]] <- fila_resumen
}

resultados_df <- bind_rows(resultados)
print(resultados_df)

# ## 5) Comparar resultados
metrica_principal <- metricas_seleccionadas[1]
if (metrica_principal == "davies_bouldin") {
  comparacion <- resultados_df %>% arrange(.data[[paste0("cv_mean_", metrica_principal)]])
} else {
  comparacion <- resultados_df %>% arrange(desc(.data[[paste0("cv_mean_", metrica_principal)]]))
}

print(comparacion)
