#!/bin/bash
# https://www.element14.com/community/community/raspberry-pi/raspberrypi_projects/blog/2016/03/11/a-more-powerful-plex-media-server-using-raspberry-pi-3
VERSION=stretch #jessie
USER=pi
GROUP=pi

# Disk mounting options
LIBRARY=library
DISK=${1:-sda1}
FORMAT=${2:-ext4} #exfat #vfat ntfs


# Update packages and distribution
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get update && sudo apt-get dist-upgrade

# Install dependencies, key and Plex package
sudo apt-get update && sudo apt-get install apt-transport-https binutils -y --force-yes
wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | sudo apt-key add -
echo "deb https://dev2day.de/pms/ $VERSION main" | sudo tee /etc/apt/sources.list.d/pms.list
sudo apt-get update  # Necessary after adding the new repository
sudo apt-get install -t $VERSION plexmediaserver -y
#sudo apt-get update && sudo apt-get upgrade -y

# Install transcoders
sudo apt-get install mkvtoolnix libexpat1 ffmpeg -y
sudo service plexmediaserver restart

# Fix permissions
sudo usermod -aG $USER plex
sudo usermod -aG plex $GROUP

echo "Plex server installation complete!"

echo "This will mount disk $DISK with the filesystem $FORMAT"
DEFAULT="Y"
read -e -i "$DEFAULT" -n 1 -p "Is this correct? [Y/n]: " REPLY
REPLY="${REPLY:-$DEFAULT}"
if [[ $REPLY =~ ^[Yy]$ ]];
then

    # Install drivers if necessary
    if [ "$FORMAT" == "ntfs" ]; then
        sudo apt-get install ntfs-3g -y
    elif [ "$FORMAT" == "exfat" ]; then
        sudo apt-get install exfat-fuse exfat-utils -y
    fi

    # Edit fstab to automount at startup
    # http://www.htpcguides.com/properly-mount-usb-storage-raspberry-pi/
    sudo mkdir /mnt/$LIBRARY
    echo "/dev/$DISK    /mnt/$LIBRARY   $FORMAT   defaults    0    0" | sudo tee -a /etc/fstab
    # uid=pi,gid=pi,noatime

    # Set permissions
    sudo chown -R $USER:$GROUP /mnt/$LIBRARY
    sudo chmod 775 -R /mnt/$LIBRARY
    sudo setfacl -Rdm g:$GROUP:rwx /mnt/$LIBRARY
    sudo setfacl -Rm g:$GROUP:rwx /mnt/$LIBRARY

    # Mount USB storage
    sudo mount -o uid=$USER,gid=$GROUP /dev/$DISK /mnt/$LIBRARY

else
    echo "Skipping disk mounting..."
fi


# Upgrade firmware and reboot
read -p "Update firmware and reboot now? [Y/n] " -n 1 -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]];
then
    sudo apt-get update && sudo rpi-update
    sudo apt-get autoremove && sudo apt-get clean && sudo reboot
else
    echo "Please reboot manually before configuring Plex in a browser. Exiting!"
fi
