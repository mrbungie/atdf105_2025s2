# Descripcion de datos: Automobile

## Resumen tecnico
- Grupo: grupo_2
- Filas: 205
- Columnas: 26
- Numericas detectadas: 18
- Categoricas detectadas: 8
- Faltantes totales en `automobile.csv`: 59

## Variables sugeridas para la pauta
- Para histograma/densidad/normalidad: price
- Para barras categoricas: fuel-system
- Para boxplot numerica vs categorica: price vs fuel-system

## Diccionario de variables
| Variable | Rol | Tipo | Missing reportado | Descripcion |
|---|---|---|---|---|
| price | Feature | Continuous | yes | continuous from 5118 to 45400 |
| highway-mpg | Feature | Continuous | no | continuous from 16 to 54 |
| city-mpg | Feature | Continuous | no | continuous from 13 to 49 |
| peak-rpm | Feature | Continuous | yes | continuous from 4150 to 6600 |
| horsepower | Feature | Continuous | yes | continuous from 48 to 288 |
| compression-ratio | Feature | Continuous | no | continuous from 7 to 23 |
| stroke | Feature | Continuous | yes | continuous from 2.07 to 4.17 |
| bore | Feature | Continuous | yes | continuous from 2.54 to 3.94 |
| fuel-system | Feature | Categorical | no | 1bbl, 2bbl, 4bbl, idi, mfi, mpfi, spdi, spfi |
| engine-size | Feature | Continuous | no | continuous from 61 to 326 |
| num-of-cylinders | Feature | Integer | no | eight, five, four, six, three, twelve, two |
| engine-type | Feature | Categorical | no | dohc, dohcv, l, ohc, ohcf, ohcv, rotor |
| curb-weight | Feature | Continuous | no | continuous from 1488 to 4066 |
| height | Feature | Continuous | no | continuous from 47.8 to 59.8 |
| width | Feature | Continuous | no | continuous from 60.3 to 72.3 |
| length | Feature | Continuous | no | continuous from 141.1 to 208.1 |
| wheel-base | Feature | Continuous | no | continuous from 86.6 120.9 |
| engine-location | Feature | Binary | no | front, rear |
| drive-wheels | Feature | Categorical | no | 4wd, fwd, rwd |
| body-style | Feature | Categorical | no | hardtop, wagon, sedan, hatchback, convertible |
| num-of-doors | Feature | Integer | yes | four, two |
| aspiration | Feature | Binary | no | std, turbo |
| fuel-type | Feature | Binary | no | diesel, gas |
| make | Feature | Categorical | no | alfa-romero, audi, bmw, chevrolet, dodge, honda, isuzu, jaguar, mazda, mercedes-benz, mercury, mitsubishi, nissan, peugot, plymouth, porsche, renault, saab, subaru, toyota, volkswagen, volvo |
| normalized-losses | Feature | Continuous | yes | continuous from 65 to 256 |
| symboling | Target | Integer | no | -3, -2, -1, 0, 1, 2, 3 |
