# Shop App API sur Azure Cloud avec Terraform

Ce projet est une API python déployée sur Azure en utilisant Terraform.

## Membres du groupe

- Théodore BONDON
- Marie DEVULDER
- Nicolas GROUSSEAU
- Alexis MALLET
- Mathilde RIGAUT

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

##### Virtual Network

##### App Service

##### Database

##### Blob Storage

##### Application Gateway

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

