-Cai OLLAMA in windows: Xây dựng ChatGPT trên Local Python Jupyter để Chatbot FAQ:

https://github.com/PhDLeToanThang/BA_DA_CI-CD_copilot/wiki/Ch%C6%B0%C6%A1ng-4_Trang-1_X%C3%A2y-d%E1%BB%B1ng-ChatGPT-tr%C3%AAn-Local-Python-Jupyter-%C4%91%E1%BB%83-Chatbot-FAQ

- Ollama - Llama 3 how to install more model: If you're opening this Notebook on colab, you will probably need to install LlamaIndex.

```ollama  
!pip install llama-index-llms-ollama

!pip install llama-index

##############################################################
##  What's new Python 3.12.3 with OLLAMA in Ubuntu 24.04    ##
##############################################################

!/bin/bash -e

# Phần 1. Các bước cài Python trên Unix/Linux OS: 
## Install Ollama:
## Open a terminal on your Ubuntu server.
## Run the following command to install Ollama: 

curl -fsSL [^1^][4] | sh

## This will download and install Ollama along with its supported open-source language models.

## Verify Installation:

## Confirm that Ollama is installed by running 

## in the terminal.
ollama --version 

## You should see the version information if the installation was successful.

## Run Language Models:

## Use Ollama to download and run specific language models. For example:

## To run the Mistral 7B model, use: ollama run Mistral

## Explore other models supported by Ollama as needed.

# Phần 2- Optional: Web Interface (Open WebUI):
## If you prefer a web-based interface, you can install Ollama WebUI:
## Install Snapd (if not already installed):

sudo apt update && sudo apt install snapd -y

## Install Ollama WebUI: 
sudo snap install ollama-webui --beta
## Access the WebUI at http://localhost:8080/auth/ in your browser.

# Phần 3-Install model ollama3
snap install ollama
ollama pull llama3
## ref: https://github.com/ollama/ollama/blob/main/README.md#import-from-gguf
## list models on ollama: https://ollama.com/library

ollama pull medllama2
ollama pull sqlcoder
ollama pull gemma:7b

## https://ollama.com/library/sqlcoder
## https://ollama.com/library/medllama2
## curl -X POST http://localhost:11434/api/generate -d '{
##  "model": "medllama2",
##  "prompt":"A 35-year-old woman presents with a persistent dry cough, shortness of breath, and fatigue. She is initially suspected of having asthma, but her spirometry results do not improve with bronchodilators. What could be the diagnosis?"
## }'
```
