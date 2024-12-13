# Shop App API sur Azure Cloud avec Terraform

Ce projet est une API python déployée sur Azure en utilisant Terraform.

## Membres du groupe

- Théodore BONDON
- Marie DEVULDER
- Nicolas GROUSSEAU
- Alexis MALLET
- Mathilde RIGAUD

Dans le cadre du cours de Cloud Computing à JUNIA ISEN M2 sous la supervision de Junior TAGNE

## Présentation du projet

Le projet consiste à déployer une API Flask en Python sur Azure Cloud en utilisant Terraform. L'API permet de gérer des produits, des utilisateurs et des paniers. 

### Structure du projet

- `api/`: Contient le code de l'API Flask en Python.
- `infrastructure/`: Contient le code Terraform pour provisionner l'infrastructure Azure.
- `.github/`: Contient les workflows GitHub Actions pour le CI/CD.

### Fonctionnalités de l'API

L'API permet de gérer des produits, des utilisateurs et des paniers. Voici les différentes routes disponibles :

- `/`: Route de base de l'API affichant un message de bienvenue. 
- `/items`: Route permettant de récupérer la liste des produits.
- `/users`: Route permettant de récupérer la liste des utilisateurs.
- `/baskets`: Route permettant de récupérer la liste des paniers.

### Terraform

Le code Terraform est divisé en différents modules :

##### Resource Group
Ce module crée un groupe de ressources Azure pour contenir toutes les ressources nécessaires à l'application. Il définit le nom et l'emplacement du groupe de ressources.

##### Virtual Network
Ce module configure un réseau virtuel (VNet) pour permettre la communication sécurisée entre les différentes ressources de l'application. Il inclut la création de sous-réseaux et la configuration des règles de sécurité réseau.

##### App Service
Ce module déploie l'API Flask sur Azure App Service, fournissant une plateforme d'hébergement web scalable et managée. Il configure les paramètres de l'application, tels que les variables d'environnement et les paramètres de déploiement.

##### Database
Ce module crée une base de données Azure SQL pour stocker les données des produits, des utilisateurs et des paniers. Il configure le serveur SQL, la base de données et les règles de pare-feu pour permettre l'accès sécurisé.

##### Blob Storage
Ce module configure un compte de stockage Azure Blob pour stocker des fichiers et des objets volumineux. Il définit les conteneurs de stockage et les règles d'accès.

##### Application Gateway
Ce module déploie une passerelle d'application Azure pour gérer le trafic entrant et assurer la répartition de charge et la sécurité. Il configure les règles de routage, les certificats SSL et les paramètres de sécurité.

##### Terraform Tests

Le fichier `module_testing.tftest.hcl` situé dans le dossier `tests` contient les tests pour vérifier la création et la configuration des ressources Azure. Voici les différents tests effectués :
| Test  | Principe          | 
| :--------------- |:---------------| 
| **input_validation**          |   Vérifie la validation des entrées avec la commande `plan`.          |
| **setup_resource_group**      |   Applique la configuration pour créer le groupe de ressources.       |  
| **test_virtual_network**      |   Vérifie la création du réseau virtuel.                              |  
| **test_database**            |   Vérifie la création de la base de données.                          |
| **test_blob_storage**         |      Vérifie la création du compte de stockage Blob.                  |
| **test_application_gateway**  | Vérifie la création de l'Application Gateway.                         |
| **test_app_service**          |   Vérifie la création du service d'application.                       |

Chaque test utilise des assertions pour s'assurer que les ressources sont correctement créées et configurées. Par exemple, le test `test_virtual_network` vérifie que l'ID du réseau virtuel est disponible, sinon il affiche un message d'erreur "Virtual network not created".




Comment appliquer les tests :

Si ```terraform apply``` a déjà été appliquée alors détruire les resources existantes avec la commande :
```terraform destroy```
1. Se rendre dans le dossier 
```infrastructure/```
2. Insérer votre ```subscription_id``` à la ligne 4 du fichier ```module_testing.tftest.hcl```
3. Initialiser Terraform avec la commande :
```terraform init```
4. Lancer les tests avec la commande :
```terraform test```
5. Détruire les ressources, une fois tous les tests passés, avec la commande :
```terraform destroy```



### Prérequis
- Python 3.8 et +
- Flask
- Terraform 
- Un compte Azure

### Comment déployer le projet sur Azure

1. Cloner le projet
2. Se rendre dans le dossier `infrastructure/`
3. Initialiser Terraform avec la commande `terraform init`
4. Créer un fichier `terraform.tfvars` et y renseigner les variables suivantes :
    ```
    subscription_id = "ID de l'abonnement Azure"
    ```
5. Appliquer les changements avec la commande `terraform apply`
6. Dans l'output de la commande, récupérer l'IP publique de l'application gateway et se rendre sur l'URL `http://<IP_PUBLIQUE>/` pour accéder à l'API.

### Github Actions

#### Tests

A chaque push et pull request sur la branche `main`, les tests sur l'API sont lancés.
Rendez-vous dans le fichier `api/tests/test_app.py` pour voir les différents tests.
Le fichier `.github/workflows/test.yml` contient le workflow GitHub Actions pour les tests.

#### Build et déploiement

A chaque push sur la branche `main`, une image Docker est buildée et pushée grâce à un Docker Registry de GitHub. 
Pour le déploiement, nous n'avons pas réussi à l'implémenter. Nos tests sont en commentaires dans notre fichier.
Le fichier `.github/workflows/build-app.yml` contient le workflow GitHub Actions pour le build et le déploiement de l'API.

