# Based on UI documentation https://help.ui.com/hc/en-us/articles/220066768-UniFi-How-to-Install-and-Update-via-APT-on-Debian-or-Ubuntu

# Install base needs and java 11
sudo apt-get update && sudo apt-get install ca-certificates apt-transport-https openjdk-11-jre-headless

# Add Ubiquiti & Mongo to the sources
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Add trust for Ubiquiti and Mongo sources
wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

# Hold the java version for compatability so it does not break with updates
sudo apt-mark hold openjdk-11-*

# Install the UniFi controller
sudo apt-get update && sudo apt-get install unifi -y
