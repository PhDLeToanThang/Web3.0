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

sudo sudo apt install python3-full -y
# ham xac dinh phien ban phython co san o Ubuntu 20.04, version <= 3.8
# ham xac dinh phien ban python OS Windows: python --version
python3 --version
sudo apt install python3-pip -y
sudo apt install git -y
sudo apt install nano -y

#---------------------
#B1. Cách 2: if not download auto, you can Use Deadsnakes PPA to Install Python 3.12.3 on Ubuntu
#sudo apt install software-properties-common -y
#sudo add-apt-repository ppa:deadsnakes/ppa -y
#sudo apt update -y
#sudo apt install python3.12.3 -y

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
#wget https://www.python.org/ftp/python/3.12.3/Python-3.12.0b3.tgz

#Extract the TGZ file that you just downloaded with:
#tar -xvf Python-3.12.0b3.tgzpip3 install


#Now you need to compile the Python source code. For that, we'll use the provided "configure" script. 
#Compile the source code by running the below command:
#cd Python-3.12.0b3
#./configure --enable-optimizations

#Build the package using the MakeFile present in the directory:
#sudo make install

#Jupyter installation requires Python 3.3 or greater, or Python 2.7. IPython 1.x, which included the parts that later became Jupyter, 
#was the last version to support Python 3.2 and 2.6.
#---------------------
pip3 --version
#pip 24.0 from /usr/lib/python3/dist-packages/pip (python 3.12)
#sudo -H pip3 install --upgrade pip
#sudo -H pip3 install virtualenv 
#error: externally-managed-environment
#× This environment is externally managed
#╰─> To install Python packages system-wide, try apt install
#    python3-xyz, where xyz is the package you are trying to
#    install.
#
#    If you wish to install a non-Debian-packaged Python package,
#    create a virtual environment using python3 -m venv path/to/venv.
#    Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
#    sure you have python3-full installed.
#
#    If you wish to install a non-Debian packaged Python application,
#    it may be easiest to use pipx install xyz, which will manage a
#    virtual environment for you. Make sure you have pipx installed.
#
#    See /usr/share/doc/python3.12/README.venv for more information.
#
#note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
#hint: See PEP 668 for the detailed specification.
#---------------------
#Phần 2. Cài jupyter vào python 3.12
sudo python3 -m pip config set global.break-system-packages true
#./configure --enable-optimizations
#sudo make -j4 && sudo make altinstall

#--------------------
#Phần 3. cài git và nâng cấp jupyterlab-git
#https://docs.python.org/3/tutorial/venv.html
sudo python3 -m venv etl-elt-env
source etl-elt-env/bin/activate
apt install jupyter
jupyter server extension list

pip3 install notebook
pip3 install ipywidgets
pip3 install jupyter
pip3 install ipython
pip3 install jupyterlab
pip3 install jupyterlab-git
pip3 install numpy pandas matplotlib

jupyter notebook --allow-root