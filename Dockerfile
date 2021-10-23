FROM jupyter/datascience-notebook
MAINTAINER Tom Jorquera <tom@jorquera.net>

USER root

###

RUN apt-get update && \
    apt-get install -y \
            graphviz \
            libsnappy-dev \
            unixodbc \
            unixodbc-dev \
            odbcinst \
            gnupg2 \
            g++ && \
    apt-get clean

RUN pip install \
         graphviz \
         sacred \
         imbalanced-learn \
         sqlalchemy_utils \
         psycopg2-binary \
         fastparquet \
         openpyxl \
         python-snappy \
         pyodbc

# MSSQL DRIVER

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install msodbcsql17

USER jovyan

###
# jupyterlab extensions

# Vim bindings
## Note: official repo does not support jupyterlab >1.x yet, use fork in the meantime
## see https://github.com/jwkvam/jupyterlab-vim/pull/115
#RUN jupyter labextension install jupyterlab_vim
RUN pip install jupyterlab_vim

# Pyviz
RUN pip install holoviews pyviz_comms

# Jupytext
RUN pip install jupytext

# plotly
RUN pip install plotly
RUN jupyter labextension install jupyterlab-plotly

###
# Hy kernel
#
# Note: currently we need to specify the version of hy manually to make it build
# on python3.8

RUN pip install funcparserlib==1.0.0a0 hy==1.0a3 && \
    pip install git+https://github.com/ekaschalk/jedhy.git && \
    pip install git+https://github.com/Calysto/calysto_hy.git && \
    python3 -m calysto_hy install --user

###
# Unmaintained but hopefully-some-day-upgraded extensions

## Voyager
#RUN jupyter labextension install jupyterlab_voyager
#
## SQL
#RUN pip install jupyterlab_sql
#RUN jupyter serverextension enable --py jupyterlab_sql
#
## Variable inspector
#RUN jupyter labextension install @lckr/jupyterlab_variableinspector
#
## qgrid
#RUN pip install qgrid
#RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
#RUN jupyter labextension install qgrid
#
# Linting
#RUN pip install flake8
#RUN jupyter labextension install jupyterlab-flake8
#
# Bokeh
#RUN pip install bokeh
#
## Auto formatting
#RUN pip install black autopep8 jupyterlab_code_formatter

###
