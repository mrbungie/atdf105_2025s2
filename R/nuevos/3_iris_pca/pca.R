# ============================================================
# Iris Analysis Script
# ============================================================

# Instala paquetes si es que faltan
install.packages(c("plotly","GGally","factoextra","patchwork"))

# Libraries
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)
library(GGally)
library(corrplot)
library(factoextra)
library(patchwork)

set.seed(42)

# ------------------------------------------------------------
# Load data
# ------------------------------------------------------------
iris_data <- read_csv("iris.csv")
iris_data$variety <- as.factor(iris_data$variety)

# Quick look
print(head(iris_data))
summary(iris_data)

# ------------------------------------------------------------
# Correlation analysis
# ------------------------------------------------------------
num_data <- iris_data %>% select(where(is.numeric))
cor_mat <- cor(num_data)
print(cor_mat)

corrplot(cor_mat, method = "color", addCoef.col = "black")

# ------------------------------------------------------------
# 3D Plot of most correlated features
# ------------------------------------------------------------
# Example: Petal.Length vs Petal.Width + Sepal.Length
fig_raw <- plot_ly(
  iris_data,
  x = ~petal.length,
  y = ~petal.width,
  z = ~sepal.length,
  color = ~variety,
  colors = c("red", "green", "blue"),
  type = "scatter3d",
  mode = "markers"
)
fig_raw

# ------------------------------------------------------------
# PCA
# ------------------------------------------------------------
iris_pca <- prcomp(num_data, center = TRUE, scale. = TRUE)
summary(iris_pca)

# Scree plot
# Cotnribución de cada componente a la varianza explicada
fviz_eig(iris_pca)

# Biplot
# Muestra los datos en 2 componentes
# Además de loadings (flechas) son las contribuciones de cada variable
fviz_pca_biplot(iris_pca, label = "var", habillage = iris_data$variety)

# Variable contributions
fviz_contrib(iris_pca, choice = "var", axes = 1)
fviz_contrib(iris_pca, choice = "var", axes = 2)

# ------------------------------------------------------------
# Projections in multiple plots
# ------------------------------------------------------------
scores <- as.data.frame(iris_pca$x) %>%
  mutate(variety = iris_data$variety)

p1 <- ggplot(scores, aes(PC1, PC2, color = variety)) +
  geom_point(size = 2) + theme_minimal()

p2 <- ggplot(scores, aes(PC1, PC3, color = variety)) +
  geom_point(size = 2) + theme_minimal()

p3 <- ggplot(scores, aes(PC2, PC3, color = variety)) +
  geom_point(size = 2) + theme_minimal()

(p1 | p2) / p3

# Density plot of PC1 by Species
ggplot(scores, aes(PC1, fill = variety)) +
  geom_density(alpha = 0.5) + theme_minimal()

# Density plot of PC2 by Species
ggplot(scores, aes(PC2, fill = variety)) +
  geom_density(alpha = 0.5) + theme_minimal()


# ------------------------------------------------------------
# 3D PCA plot
# ------------------------------------------------------------
fig_pca <- plot_ly(
  scores,
  x = ~PC1,
  y = ~PC2,
  z = ~PC3,
  color = ~variety,
  colors = c("red", "green", "blue"),
  type = "scatter3d",
  mode = "markers"
)
fig_pca
