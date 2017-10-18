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

* Backup or transfer media with [rsync](https://www.computerhope.com/unix/rsync.htm)
```rsync [options] SOURCE DESTINATION```

	* For uploading e.g.:
	```rsync -rtvhP ~/Music pi@plexberry.local:/mnt/library/```
	
	* Spaces in the folder names:
	```rsync -rtvhP ~/TV/Series3 pi@plexberry.local:"/mnt/library/TV/Arrested\ Development/"```

	* For backup:
	```rsync -avhP /mnt/library user@nas.local:/mnt/backup/```

## Useful general guides

* https://www.htpcguides.com/install-plex-media-server-raspberry-pi-3-image/
* https://pimylifeup.com/raspberry-pi-plex-server/
* https://www.reddit.com/r/PleX/comments/41z6ff/raspberry_pi2_as_a_pms_tutorial_and_infos_inside/
* https://www.htpcguides.com/arm-pi-media-server-installer-images-download-page/
* https://github.com/alexandregz/awesome-raspberrypi/blob/master/README.md

## Building the plex server

1. Hardware
    * Boards - the guide assumes you are using a Raspberry Pi 3 but here are some others to consider:
       * Benchamrks and comparison 
          - [Benchmarks of nine boards](http://www.phoronix.com/scan.php?page=article&item=raspberry-pi-3&num=1)
          - http://www.makeuseof.com/tag/best-prebuilt-diy-nas-solutions-plex-server/ 
          - https://en.wikipedia.org/wiki/Comparison_of_single-board_computers 
          - (Passmark > 2000 for 1080p transcoding https://www.cpubenchmark.net) 
          - https://beebom.com/best-raspberry-pi-3-alternatives/
       * [Raspberry Pi 3](https://www.raspberrypi.org/products/#buy-now-modal)
       * [Rock64](https://www.pine64.org/?page_id=7147)
       * [ODROID-C2](https://www.odroid.co.uk/odroid-c2-cat/hardkernel-odroid-c2-board)
       * [ODROID-XU4Q](https://www.odroid.co.uk/index.php?route=product/product&product_id=813)
       * [Banana Pi M3](http://www.banana-pi.org/m3.html)
       * [Intel NUC](https://www.intel.co.uk/content/www/uk/en/products/boards-kits/nuc.html)
       * [nVidia Shield Pro](https://www.nvidia.com/en-us/shield/)
       * [Orange Pi](http://www.orangepi.org/orangepiplus2/)
       * [NanoPC-T3](http://www.friendlyarm.com/index.php?route=product/product&path=69&product_id=123)
       * [PixiePro](https://store.treats4geeks.com/index.php/pixiepro-27.html)
       * [HummingBoard](https://www.solid-run.com/)
       * [UDOO x86 Ultra](https://shop.udoo.org/eu/x86/udoo-x86-ultra.html?___from_store=eu&popup=no)

    * SD Cards: http://elinux.org/RPi_SD_cards
    * USB hubs: http://elinux.org/RPi_Powered_USB_Hubs

2. Install an OS

* Raspbian
    - https://www.raspberrypi.org/documentation/installation/installing-images/
    - e.g. using [macOS](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)
    - `diskutil list`
    - `diskutil unmountDisk /dev/disk2`
    - `sudo dd bs=1m if=~/Downloads/2016-05-27-raspbian-jessie.img of=/dev/rdisk2`

* Ready-made images
   - https://github.com/igorpecovnik/Debian-micro-home-server
   - http://www.htpcguides.com/arm-pi-media-server-installer-images-download-page/
   - http://www.htpcguides.com/raspberry-pi-2-home-media-server-installer-image/

* Try MINIBIAN for a minimal OS.
    - http://minibianpi.wordpress.com/
    - https://sourceforge.net/projects/minibian/
    - http://www.htpcguides.com/lightweight-raspbian-distro-minibian-initial-setup/
```
apt-get update
apt-get install nano sudo rpi-update raspi-config usbutils dosfstools -y
apt-get remove initramfs-tools -y
```

### Expand SD Filesystem and Overclock
```
raspi-config
reboot
```

### Update Raspberry Pi Firmware
```
rpi-update
reboot
```

### Update the packages and distribution
```
apt-get upgrade -y
apt-get dist-upgrade -y
```

### Optional WiFi tools
`apt-get install firmware-linux-nonfree wireless-tools wpasupplicant -y`

### Add the user
```
adduser pi
usermod -a -G sudo pi
```

### Optional install GUI then enable boot to desktop
```
sudo apt-get install lxde -y
sudo raspi-config
```

### Clean the packages
`sudo apt-get clean`

### Change the password
`passwd`

### Setup ssh keys for passwordless login
* [Guide](https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/) to create and install keys. 
* See also [here](https://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/) for setting up shortcuts (with options) for remote server access. 

3. Install Plex server
    - http://www.htpcguides.com/install-plex-media-server-raspberry-pi-2-3-manually/
    * Edit then run `setup_plex.sh` (edit for the attached hard disk type)
    * Set static IP address and change hostname

4. Setup transcoding
   * You should set Plex to use your external hard drive for temporary transcoding data after you have mounted your drives properly.
   * Click the settings icon in the top right, Click Server and then Transcoder in the left pane.
   * Make sure SHOW ADVANCED is enabled underneath Server.
   * Scroll down to Transcoder temporary directory and set your USB external drive’s mount path (e.g. /mnt/usbstorage not /dev/sda1)
   * Scroll down further and hit Save Changes

5. [Mount a harddisk](https://devtidbits.com/2013/03/21/using-usb-external-hard-disk-flash-drives-with-to-your-raspberry-pi/)
   * http://www.htpcguides.com/properly-mount-usb-storage-raspberry-pi/
   * http://www.raspberrypi-spy.co.uk/2014/05/how-to-mount-a-usb-flash-disk-on-the-raspberry-pi/
   * https://devtidbits.com/2013/03/21/using-usb-external-hard-disk-flash-drives-with-to-your-raspberry-pi/
   * https://www.raspberrypi.org/forums/viewtopic.php?t=38429
   
   ```
   dmesg
   ls -l /dev/disk/by-uuid/
   sudo blkid
   sudo fdisk -l
   cat /proc/mounts
   ```
   * Test fstab
   ```
   sudo mount -a
   mount_disk.sh sda1 ext4 library
   ```
   * Get format automatically? library is optional
   * Move cache to external harddisk

   * Backup media with `rsync [options] SOURCE DESTINATION`
   ```rsync -arvhP /mnt/backup/Music /mnt/library/```

6. Setup a TV tuner
   * Client
       * http://kodi.wiki/view/PVR
       * https://linuxtv.org
       DVB-T
       * https://linuxtv.org/wiki/index.php/DVB-T_USB_Devices
       * https://www.raspberrypi.org/forums/viewtopic.php?f=35&t=18838
       dmesg | grep dvb-usb
       * http://www.hauppauge.co.uk/site/support/support_all.html?prod=30
   * Plex server
       * https://forums.plex.tv/discussion/139628/plex-and-tv-tuners
       * https://www.reddit.com/r/PleX/comments/2zhap7/plex_and_ota_tuners/
       * HDHomerun https://www.silicondust.com/hdhomerun/ using the HDHR View Plugin (requires Plex Pass)
       * https://tvheadend.org
           - https://tvheadend.org/projects/tvheadend/wiki/AptRepository
       * http://www.mumudvb.net wget http://www.mumudvb.net/release/mumudvb_2-1_armhf.deb
       * https://www.mythtv.org/wiki/Raspberry_Pi
       * http://dvblogic.com/en/dvblink/

7. Move
    a) transcoding cache and
    b) metadata: /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Metadata/

    to Harddisk before adding folders
   * Click the settings icon in the top right, Click Server and then Transcoder in the left pane.
   * Make sure SHOW ADVANCED is enabled underneath Server.
   * Scroll down to Transcoder temporary directory and set your USB external drive’s mount path (e.g. /mnt/usbstorage not /dev/sda1)
   * Scroll down further and hit Save Changes
   * https://smyl.es/how-to-move-plex-metadata-and-index-data-to-new-driver-andor-directory-location/

8. Open http://ip.address:32400/web and add media folders.
To manually start the plex server:
`sudo bash /usr/lib/plexmediaserver/start.sh &`

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

13. [Setup handbrake to automatically transcode files offline](https://github.com/sladebaumann/raspberry-plex)
    * https://www.rapidseedbox.com/kb/beginners-guide-handbrake
    * https://forums.plex.tv/discussion/comment/1335697/#Comment_1335697
    * https://b3n.org/automatic-ripping-machine/
    * https://github.com/mummybot/convert-videos-for-plex
    * https://github.com/mdhiggins/sickbeard_mp4_automator

14. [Rip DVDs to Plex](https://www.reddit.com/r/PleX/comments/5l8owa/question_best_practice_for_ripping_owned_dvds_to/)
	* Handbreak (lossy ~1GB)
	* MakeMKV (lossless ~4-8GB)

15. Re-rip CDs to FLAC (FFmpeg, lossless audio) 
    * Exact Audio Copy https://www.dbpoweramp.com/cd-ripper.htm 
    * http://tmkk.undo.jp/xld/index_e.html

16. Install HTPC Manager: http://htpc.io/
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
   * Start at boot
   ```
   sudo cp /opt/HTPCManager/initd /etc/init.d/htpcmanager
   sudo nano /etc/init.d/htpcmanager
   >> APP_PATH=/opt/HTPCManager
   sudo chmod +x /etc/init.d/htpcmanager
   sudo update-rc.d htpcmanager defaults
   ```

Access: http://ip.address:8085

17. Setup Dynamic DNS
	https://www.duckdns.org/install.jsp
	https://www.dynu.com/en-US/
	https://www.duiadns.net/personal-account
	https://www.clearos.com/products/purchase/clearos-marketplace-apps/cloud/Dynamic_DNS

18. Other useful services
   * vsftpd
   * NFS
   * Samba
   * nginx for reverse proxy: http://www.htpcguides.com/?s=reverse+proxy

19. [Heatsink for Raspberry Pi](https://www.amazon.co.uk/GorillaPi-Raspberry-aluminium-Significant-Advantage/dp/B01FY9196K)


Plex Clients and Supported Media Formats
========================================

See [here](https://support.plex.tv/hc/en-us/articles/203810286-What-media-formats-are-supported-) for a list of supported media formats and support from built-in TV clients. 

Ideally videos should be **MP4** containers with **H.264** (or H.265) video encoding and **AAC** audio encoding. 

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

Honourable mentions
===================

Some other media servers/organisers to consider include:
* MediaPortal (Includes TV recording, Windows only) http://www.team-mediaportal.com
* MythTV https://www.mythtv.org (also has a plugin for Kodi)
* Emby (clone of plex)
* https://github.com/RasPlex/OpenPHT (Fork of RasPlex)
