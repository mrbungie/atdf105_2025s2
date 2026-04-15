# install.packages(c("tidyverse", "class", "e1071", "randomForest", "rpart", "nnet", "pROC"))

# ## 1) Librerias
# Este script replica la idea del notebook de Python, pero en R.
# La meta es comparar variantes de varios modelos con CV y luego confrontarlas contra un holdout separado.
library(tidyverse)
library(class)
library(e1071)
library(randomForest)
library(rpart)
library(nnet)
library(pROC)

# ## 2) Cargar datos
# Usamos el mismo Titanic de la ruta Python para que la comparación entre lenguajes tenga sentido.
data <- read_csv("titanic.csv", show_col_types = FALSE)
print(head(data))
glimpse(data)

# ## 3) Preparar datos
variables_a_descartar <- c("PassengerId", "Name", "Cabin", "Ticket")
variables_categoricas <- c("Sex", "Embarked")
variables_numericas <- c("Pclass", "Age", "SibSp", "Parch", "Fare")
variable_dependiente <- "Survived"

metricas_disponibles <- c("accuracy", "precision", "recall", "f1", "roc_auc")
metricas_seleccionadas <- c("accuracy", "roc_auc")
if (!all(metricas_seleccionadas %in% metricas_disponibles)) {
  stop("Alguna métrica seleccionada no está disponible")
}

