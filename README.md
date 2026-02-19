# Déploiement Automatisé : Infrastructure MediaWiki pour PME

# Présentation du Projet
Ce projet vise à automatiser la mise en place d'une infrastructure de base documentaire pour une petite entreprise en utilisant MediaWiki.

L'objectif est de passer d'une machine vierge à un serveur fonctionnel et sécurisé en un minimum d'actions manuelles, tout en respectant les bonnes pratiques d'administration système (isolation, gestion des droits, sécurité).

# l'infrastructure du projet 

1. Un serveur Debian 13 avec Ansible installé dans un environnement isolé avec Python3-venv
3. Un serveur Debian 13 avec un serveur web Apache et PHP.
4. Un serveur Debian 13 avec la BDD MariaDB.

Les 3 serveurs seront intégralement configurés à l'aide de scripts. Chacun de ces scripts se trouve dans le dossier /scripts.

Les 3 serveurs seront directement configurés en bridge sous VMWARE afin de déployer ces scripts sans configuration SSH au début à l'aide d'un serveur web Python depuis la machine hôte de VMWARE.

- Utilisation de la commande -python -m http.server 8000- pour lancer un serveur web et télécharger le script de la machine hôte à la VM.
- Utilisation de la commande wget http://ip_hote:8000/script pour télécharger le  script sur la vm.

## Nommage des serveurs
RFC1178

1. thor ==> DEBIAN ANSIBLE
2. freya ==> DEBIAN APACHE et PHP
3. zeus ==> DEBIAN MARIADB
