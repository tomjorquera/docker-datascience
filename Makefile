SHELL := /bin/bash

imagename = mine/datascience-notebook

app = jupyter-lab
hostport = 8888

projectdir = "$(HOME)/Codebases"
datadir = "$(HOME)/Data"

.PHONY: build
build:
	docker pull jupyter/datascience-notebook
	docker build -t $(imagename) -f Dockerfile .

.PHONY: clean
clean:
	docker image rm $(imagename)

.PHONY: run
run:
	docker run --net=host -it --rm \
	-p $(hostport):8888 \
	-v $(projectdir):/home/jovyan/work \
	-v $(datadir):/data \
	$(imagename) $(app) \
	--NotebookApp.custom_display_url=http://localhost:$(hostport)
