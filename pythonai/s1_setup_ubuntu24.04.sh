#######################################################################################################################
#    What's new Python 3.12.3 with AI, Deep Learn, ML, ETL->DWH->ANA-ELT-> PBI/Tabular/Tabluer/Qlickview in Ubuntu 24.04
#######################################################################################################################
#!/bin/bash -e
#Phần 1. Các bước cài Python trên Unix/Linux OS:
#Có 3 Cách cài Python trên Unix/Linux OS:
#B0. Cách 1: Download và cài Python 3.8 (Download the latest version of Python)

sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y

sudo sudo apt install python3 python3-dev -y
# ham xac dinh phien ban phython co san o Ubuntu 20.04, version <= 3.8
# ham xac dinh phien ban python OS Windows: python --version
python3 --version
sudo apt install python3-pip -y
sudo apt install git -y

#---------------------
#B1. Cách 2: if not download auto, you can Use Deadsnakes PPA to Install Python 3.8 on Ubuntu
#sudo apt install software-properties-common -y
#sudo add-apt-repository ppa:deadsnakes/ppa -y
#sudo apt update -y
#sudo apt install python3.8 -y

#Since the Deadsnakes PPA has almost every version of Python in its database, you can install older versions of Python as well. 
#Just replace the package name with the version of Python you want to install on your computer.
#sudo apt install python3.3 -y
#sudo apt install python3.8 -y
#sudo apt install python3.10 -y

#----------------------
#B2. Cách 3: Install Python 3 on Ubuntu From Source code và rebuild lại gói cài dành cho Dev Env:
#Install supporting dependencies on your system with APT:

#sudo apt update -y

#Then install the necessary dependencies with this command:
#sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev -y

#Make a new directory to store the Python source files:
#cd /var/ && mkdir ./python && cd ./python

#Download the Python source code from the official FTP server:
#wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0b3.tgz

#Extract the TGZ file that you just downloaded with:
#tar -xvf Python-3.12.0b3.tgzpip3 insta


#Now you need to compile the Python source code. For that, we'll use the provided "configure" script. 
#Compile the source code by running the below command:
#cd Python-3.12.0b3
#./configure --enable-optimizations

#Build the package using the MakeFile present in the directory:
#sudo make install

#Jupyter installation requires Python 3.3 or greater, or Python 2.7. IPython 1.x, which included the parts that later became Jupyter, 
#was the last version to support Python 3.2 and 2.6.
#---------------------

sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv 
#---------------------
#Phần 2. Cài jupyter vào python 3.12
sudo pip3 install -U jupyter
sudo pip3 install jupyterlab
sudo pip3 install ipywidgets
sudo pip3 install qtconsole
sudo pip3 install jupyter 
sudo pip3 install notebook
sudo pip3 install ipython
sudo jupyter --version
#--------------------
#Phần 3. cài git và nâng cấp jupyterlab-git

sudo pip3 install jupyterlab-git

#https://docs.python.org/3/tutorial/venv.html
sudo python3 -m virtualenv etl-elt-env

sudo virtualenv etl-elt-env
sudo source etl-elt-env/bin/activate


jupyter server extension list

jupyter notebook --allow-root
