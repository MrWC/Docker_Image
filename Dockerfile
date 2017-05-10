FROM tensorflow/tensorflow:1.0.0-gpu-py3

# FROM: https://hub.docker.com/r/rafaelmonteiro/deep-learning-toolbox/~/dockerfile/
# FROM: https://hub.docker.com/r/windj007/jupyter-keras-tools/~/dockerfile/

RUN apt-get update
RUN apt-get install nano
RUN pip install keras
