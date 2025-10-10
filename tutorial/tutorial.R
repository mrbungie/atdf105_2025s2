# 1. Instalar paquetes (solo la primera vez)
# install.packages("tidyverse")   # descomentar si aún no está instalado

# 2. Cargar paquete
library(tidyverse)

###############################################
# 3. Asignación de variables y tipos de datos
###############################################

# Números
x <- 10          # entero
y <- 3.5         # decimal (numeric / double)
z <- 2L          # entero explícito con "L"

# Caracteres (strings)
nombre <- "Juan"
apellido <- "Perez"

# Lógicos (booleanos)
verdadero <- TRUE
falso <- FALSE

# Mostrar tipos de datos
typeof(x)        # "double"
typeof(z)        # "integer"
typeof(nombre)   # "character"
typeof(verdadero) # "logical"

###############################################
# 4. Operaciones matemáticas básicas
###############################################

a <- 15
b <- 4

suma <- a + b         # suma
resta <- a - b        # resta
mult <- a * b         # multiplicación
div <- a / b          # división
potencia <- a ^ b     # potencia (15^4)
raiz <- sqrt(a)       # raíz cuadrada
lognat <- log(a)      # logaritmo natural
log10a <- log10(a)    # logaritmo base 10

###############################################
# 5. Listas, vectores y strings
###############################################

# Vectores con c
# Listas con list
# Vectores son del mismo tipo y sin "nombres".
## Si es que ponen otro tipo, va a mantener el tipo más compatible posible.
## c(1, 2, 3, 4, 5) es numerico
## c(1, 2, 3, 4, 5, "hola") va a ser character resultado en => c("1", "2", "3", "4", "5", "hola")
# Listas pueden ser de distinto tipo y con "nombres"

# Vector numérico
v <- c(1, 2, 3, 4, 5)
print(v)

# Vector de caracteres
frutas <- c("manzana", "pera", "plátano")
print(frutas)

# Lista (puede contener objetos de distinto tipo)
mi_lista <- list(numero = 42, texto = "hola", vector = v)
print(mi_lista)

# Concatenar strings
nombre_completo <- paste(nombre, apellido)   # "Juan Perez"
print(nombre_completo)

###############################################
# 6. Data frames (mini ejemplo con tidyverse)
###############################################

# Crear un data frame sencillo
df <- tibble(
  id = 1:3,
  producto = c("A", "B", "C"),
  precio = c(100, 200, 300)
)

print(df)

# Acceder a columnas (con $ o doble corchetes)
df$precio
df[["producto"]]

# Estadísticas rápidas (ver otros para seguir)
mean(df$precio)   # promedio
sum(df$precio)    # suma
