Plexberry
=========

A guide to setting up a plex media server on a Raspberry Pi.

This is a collection of ideas and notes (largely adapted from [element14.com](https://www.element14.com/community/community/raspberry-pi/raspberrypi_projects/blog/2016/03/11/a-more-powerful-plex-media-server-using-raspberry-pi-3) and [htpcguides.com](https://www.htpcguides.com/install-plex-media-server-raspberry-pi-3-image/)) for installing and configuring plex on a Raspberry Pi 3. Use at your own risk!

The accompanying script `setup_plex.sh` is designed to install and configure plex on a Raspberry Pi installed with Raspbian.

## Useful commands

* To fully update the system (including firmware):
```
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo rpi-update
sudo apt-get autoremove && sudo apt-get clean && sudo reboot
```

* Check attached disks
`lsblk`

* Backup or transfer media
`rsync [options] SOURCE DESTINATION`
`rsync -arvhP /mnt/backup/Music /mnt/library/`

## Useful links

* https://www.reddit.com/r/PleX/comments/41z6ff/raspberry_pi2_as_a_pms_tutorial_and_infos_inside/
* http://www.htpcguides.com/install-plex-media-server-on-raspberry-pi-2/
* http://www.htpcguides.com/install-plex-media-server-on-banana-pi-with-bananian/
* http://www.htpcguides.com/raspberry-pi-2-home-media-server-installer-image/
* http://www.htpcguides.com/raspberry-pi-2-media-server-image-2015-released/
* https://devtidbits.com/2013/03/21/using-usb-external-hard-disk-flash-drives-with-to-your-raspberry-pi/
* https://pimylifeup.com/raspberry-pi-plex-server/
* https://www.htpcguides.com/arm-pi-media-server-installer-images-download-page/

* https://www.htpcguides.com/install-plex-media-server-raspberry-pi-3-image/
* https://github.com/alexandregz/awesome-raspberrypi/blob/master/README.md


1. Hardware
    * >> Benchmarks of nine boards:  http://www.phoronix.com/scan.php?page=article&item=raspberry-pi-3&num=1
    * Raspberry Pi 2
    * Raspberry Pi 3
    * ODROID-C2
    * Banana Pi M3 http://www.banana-pi.org/m3.html
    * NanoPC-T3 http://www.friendlyarm.com/index.php?route=product/product&path=69&product_id=123
    * PixiePro https://store.treats4geeks.com/index.php/pixiepro-27.html
    * HummingBoard https://www.solid-run.com/

    SD Cards: http://elinux.org/RPi_SD_cards
    USB hubs: http://elinux.org/RPi_Powered_USB_Hubs

2. Install an OS
* Try MINIBIAN for a minimal OS.
    - http://minibianpi.wordpress.com/
    - https://sourceforge.net/projects/minibian/
    - http://www.htpcguides.com/lightweight-raspbian-distro-minibian-initial-setup/
```
apt-get update
apt-get install nano sudo rpi-update raspi-config usbutils dosfstools -y
apt-get remove initramfs-tools -y
```

## Expand SD Filesystem and Overclock
```
raspi-config
reboot
```

## Update Raspberry Pi Firmware
```
rpi-update
reboot
```

## Update the packages and distribution
```
apt-get upgrade -y
apt-get dist-upgrade -y
```

## Optional WiFi tools
`apt-get install firmware-linux-nonfree wireless-tools wpasupplicant -y`

## Add the user
```
adduser pi
usermod -a -G sudo pi
```

## Optional install GUI then enable boot to desktop
```
sudo apt-get install lxde -y
sudo raspi-config
```

## Clean the packages
`sudo apt-get clean`

- http://www.htpcguides.com/install-plex-media-server-raspberry-pi-2-3-manually/

* Raspbian
    - https://www.raspberrypi.org/documentation/installation/installing-images/mac.md
    * diskutil list
    * diskutil unmountDisk /dev/disk2
    * sudo dd bs=1m if=~/Downloads/2016-05-27-raspbian-jessie.img of=/dev/rdisk2

## Ready-made images
* https://github.com/igorpecovnik/Debian-micro-home-server
* http://www.htpcguides.com/arm-pi-media-server-installer-images-download-page/
* http://www.htpcguides.com/raspberry-pi-2-home-media-server-installer-image/


* Expand the filesystem
```
sudo raspi-config
sudo reboot
```

* Change the password
`passwd`

3. Install Plex server
    * setup_plex.sh
    * Set static IP address and change hostname

4. Setup transcoding
You should set Plex to use your external hard drive for temporary transcoding data after you have mounted your drives properly.
Click the settings icon in the top right, Click Server and then Transcoder in the left pane.
Make sure SHOW ADVANCED is enabled underneath Server.
Scroll down to Transcoder temporary directory and set your USB external drive’s mount path (e.g. /mnt/usbstorage not /dev/sda1)
Scroll down further and hit Save Changes

5. Mount a harddisk
http://www.htpcguides.com/properly-mount-usb-storage-raspberry-pi/
http://www.raspberrypi-spy.co.uk/2014/05/how-to-mount-a-usb-flash-disk-on-the-raspberry-pi/
https://devtidbits.com/2013/03/21/using-usb-external-hard-disk-flash-drives-with-to-your-raspberry-pi/
https://www.raspberrypi.org/forums/viewtopic.php?t=38429
```
dmesg
ls -l /dev/disk/by-uuid/
sudo blkid
sudo fdisk -l
cat /proc/mounts
```
## Test fstab
```
sudo mount -a
mount_disk.sh sda1 ext4 library
```
## Get format automatically? library is optional
    * Move cache to external harddisk

Backup media with rsync [options] SOURCE DESTINATION
`rsync -arvhP /mnt/backup/Music /mnt/library/`

6. Setup a TV tuner
* Client
    * >> http://kodi.wiki/view/PVR
    * >> https://linuxtv.org
    DVB-T
    * https://linuxtv.org/wiki/index.php/DVB-T_USB_Devices
    * https://www.raspberrypi.org/forums/viewtopic.php?f=35&t=18838
    dmesg | grep dvb-usb
    * http://www.hauppauge.co.uk/site/support/support_all.html?prod=30
* Plex server
    * >> https://forums.plex.tv/discussion/139628/plex-and-tv-tuners
    * >> https://www.reddit.com/r/PleX/comments/2zhap7/plex_and_ota_tuners/
    * HDHomerun https://www.silicondust.com/hdhomerun/ using the HDHR View Plugin (requires Plex Pass)
    *** https://tvheadend.org
        - https://tvheadend.org/projects/tvheadend/wiki/AptRepository
    * http://www.mumudvb.net wget http://www.mumudvb.net/release/mumudvb_2-1_armhf.deb
    * https://www.mythtv.org/wiki/Raspberry_Pi
    * http://dvblogic.com/en/dvblink/

7. Move
    a) transcoding cache and
    b) metadata: /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Metadata/

