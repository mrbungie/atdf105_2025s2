# Estudiantes: Solo para documentacion de como generar el dataset, no es necesario correr esto!.from ucimlrepo import fetch_ucirepo 

#! pip install ucimlrepo
from ucimlrepo import fetch_ucirepo 
  
# fetch dataset 
adult = fetch_ucirepo(id=2) 

X = adult.data.features
X["income_status"] = adult.data.targets
X.to_csv("adult.csv", index=False)