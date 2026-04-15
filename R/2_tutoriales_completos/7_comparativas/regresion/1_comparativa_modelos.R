# install.packages(c("tidyverse", "FNN", "randomForest", "rpart", "e1071", "nnet"))

# ## 1) Librerias
# Este script sigue la misma idea del notebook Python de regresión: comparar CV contra holdout con dos variantes por modelo.
library(tidyverse)
library(FNN)
library(randomForest)
library(rpart)
library(e1071)
library(nnet)

# ## 2) Cargar datos
data <- read_csv("housing.csv", show_col_types = FALSE)
print(head(data))
glimpse(data)

# ## 3) Preparar datos
variables_a_descartar <- c()
variables_categoricas <- c("CHAS")
variables_numericas <- c("CRIM", "ZN", "INDUS", "NOX", "RM", "AGE", "DIS", "RAD", "TAX", "PTRATIO", "B", "LSTAT")
variable_dependiente <- "MEDV"

metricas_disponibles <- c("rmse", "mae", "r2", "mape")
metricas_seleccionadas <- c("r2", "rmse")
if (!all(metricas_seleccionadas %in% metricas_disponibles)) {
  stop("Alguna métrica seleccionada no está disponible")
}

moda <- function(x) {
  x <- x[!is.na(x)]
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

preparar_base_regresion <- function(df) {
  df %>% mutate(CHAS = as.factor(CHAS))
}

generar_matrices_regresion <- function(train_df, test_df) {
  train_df <- train_df %>% mutate(CHAS = as.factor(CHAS))
  test_df <- test_df %>% mutate(CHAS = factor(CHAS, levels = levels(train_df$CHAS)))

  for (col in variables_numericas) {
    mediana <- median(train_df[[col]], na.rm = TRUE)
    train_df[[col]][is.na(train_df[[col]])] <- mediana
    test_df[[col]][is.na(test_df[[col]])] <- mediana
  }

  for (col in variables_categoricas) {
    valor_moda <- moda(train_df[[col]])
    train_df[[col]][is.na(train_df[[col]])] <- valor_moda
    test_df[[col]][is.na(test_df[[col]])] <- valor_moda
    train_df[[col]] <- droplevels(train_df[[col]])
    test_df[[col]] <- factor(test_df[[col]], levels = levels(train_df[[col]]))
  }

  medias <- sapply(train_df[variables_numericas], mean)
  desvios <- sapply(train_df[variables_numericas], sd)
  desvios[is.na(desvios) | desvios == 0] <- 1

  train_num <- scale(train_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()
  test_num <- scale(test_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()

  train_cat <- model.matrix(~ CHAS, data = train_df) %>% as.data.frame()
  test_cat <- model.matrix(~ CHAS, data = test_df) %>% as.data.frame()
  if ("(Intercept)" %in% names(train_cat)) train_cat <- train_cat %>% select(-`(Intercept)`)
  if ("(Intercept)" %in% names(test_cat)) test_cat <- test_cat %>% select(-`(Intercept)`)

  faltantes <- setdiff(names(train_cat), names(test_cat))
  for (col in faltantes) test_cat[[col]] <- 0
  extras <- setdiff(names(test_cat), names(train_cat))
  if (length(extras) > 0) test_cat <- test_cat %>% select(-all_of(extras))
  test_cat <- test_cat[, names(train_cat), drop = FALSE]

  x_train <- bind_cols(train_num, train_cat)
  x_test <- bind_cols(test_num, test_cat)
  y_train <- train_df[[variable_dependiente]] %>% as.numeric()
  y_test <- test_df[[variable_dependiente]] %>% as.numeric()
  list(x_train = x_train, x_test = x_test, y_train = y_train, y_test = y_test)
}

metricas_regresion <- function(y_real, y_pred) {
  mse <- mean((y_real - y_pred)^2)
  mae <- mean(abs(y_real - y_pred))
  rmse <- sqrt(mse)
  mape <- mean(abs((y_real - y_pred) / y_real))
  r2 <- 1 - sum((y_real - y_pred)^2) / sum((y_real - mean(y_real))^2)
  tibble(rmse = rmse, mae = mae, r2 = r2, mape = mape)
}

crear_folds_regresion <- function(n, k = 5, seed = 42) {
  set.seed(seed)
  indices <- sample(seq_len(n))
  split(indices, rep(1:k, length.out = n))
}

ajustar_modelo_regresion <- function(modelo, version, x_train, y_train) {
  train_df <- bind_cols(y = y_train, x_train)
  if (modelo == "KNN") {
    list(tipo = "knn", k = ifelse(version == "k=5", 5, 11))
  } else if (modelo == "Regresión lineal") {
    if (version == "OLS") {
      lm(y ~ ., data = train_df)
    } else {
      train_df$RM2 <- train_df$RM^2
      lm(y ~ ., data = train_df)
    }
  } else if (modelo == "Árbol de decisión") {
    rpart(y ~ ., data = train_df, method = "anova", control = rpart.control(maxdepth = ifelse(version == "max_depth=4", 4, 8)))
  } else if (modelo == "Random forest") {
    randomForest(y ~ ., data = train_df, ntree = ifelse(version == "200 árboles", 200, 400))
  } else if (modelo == "SVM") {
    svm(y ~ ., data = train_df, type = "eps-regression", kernel = "radial", cost = ifelse(version == "C=1", 1, 10), epsilon = 0.1)
  } else if (modelo == "Red neuronal") {
    nnet(y ~ ., data = train_df, size = ifelse(version == "(32,)", 3, 6), linout = TRUE, maxit = 400, decay = 0.01, trace = FALSE)
  } else {
    stop("Modelo no implementado")
  }
}

predecir_modelo_regresion <- function(modelo, objeto, x_train, x_eval, version = NULL) {
  eval_df <- bind_cols(x_eval)
  if (modelo == "KNN") {
    knn.reg(train = x_train, test = x_eval, y = objeto$y_train, k = objeto$k)$pred
  } else if (modelo == "Regresión lineal") {
    if (!is.null(version) && version != "OLS") {
      eval_df$RM2 <- eval_df$RM^2
    }
    predict(objeto, newdata = eval_df)
  } else {
    predict(objeto, newdata = eval_df)
  }
}

# Igual que en sklearn, primero separamos un holdout y luego usamos CV sobre training.
data <- preparar_base_regresion(data)
set.seed(42)
idx_train <- sample(seq_len(nrow(data)), size = floor(0.8 * nrow(data)))
train_data <- data[idx_train, ]
holdout_data <- data[-idx_train, ]
folds <- crear_folds_regresion(nrow(train_data), k = 5, seed = 42)

comparison_grid <- tribble(
  ~modelo, ~version,
  "KNN", "k=5",
  "KNN", "k=11",
  "Regresión lineal", "OLS",
  "Regresión lineal", "OLS + RM^2",
  "Árbol de decisión", "max_depth=4",
  "Árbol de decisión", "max_depth=8",
  "Random forest", "200 árboles",
  "Random forest", "400 árboles",
  "SVM", "C=1",
  "SVM", "C=10",
  "Red neuronal", "(32,)",
  "Red neuronal", "(64, 32)"
)
print(comparison_grid)

resultados <- list()
for (i in seq_len(nrow(comparison_grid))) {
  modelo <- comparison_grid$modelo[i]
  version <- comparison_grid$version[i]
  metricas_folds <- list()

  for (fold_id in seq_along(folds)) {
    idx_valid <- folds[[fold_id]]
    fold_train <- train_data[-idx_valid, ]
    fold_valid <- train_data[idx_valid, ]

    proc <- generar_matrices_regresion(fold_train, fold_valid)
    fit <- ajustar_modelo_regresion(modelo, version, proc$x_train, proc$y_train)
    if (modelo == "KNN") fit$y_train <- proc$y_train
    pred <- predecir_modelo_regresion(modelo, fit, proc$x_train, proc$x_test, version)
    metricas_folds[[fold_id]] <- metricas_regresion(proc$y_test, pred)
  }

  cv_resumen <- bind_rows(metricas_folds) %>% summarise(across(everything(), ~ mean(.x, na.rm = TRUE)))
  cv_sd <- bind_rows(metricas_folds) %>% summarise(across(everything(), ~ sd(.x, na.rm = TRUE)))

  proc_holdout <- generar_matrices_regresion(train_data, holdout_data)
  fit_holdout <- ajustar_modelo_regresion(modelo, version, proc_holdout$x_train, proc_holdout$y_train)
  if (modelo == "KNN") fit_holdout$y_train <- proc_holdout$y_train
  pred_holdout <- predecir_modelo_regresion(modelo, fit_holdout, proc_holdout$x_train, proc_holdout$x_test, version)
  holdout_resumen <- metricas_regresion(proc_holdout$y_test, pred_holdout)

  fila <- tibble(modelo = modelo, version = version)
  for (metrica in metricas_seleccionadas) {
    fila[[paste0("cv_mean_", metrica)]] <- cv_resumen[[metrica]]
    fila[[paste0("cv_sd_", metrica)]] <- cv_sd[[metrica]]
    fila[[paste0("holdout_", metrica)]] <- holdout_resumen[[metrica]]
    fila[[paste0("gap_", metrica)]] <- holdout_resumen[[metrica]] - cv_resumen[[metrica]]
  }

  resultados[[i]] <- fila
}

resultados_df <- bind_rows(resultados)
print(resultados_df)