moda <- function(x) {
  x <- x[!is.na(x)]
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

preparar_base_clasificacion <- function(df) {
  df <- df %>%
    mutate(
      Survived = as.integer(Survived),
      Sex = as.factor(Sex),
      Embarked = as.factor(Embarked)
    )

  for (col in variables_numericas) {
    mediana <- median(df[[col]], na.rm = TRUE)
    df[[col]][is.na(df[[col]])] <- mediana
  }

  for (col in variables_categoricas) {
    valor_moda <- moda(df[[col]])
    df[[col]][is.na(df[[col]])] <- valor_moda
    df[[col]] <- as.factor(df[[col]])
  }

  df
}

generar_matrices_clasificacion <- function(train_df, test_df) {
  medias <- sapply(train_df[variables_numericas], mean)
  desvios <- sapply(train_df[variables_numericas], sd)
  desvios[is.na(desvios) | desvios == 0] <- 1

  train_num <- scale(train_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()
  test_num <- scale(test_df[variables_numericas], center = medias, scale = desvios) %>% as.data.frame()

  train_cat <- model.matrix(~ Sex + Embarked, data = train_df) %>% as.data.frame()
  test_cat <- model.matrix(~ Sex + Embarked, data = test_df) %>% as.data.frame()

  if ("(Intercept)" %in% names(train_cat)) train_cat <- train_cat %>% select(-`(Intercept)`)
  if ("(Intercept)" %in% names(test_cat)) test_cat <- test_cat %>% select(-`(Intercept)`)

  faltantes <- setdiff(names(train_cat), names(test_cat))
  for (col in faltantes) test_cat[[col]] <- 0
  extras <- setdiff(names(test_cat), names(train_cat))
  if (length(extras) > 0) test_cat <- test_cat %>% select(-all_of(extras))
  test_cat <- test_cat[, names(train_cat), drop = FALSE]

  x_train <- bind_cols(train_num, train_cat)
  x_test <- bind_cols(test_num, test_cat)
  y_train_num <- train_df[[variable_dependiente]]
  y_test_num <- test_df[[variable_dependiente]]
  y_train_factor <- factor(y_train_num, levels = c(0, 1))
  y_test_factor <- factor(y_test_num, levels = c(0, 1))

  list(x_train = x_train, x_test = x_test, y_train_num = y_train_num, y_test_num = y_test_num, y_train_factor = y_train_factor, y_test_factor = y_test_factor)
}

metricas_clasificacion <- function(y_real, y_pred_class, y_pred_prob = NULL) {
  accuracy <- mean(y_real == y_pred_class)
  precision <- if (sum(y_pred_class == 1) == 0) 0 else sum(y_real == 1 & y_pred_class == 1) / sum(y_pred_class == 1)
  recall <- if (sum(y_real == 1) == 0) 0 else sum(y_real == 1 & y_pred_class == 1) / sum(y_real == 1)
  f1 <- if ((precision + recall) == 0) 0 else 2 * precision * recall / (precision + recall)
  roc_auc <- NA_real_
  if (!is.null(y_pred_prob) && length(unique(y_real)) > 1) {
    roc_auc <- as.numeric(pROC::auc(y_real, y_pred_prob))
  }
  tibble(accuracy = accuracy, precision = precision, recall = recall, f1 = f1, roc_auc = roc_auc)
}

crear_folds_estratificados <- function(y, k = 5, seed = 42) {
  set.seed(seed)
  folds <- vector("list", k)
  idx0 <- sample(which(y == 0))
  idx1 <- sample(which(y == 1))
  split0 <- split(idx0, rep(1:k, length.out = length(idx0)))
  split1 <- split(idx1, rep(1:k, length.out = length(idx1)))
  for (i in seq_len(k)) {
    folds[[i]] <- sort(c(split0[[i]], split1[[i]]))
  }
  folds
}

ajustar_modelo_clasificacion <- function(modelo, version, x_train, y_train_num, y_train_factor) {
  train_df_num <- bind_cols(Survived = y_train_num, x_train)
  train_df_factor <- bind_cols(Survived = y_train_factor, x_train)

  if (modelo == "KNN") {
    list(tipo = "knn", k = ifelse(version == "k=5", 5, 11))
  } else if (modelo == "Regresión logística") {
    glm(Survived ~ ., data = train_df_num, family = binomial(), control = glm.control(maxit = 100))
  } else if (modelo == "Árbol de decisión") {
    rpart(Survived ~ ., data = train_df_factor, method = "class", control = rpart.control(maxdepth = ifelse(version == "max_depth=4", 4, 8)))
  } else if (modelo == "Random forest") {
    randomForest(Survived ~ ., data = train_df_factor, ntree = ifelse(version == "200 árboles", 200, 400))
  } else if (modelo == "SVM") {
    svm(Survived ~ ., data = train_df_factor, kernel = "radial", probability = TRUE, cost = ifelse(version == "C=1", 1, 10))
  } else if (modelo == "Naive Bayes") {
    naiveBayes(Survived ~ ., data = train_df_factor, laplace = ifelse(version == "smoothing=1e-09", 0, 1))
  } else if (modelo == "Red neuronal") {
    size_value <- ifelse(version == "(32,)", 3, 6)
    nnet(x = as.matrix(x_train), y = class.ind(y_train_factor), size = size_value, maxit = 300, decay = 0.1, softmax = TRUE, trace = FALSE)
  } else {
    stop("Modelo no implementado")
  }
}

predecir_modelo_clasificacion <- function(modelo, objeto, x_train, x_eval, y_train_factor = NULL) {
  if (modelo == "KNN") {
    pred_factor <- knn(train = x_train, test = x_eval, cl = y_train_factor, k = objeto$k, prob = TRUE)
    prob_attr <- attr(pred_factor, "prob")
    prob_1 <- ifelse(pred_factor == "1", prob_attr, 1 - prob_attr)
    list(class = as.integer(as.character(pred_factor)), prob = prob_1)
  } else if (modelo == "Regresión logística") {
    prob_1 <- predict(objeto, newdata = bind_cols(x_eval), type = "response")
    list(class = as.integer(prob_1 >= mean(as.integer(as.character(y_train_factor)))), prob = prob_1)
  } else if (modelo == "Árbol de decisión") {
    prob_1 <- predict(objeto, newdata = bind_cols(x_eval), type = "prob")[, "1"]
    list(class = as.integer(prob_1 >= mean(as.integer(as.character(y_train_factor)))), prob = prob_1)
  } else if (modelo == "Random forest") {
    prob_1 <- predict(objeto, newdata = bind_cols(x_eval), type = "prob")[, "1"]
    list(class = as.integer(prob_1 >= mean(as.integer(as.character(y_train_factor)))), prob = prob_1)
  } else if (modelo == "SVM") {
    pred_factor <- predict(objeto, newdata = bind_cols(x_eval), probability = TRUE)
    prob_1 <- attr(pred_factor, "probabilities")[, "1"]
    list(class = as.integer(as.character(pred_factor)), prob = prob_1)
  } else if (modelo == "Naive Bayes") {
    prob_1 <- predict(objeto, newdata = bind_cols(x_eval), type = "raw")[, "1"]
    list(class = as.integer(prob_1 >= mean(as.integer(as.character(y_train_factor)))), prob = prob_1)
  } else if (modelo == "Red neuronal") {
    prob_raw <- predict(objeto, as.matrix(x_eval), type = "raw")
    prob_1 <- if (is.matrix(prob_raw)) prob_raw[, ncol(prob_raw)] else as.numeric(prob_raw)
    list(class = as.integer(prob_1 >= mean(as.integer(as.character(y_train_factor)))), prob = prob_1)
  } else {
    stop("Modelo no implementado")
  }
}

# Igual que en sklearn, primero reservamos un holdout y después hacemos CV sobre training.
data <- preparar_base_clasificacion(data)
set.seed(42)
idx_train <- sample(seq_len(nrow(data)), size = floor(0.8 * nrow(data)))
train_data <- data[idx_train, ]
holdout_data <- data[-idx_train, ]
folds <- crear_folds_estratificados(train_data[[variable_dependiente]], k = 5, seed = 42)

comparison_grid <- tribble(
  ~modelo, ~version,
  "KNN", "k=5",
  "KNN", "k=11",
  "Regresión logística", "C=0.5",
  "Regresión logística", "C=2.0",
  "Árbol de decisión", "max_depth=4",
  "Árbol de decisión", "max_depth=8",
  "Random forest", "200 árboles",
  "Random forest", "400 árboles",
  "SVM", "C=1",
  "SVM", "C=10",
  "Naive Bayes", "smoothing=1e-09",
  "Naive Bayes", "smoothing=1e-07",
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

    proc <- generar_matrices_clasificacion(fold_train, fold_valid)
    fit <- ajustar_modelo_clasificacion(modelo, version, proc$x_train, proc$y_train_num, proc$y_train_factor)
    pred <- predecir_modelo_clasificacion(modelo, fit, proc$x_train, proc$x_test, proc$y_train_factor)
    metricas_folds[[fold_id]] <- metricas_clasificacion(proc$y_test_num, pred$class, pred$prob)
  }

  cv_resumen <- bind_rows(metricas_folds) %>% summarise(across(everything(), ~ mean(.x, na.rm = TRUE)))
  cv_sd <- bind_rows(metricas_folds) %>% summarise(across(everything(), ~ sd(.x, na.rm = TRUE)))

  proc_holdout <- generar_matrices_clasificacion(train_data, holdout_data)
  fit_holdout <- ajustar_modelo_clasificacion(modelo, version, proc_holdout$x_train, proc_holdout$y_train_num, proc_holdout$y_train_factor)
  pred_holdout <- predecir_modelo_clasificacion(modelo, fit_holdout, proc_holdout$x_train, proc_holdout$x_test, proc_holdout$y_train_factor)
  holdout_resumen <- metricas_clasificacion(proc_holdout$y_test_num, pred_holdout$class, pred_holdout$prob)

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
