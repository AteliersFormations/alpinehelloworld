FROM python:3.11-slim

# Installer les dépendances système
RUN apt-get update && apt-get install -y --no-install-recommends bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copier les fichiers nécessaires
COPY ./webapp/requirements.txt /tmp/requirements.txt

# Installer les dépendances Python
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Ajouter l'application
COPY ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Configurer l'utilisateur non-root
RUN useradd -m myuser && chown -R myuser:myuser /opt/webapp
USER myuser

# Définir la variable d'environnement pour le port
ENV PORT=5000

# Commande de lancement
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "wsgi"]
