```
#setup ubuntu from scrach.

############################*sudo without password###########################
echo "$USER ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER  

/etc/default/grub
GRUB_CMDLINE_LINUX=""
===>
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
sudo update-grub

fstab
/dev/sdb1              /home         ext4      defaults,noatime        0      2


############################*package###########################
sudo apt-get update
sudo apt-get install tmux wget curl
############################*setup static ip###########################
vi /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    eth0:
      addresses: [172.16.1.20/24]
      gateway4: 172.16.1.3
      nameservers:
        addresses: [172.16.1.3]
      dhcp4: no
  version: 2
  

###############*install docker###########################
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update && sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER


############################*usage scripts in .local(dkos,cd_history)###########################
mkdir ~/.local/bin/
wget -O ~/.local/bin/dkos https://raw.githubusercontent.com/joely1101/docker/master/dkos/dkos
wget -O ~/.tmux.conf https://raw.githubusercontent.com/joely1101/tools/master/.tmux.conf
chmod +x ~/.local/bin/dkos
wget -O ~/.local/bin/dkns https://raw.githubusercontent.com/joely1101/tools/master/dkns.sh
chmod +x ~/.local/bin/dkns
wget ~/.local/cd_history.sh https://raw.githubusercontent.com/joely1101/tools/master/cd_history.sh

cat >>~/.profile<<EOF
if [ -f $HOME/.local/cd_history.sh ] ;then
        . $HOME/.local/cd_history.sh
fi
EOF

sudo wget -O /etc/bash_completion.d/dkos.bash_complete https://raw.githubusercontent.com/joely1101/docker/master/dkos/dkos.bash_complete


############################*setup ftp/tftp/www/samba server###########################
samba:
sudo apt-get install -y samba
sudo smbpasswd -a $USER
sudo cat >>/etc/samba/smb.conf<<EOF
[homes]
   comment = Home Directories
   browseable = no
   read only = no
   create mask = 0700
   directory mask = 0700
   valid users = %S
EOF

tftp/ftp/www:
docker run -idt --net host --name fileserver --rm -v /file-to-serv:/var/files:ro joely1101/fserver
docker run -idt --net host --restart always --name fileserver -v /www:/var/files:ro joely1101/fserver
docker run -idt --net host --restart always --name fileserver -v /home/jlee/tftproot:/var/files:ro -v /etc/localtime:/etc/localtime:ro -e “TZ=Asia/Taipei” joely1101/fserver

#disable cloud-init
sudo touch /etc/cloud/cloud-init.disabled
```
