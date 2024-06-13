######################################################################################
#    What's new GLPI 10.0.15
######################################################################################
#!/bin/bash -e
#----------------------------
#Phần 4. Cài ETL for python:
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
