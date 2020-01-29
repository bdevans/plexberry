#!/bin/bash
# https://www.element14.com/community/community/raspberry-pi/raspberrypi_projects/blog/2016/03/11/a-more-powerful-plex-media-server-using-raspberry-pi-3
VERSION=jessie
LIBRARY=library
DISK=${1:-sda1}
FORMAT=${2:-ext4} #exfat #vfat ntfs

echo "This will mount disk $DISK with the filesystem $FORMAT"
read -p "Is this correct? " -n 1 -r
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
    # do dangerous stuff
#fi

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get update && sudo apt-get dist-upgrade

sudo apt-get install libexpat1 -y
sudo apt-get update && sudo apt-get install apt-transport-https binutils -y --force-yes
wget -O - https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt-get update
sudo apt-get install plexmediaserver -y
sudo apt-get update && sudo apt-get upgrade -y

# Create autostart script
#cp plexmediaserver /usr/local/bin/
#chmod +x /usr/local/bin/plexmediaserver

# Create autorestart script
#cp schedule_restart /etc/init.d/plexmediaserver
#chmod +x /etc/init.d/plexmediaserver
#update-rc.d plexmediaserver defaults

# Install transcoders
#sudo service plexmediaserver stop
#PATH=/usr/lib/plexmediaserver
#PATH=/opt/plex/Application
#cd /tmp/
#mkdir libc6
#cd libc6
#wget http://ftp.us.debian.org/debian/pool/main/g/glibc/libc-bin_2.19-18+deb8u2_armhf.deb
#dpkg-deb -x libc6_2.19-18_armhf.deb ./
#cp -a lib/arm-linux-gnueabihf/libm-2.19.so $PATH
#cd $PATH
#chmod ugo+x libm-2.19.so
#unlink libm.so.6
#ln -s libm-2.19.so libm.so.6
#sudo service plexmediaserver start

sudo apt-get install mkvtoolnix libexpat1 ffmpeg -y
sudo service plexmediaserver restart

# Fix permissions
sudo usermod -aG pi plex
sudo usermod -aG plex pi

# Mount USB storage
if [ "$FORMAT" == "ntfs" ]; then
    sudo apt-get install ntfs-3g -y
elif [ "$FORMAT" == "exfat" ]; then
    sudo apt-get install exfat-fuse exfat-utils -y
fi
# http://www.htpcguides.com/properly-mount-usb-storage-raspberry-pi/
sudo mkdir /mnt/$LIBRARY
echo "/dev/$DISK    /mnt/$LIBRARY   $FORMAT   defaults    0    0" | sudo tee -a /etc/fstab
# uid=pi,gid=pi,noatime

sudo chown -R pi:pi /mnt/$LIBRARY
sudo chmod 775 -R /mnt/$LIBRARY
sudo setfacl -Rdm g:pi:rwx /mnt/$LIBRARY
sudo setfacl -Rm g:pi:rwx /mnt/$LIBRARY

sudo mount -o uid=pi,gid=pi /dev/$DISK /mnt/$LIBRARY


#sudo reboot
