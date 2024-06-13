#######################################################################################################################
#    What's new Python 3.12.3 with OLLAMA in Ubuntu 24.04
#######################################################################################################################
#!/bin/bash -e
#Phần 1. Các bước cài Python trên Unix/Linux OS:
#Install Ollama:
#Open a terminal on your Ubuntu server.
#Run the following command to install Ollama: 

curl -fsSL [^1^][4] | sh

#This will download and install Ollama along with its supported open-source language models.
#Verify Installation:
#Confirm that Ollama is installed by running 
ollama --version #in the terminal.

#You should see the version information if the installation was successful.
#Run Language Models:
#Use Ollama to download and run specific language models. For example:
#To run the Mistral 7B model, use: ollama run Mistral
#Explore other models supported by Ollama as needed.

#Phần 2- Optional: Web Interface (Open WebUI):
#If you prefer a web-based interface, you can install Ollama WebUI:
#Install Snapd (if not already installed): 
sudo apt update && sudo apt install snapd

#Install Ollama WebUI: 
sudo snap install ollama-webui --beta

#Access the WebUI at http://localhost:8080/auth/ in your browser.
