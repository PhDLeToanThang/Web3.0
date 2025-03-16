# Anti-virus: clamav
# Installing ClamAV
sudo apt-get update -y
sudo apt-get install clamav clamav-daemon -y
clamscan --version
Sudo systemctl stop clamav-freshclam
sudo freshclam
ls /var/lib/clamav/daily.cvd
sudo systemctl start clamav-freshclam
man clamscan
sudo clamscan --infected --recursive --remove /
apt search clamav 

#Installing ClamTK
sudo apt install clamtk -y
sudo apt install clamtk-gnome -y 
