#!/bin/bash
# Vérifier que l'utilisateur est bien en ROOT avant de commencer les différentes étapes du script.
# SI "$UTILISATEUR" n'est pas ROOT
# ALORS
# 	Afficher un message d'erreur
# SINON
# 	Utilisateur ROOT confirmé !
# FIN SI
#
#
if [ "$EUID" -ne 0 ]
then
	echo "Merci de vous connecter avec l'utilisateur ROOT pour lancer le script !!"
	exit 1
else
	echo "Utilisateur ROOT confirmé !! lancement du script"
fi

# Installation de la Debian étant installée sur une machine virtuelle, souvent le dépôt CD-ROM est actif, il faut le commenter.
# Utilisation de la commande === sed === pour rechercher et remplacer par un dièse en début de ligne dans le fichier cible === etc/apt/sources.list le dépôt CD-ROM.
echo "Commenter le fichier sources.list afin d'effectuer les mises à jour et installation des paquets." 

sed -i 's/^deb cdrom/#deb cdrom' /etc/apt/sources.list

# Installation des mises à jour ainsi que des dépôts nécessaires.

echo "Installation des paquets et des mises à jour"

apt update && upgrade -y
apt install sudo vim python3-venv openssh-server -y

# Créer une variable pour l'utilisateur ansible ainsi que l'ajouter au groupe sudo.
# SI "Utilisateur" existe
# ALORS
# 	Afficher message utilisateur déjà existant
# SINON
# 	Créer l'utilisateur ainsi que son dossier personnel et son mot de passe.
# FIN SI

echo "Vérification de l'existence de l'utilisateur ansible ou création d'un autre utilisateur."
read -p "Nom de l'utilisateur: " MY_USER

if id "$MY_USER" &>/dev/null
then
	echo "L'utilisateur $My_USER existe déjà. Ajout au groupe sudo..."
	usermod -aG sudo $MY_USER
else
	echo "Saisir le mot passe de l'utilisateur ATTENTION le mot de passe ne s'affiche pas !!"
	read -s PASS
	echo ""

	useradd $MY_USER --create-home --groups sudo --shell /bin/bash
	echo "$MY_USER:$PASS" | chpasswd

	echo "L'utilisateur $MY_USER a été créé et configuré avec succès !"
fi

# Créer un environnement virtuel avec python3-venv et installer ansible dedans.
echo "Merci de saisir le nom du dossier de l'environnement virtuel"
read FOLDER_NAME
echo ""

python3 -m venv /home/$MY_USER/$FOLDER_NAME
echo "Création de environnement $FOLDER_NAME réussi !!"

echo "Modifier le propriétaire du dossier contenant l'environnement virtuelle $FOLDER_NAME."
chown -R $MY_USER:$MY_USER /home/$MY_USER/$FOLDER_NAME

echo "Activation et installation ansible dans l'environnement virtuelle $FOLDER_NAME."
/home/$MY_USER/$FOLDER_NAME/bin/pip install ansible

echo "Tous est prêt l'environnement se trouve dans /home/$MY_USER/$FOLDER_NAME"

# Désactiver le compte ROOT

echo "Désactiver le compter root !"
passwd -l root

echo "Fin du script et de installation de base du sytème."
