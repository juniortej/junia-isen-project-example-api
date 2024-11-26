#!/bin/bash

INFRA_DIR="infrastructure"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

error_exit() {
  echo -e "${RED}✖ $1${NC}"
  exit 1
}


success_message() {
  echo -e "${GREEN}✔ $1${NC}"
}

if ! command -v terraform &>/dev/null; then
  error_exit "Terraform n'est pas installé. Veuillez l'installer avant de continuer."
fi

cd "$INFRA_DIR" || error_exit "Le dossier $INFRA_DIR est introuvable."

echo -e "${YELLOW}Initialisation de Terraform...${NC}"
terraform init || error_exit "Échec de l'initialisation de Terraform."

echo -e "${YELLOW}Validation de la configuration Terraform...${NC}"
terraform validate || error_exit "La validation Terraform a échoué."

echo -e "${YELLOW}Formatage des fichiers Terraform...${NC}"
terraform fmt -recursive || error_exit "Échec du formatage des fichiers Terraform."

echo -e "${YELLOW}Génération du plan Terraform...${NC}"
terraform plan -out=tfplan || error_exit "Échec de la génération du plan Terraform."

echo -e "${YELLOW}Application du plan Terraform...${NC}"
terraform apply -auto-approve tfplan || error_exit "Échec de l'application du plan Terraform."

rm -f tfplan

success_message "Déploiement terminé avec succès."
