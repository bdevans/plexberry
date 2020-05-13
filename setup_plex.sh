#!/bin/bash
# https://www.element14.com/community/community/raspberry-pi/raspberrypi_projects/blog/2016/03/11/a-more-powerful-plex-media-server-using-raspberry-pi-3
# VERSION=buster #stretch #jessie

# Set user and group for running plex
USER=pi
GROUP=pi

# Disk mounting options
DISK=${1:-sda1}
FORMAT=${2:-ext4} #exfat #vfat ntfs
LIBRARY=${3:-library} # Directory name for library

echo "This will mount disk $DISK at /mnt/$LIBRARY with the filesystem $FORMAT"
read -p "Is this correct? " -n 1 -r
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
    # do dangerous stuff
#fi

# Update packages and distribution
sudo apt update && sudo apt upgrade -y
sudo apt update && sudo apt full-upgrade

# Install dependencies, key and Plex package
sudo apt update && sudo apt install apt-transport-https binutils -y --force-yes
wget -O - https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update # Necessary after adding the new repository
sudo apt install plexmediaserver -y
# TODO: Replace with sed command to uncomment existing line
echo deb https://downloads.plex.tv/repo/deb/ public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
#sudo apt update && sudo apt upgrade -y


# Install transcoders
sudo apt install mkvtoolnix libexpat1 ffmpeg -y
sudo sed -i "s/PLEX_MEDIA_SERVER_USER=plex/PLEX_MEDIA_SERVER_USER=$USER/g" /etc/default/plexmediaserver
sudo systemctl restart plexmediaserver
# sudo service plexmediaserver restart

# Fix permissions
# sudo usermod -aG $GROUP plex
# sudo usermod -aG plex $USER

echo "Plex server installation complete!"

echo "This will mount disk $DISK with the filesystem $FORMAT"
DEFAULT="Y"
read -e -i "$DEFAULT" -n 1 -p "Is this correct? [Y/n]: " REPLY
REPLY="${REPLY:-$DEFAULT}"
if [[ $REPLY =~ ^[Yy]$ ]];
then

    # Install drivers if necessary
    if [ "$FORMAT" == "ntfs" ]; then
        sudo apt install ntfs-3g -y
    elif [ "$FORMAT" == "exfat" ]; then
        sudo apt install exfat-fuse exfat-utils -y
    fi

    # Edit fstab to automount at startup
    # http://www.htpcguides.com/properly-mount-usb-storage-raspberry-pi/
    sudo mkdir /mnt/$LIBRARY
    echo "/dev/$DISK    /mnt/$LIBRARY   $FORMAT   defaults    0    0" | sudo tee -a /etc/fstab
    # uid=pi,gid=pi,noatime

    # Set permissions
    sudo chown -R $USER:$GROUP /mnt/$LIBRARY
    sudo chmod 775 -R /mnt/$LIBRARY
    if [ -x "$(command -v setfacl)" ]; then
        # Set Access Control Lists if installed
    	sudo setfacl -Rdm g:$GROUP:rwx /mnt/$LIBRARY
    	sudo setfacl -Rm g:$GROUP:rwx /mnt/$LIBRARY
    fi

    # Mount USB storage
    sudo mount -o uid=$USER,gid=$GROUP /dev/$DISK /mnt/$LIBRARY

else
    echo "Skipping disk mounting..."
fi


# Upgrade firmware and reboot
read -p "Update firmware and reboot now? [Y/n] " -n 1 -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]];
then
    sudo apt update && sudo rpi-update
    sudo apt autoremove && sudo apt clean && sudo reboot
else
    echo "Please reboot manually before configuring Plex in a browser. Exiting!"
fi
