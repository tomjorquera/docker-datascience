FROM jupyter/datascience-notebook
MAINTAINER Tom Jorquera <tom@jorquera.net>

USER root

RUN apt update && \
    apt install -y \
        graphviz \
        libsnappy-dev \
        unixodbc \
        unixodbc-dev \
        odbcinst \
        gnupg2 && \
    apt clean

RUN pip install \
         graphviz \
         sacred \
         imbalanced-learn \
         sqlalchemy_utils \
         psycopg2-binary \
         fastparquet \
         python-snappy \
         pyodbc

# MSSQL DRIVER

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install msodbcsql17

USER jovyan

# Vim bindings
RUN mkdir -p $(jupyter --data-dir)/nbextensions/vim_binding
RUN jupyter nbextension install https://raw.githubusercontent.com/jwkvam/jupyter-vim-binding/master/vim_binding.js --nbextensions=$(jupyter --data-dir)/nbextensions/vim_binding
RUN jupyter nbextension enable vim_binding/vim_binding
## Note: official repo does not support jupyterlab 2.x yet, use fork in the meantime
## see https://github.com/jwkvam/jupyterlab-vim/pull/115
#RUN jupyter labextension install jupyterlab_vim
RUN jupyter labextension install @axlair/jupyterlab_vim

# Pyviz
RUN pip install holoviews bokeh
RUN jupyter labextension install @pyviz/jupyterlab_pyviz

# Automatic table of content
RUN jupyter labextension install @jupyterlab/toc

# Variable inspector
RUN jupyter labextension install @lckr/jupyterlab_variableinspector

# Jupytext
RUN pip install jupytext
RUN jupyter nbextension install --py --user jupytext
RUN jupyter nbextension enable jupytext
RUN jupyter labextension install jupyterlab-jupytext@1.2.2

# qgrid
RUN pip install qgrid
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install qgrid

# plotly
RUN pip install plotly
RUN jupyter labextension install jupyterlab-plotly@4.14.3
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager plotlywidget@4.14.3

# Auto formatting
RUN pip install black autopep8 'jupyterlab_code_formatter==1.3.8'
RUN jupyter serverextension enable --py jupyterlab_code_formatter
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter@1.3.8

# Linting
RUN pip install flake8
RUN jupyter labextension install jupyterlab-flake8

# Unmaintained but hopefully-some-day-upgraded extensions

## Voyager
#RUN jupyter labextension install jupyterlab_voyager
#
## SQL
#RUN pip install jupyterlab_sql
#RUN jupyter serverextension enable --py jupyterlab_sql

###
