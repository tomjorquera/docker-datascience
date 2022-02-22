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
RUN pip install jupyterlab_vim

# Pyviz
RUN pip install holoviews pyviz_comms

# Jupytext
RUN pip install jupytext

# plotly
RUN pip install jupyter-dash plotly && \
    jupyter labextension install jupyterlab-dash

# Variable inspector
RUN pip install lckr-jupyterlab_variableinspector

# Bokeh
RUN pip install jupyter_bokeh

# Linting
RUN pip install flake8 jupyterlab_flake8

# Auto formatting
RUN pip install black autopep8 jupyterlab_code_formatter

###
# Hylang support
#
# Need to use prerelase 1.0.0a0 of funcparserlib
# (see https://github.com/vlasovskikh/funcparserlib/issues/70)

RUN pip install funcparserlib==1.0.0a0 hy \
                git+https://github.com/ekaschalk/jedhy.git \
                git+https://github.com/Calysto/calysto_hy.git && \
    python3 -m calysto_hy install --user
###

###
# Unmaintained but hopefully-some-day-upgraded extensions

## Voyager - see https://github.com/altair-viz/jupyterlab_voyager/issues/82
#RUN jupyter labextension install jupyterlab_voyager
#
## SQL - see https://github.com/pbugnion/jupyterlab-sql/issues/131
#RUN pip install jupyterlab_sql
#RUN jupyter serverextension enable --py jupyterlab_sql
#
## qgrid - see https://github.com/quantopian/qgrid/issues/350
#RUN pip install qgrid
#RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
#RUN jupyter labextension install qgrid
