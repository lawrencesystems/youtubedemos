# Based on UI documentation https://help.ui.com/hc/en-us/articles/220066768-UniFi-How-to-Install-and-Update-via-APT-on-Debian-or-Ubuntu

# Install base needs and java 11
echo "deb http://deb.debian.org/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/bullseye.list # Needed for Debian 12 openjdk-11-jre-headless no longer in distro
sudo apt-get update && sudo apt-get install ca-certificates apt-transport-https openjdk-11-jre-headless gnupg

# Add Ubiquiti & Mongo to the sources
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
echo "deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Add trust for Ubiquiti and Mongo sources
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

# Hold the java version for compatability so it does not break with updates
sudo apt-mark hold openjdk-11-*

# To get rid of the depricated apt key message on future apt updates: 
# run sudo apt-key list and take the last 8 digits of the mongodb key shown here as 90CFB1F5
sudo apt-key export 90CFB1F5 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/mongodb.gpg

# Install the UniFi controller
sudo apt-get update && sudo apt-get install unifi -y
