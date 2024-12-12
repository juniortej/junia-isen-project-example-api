FROM python:3.10

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier le fichier requirements.txt dans le conteneur
COPY requirements.txt .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste des fichiers de l'application dans le conteneur
COPY . .

# Exposer le port utilisé par l'application
EXPOSE 8080

# Commande pour lancer l'application avec Uvicorn
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8080"]
