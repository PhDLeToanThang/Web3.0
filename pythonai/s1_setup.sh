#Phần 1. Các bước cài Python trên Unix/Linux OS:
#Có 3 Cách cài Python trên Unix/Linux OS:
#B0. Cách 1: Download và cài Python 3.12 (Download the latest version of Python)

sudo apt update -y
sudo apt list --upgradable
sudo apt autoremove -y
sudo apt upgrade -y

sudo sudo apt install python3 python3-pip python3-dev python3-pip -y
# ham xac dinh phien ban phython co san o Ubuntu 20.04, version <= 3.8
# ham xac dinh phien ban python OS Windows: python --version
python3 --version
sudo apt --only-upgrade install python3

#---------------------
#B1. Cách 2: if not download auto, you can Use Deadsnakes PPA to Install Python 3.12 on Ubuntu
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.12 -y

#Since the Deadsnakes PPA has almost every version of Python in its database, you can install older versions of Python as well. 
#Just replace the package name with the version of Python you want to install on your computer.
#sudo apt install python3.3 -y
#sudo apt install python3.8 -y
#sudo apt install python3.10 -y

#----------------------
#B2. Cách 3: Install Python 3 on Ubuntu From Source code và rebuild lại gói cài dành cho Dev Env:
#Install supporting dependencies on your system with APT:

sudo apt update -y

#Then install the necessary dependencies with this command:
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev -y

#Make a new directory to store the Python source files:
mkdir ./python && cd ./python

#Download the Python source code from the official FTP server:
wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0b3.tgz

#Extract the TGZ file that you just downloaded with:
tar -xvf Python-3.12.0b3.tgz

#Now you need to compile the Python source code. For that, we'll use the provided "configure" script. 
#Compile the source code by running the below command:
cd Python-3.12.0b3
./configure --enable-optimizations

#Build the package using the MakeFile present in the directory:
sudo make install

python3.12 --version

#Jupyter installation requires Python 3.3 or greater, or Python 2.7. IPython 1.x, which included the parts that later became Jupyter, 
#was the last version to support Python 3.2 and 2.6.
#---------------------

sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv
#---------------------
#Phần 2. Cài jupyter vào python 3.12
pip install -U jupyter

#--------------------
#Phần 3. cài git và nâng cấp jupyterlab-git
mkdir ~/workspaces
cd ~/workspaces

virtualenv etl_elt
source etl_elt/bin/activate

pip install jupyter
pip install jupyterlab
pip install jupyter-notebook
pip install ipython
pip install --upgrade jupyterlab-git
jupyter server extension list


#----------------------------
#Phần 5. Cài ETL for python:
#install ETL extension: https://docs.amphi.ai/getting-started/installation
pip install amphi-etl

#https://docs.amphi.ai/getting-started/installation

python -m venv amphi_venv


#amphi_venv\Scripts\Activate.ps1 (windows)
#active unix/linux:

source amphi_venv/bin/activate


#jupyter install lab not need because included on notebook
python -m pip install jupyterlab jupyterlab-amphi

#install plugin of python to parsing CSV/XML/JSON/HTML file datasets for converter Database structures:
pip install beautifulsoup4
pip install selenium


#Yes, installing the Jupyter Notebook will also install the IPython kernel. This allows working on notebooks using the Python programming language.
jupyter notebook --port 9999
jupyter notebook --no-browser

#Start JupyterLab
jupyter jupyterlab

#jupyter execute notebook.ipynb --allow-errors
#jupyter execute notebook.ipynb notebook2.ipynb