to Harddisk before adding folders
Click the settings icon in the top right, Click Server and then Transcoder in the left pane.
Make sure SHOW ADVANCED is enabled underneath Server.
Scroll down to Transcoder temporary directory and set your USB external drive’s mount path (e.g. /mnt/usbstorage not /dev/sda1)
Scroll down further and hit Save Changes
https://smyl.es/how-to-move-plex-metadata-and-index-data-to-new-driver-andor-directory-location/

8. Open http://ip.address:32400/web and add media folders.
To manually start the plex server:
sudo bash /usr/lib/plexmediaserver/start.sh &

9. Test
Backup existing images with dd
    * Web player
    * Client player e.g. RasPlex, Kodi, OSMC, LIBREELEC, OpenELEC
    * Script to set up plex client on Kodi
        - http://www.htpcbeginner.com/kodi-and-plex-integration-with-plexbmc-addon/
        - https://github.com/hippojay/plugin.video.plexbmc/releases

10. Build a download hub
    http://www.alphr.com/raspberry-pi/raspberry-pi-2/1000043/raspberry-pi-2-18-of-the-best-projects-you-can-try-with-the

11. Set up backups
    * Mirror hard disk with scheduled rsync
    * Back up SD card with scheduled dd

12. Set DHCP reservation (internal) and configure dynamic dns (external)
* http://www.htpcguides.com/nag-free-dynamic-dns-raspberry-pi/
* https://www.dnsdynamic.org/api.php

13. Install HTPC Manager: http://htpc.io/
* http://www.htpcguides.com/install-htpc-manager-banana-pi-with-bananian/
Supports:
    * Kodi
    * Sick Beard - periodic TV show downloading
    * SABnzbd - usenet downloading
    * CouchPotato - feature length video downloading
    * Transmission - bittorrent client
    * Python
```
sudo apt-get install build-essential git python-imaging python-dev python-setuptools python-pip python-cherrypy vnstat smartmontools -y
sudo pip install psutil
sudo git clone https://github.com/Hellowlol/HTPC-Manager /opt/HTPCManager
sudo chown -R pi:pi /opt/HTPCManager
python /opt/HTPCManager/Htpc.py --daemon
```
## Start at boot
```
sudo cp /opt/HTPCManager/initd /etc/init.d/htpcmanager
sudo nano /etc/init.d/htpcmanager
>> APP_PATH=/opt/HTPCManager
sudo chmod +x /etc/init.d/htpcmanager
sudo update-rc.d htpcmanager defaults
```

Access: http://ip.address:8085

14. Other useful services
vsftpd
NFS
Samba
nginx for reverse proxy: http://www.htpcguides.com/?s=reverse+proxy


Honourable mentions
===================

MediaPortal (Includes TV recording, Windows only) http://www.team-mediaportal.com
MythTV https://www.mythtv.org (also has a plugin for Kodi)
Emby (clone of plex)
https://github.com/RasPlex/OpenPHT (Fork of RasPlex)


Client
======

* RasPlex
    - http://www.rasplex.com/get-started/download-rasplex.html
    - http://www.makeuseof.com/tag/easiest-raspberry-pi-media-centre-rasplex/
* Kodi
    - http://mymediaexperience.com/raspberry-pi-xbmc-with-raspbmc/
    - http://kodi.wiki/view/HOW-TO:Install_Kodi_on_Raspberry_Pi
    - https://www.raspberrypi.org/forums/viewtopic.php?t=99866
Script to set up plex client on Kodi
    - http://www.htpcbeginner.com/kodi-and-plex-integration-with-plexbmc-addon/
    - https://github.com/hippojay/plugin.video.plexbmc/releases
* OSMC
    - https://osmc.tv/about/
* LIBREELEC
* OpenELEC
    - http://www.htpcbeginner.com/openelec-vs-osmc-raspberry-pi/2/


Update
======

* https://www.raspberrypi.org/blog/introducing-pixel/
```
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install -y rpi-chromium-mods python-sense-emu python3-sense-emu python-sense-emu-doc
sudo apt-get install -y realvnc-vnc-viewer realvnc-vnc-server
```
