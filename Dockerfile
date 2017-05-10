FROM tensorflow/tensorflow:1.0.1-gpu

# FROM: https://hub.docker.com/r/rafaelmonteiro/deep-learning-toolbox/~/dockerfile/
# FROM: https://hub.docker.com/r/windj007/jupyter-keras-tools/~/dockerfile/

RUN apt-get update
RUN apt-get install -yqq python python-pip python-dev build-essential \
    git wget gfortran libatlas-base-dev libatlas-dev libatlas3-base libhdf5-dev \
    libfreetype6-dev libpng12-dev pkg-config libxml2-dev libxslt-dev \
    libboost-program-options-dev zlib1g-dev libboost-python-dev
#RUN apt-get install -y python3-pip python3-dev
RUN apt-get install -y screen nano htop git wget

# INSTALL ML MODULES
WORKDIR /

## Install OpenCV
RUN apt-get -y install build-essential cmake git pkg-config
RUN apt-get -y install libjpeg8-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get -y install libgtk2.0-dev
RUN apt-get -y install libatlas-base-dev gfortran

# From: http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/
RUN wget https://github.com/opencv/opencv/archive/3.2.0.tar.gz -O /opencv.tar.gz
RUN wget https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz -O /opencv_contrib.tar.gz
#COPY opencv.tar.gz /opencv.tar.gz
#COPY opencv_contrib.tar.gz /opencv_contrib.tar.gz
RUN tar xfvz /opencv.tar.gz
RUN tar xfvz /opencv_contrib.tar.gz

RUN mkdir -p /opencv-3.2.0/build
WORKDIR /opencv-3.2.0/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.2.0/modules \
	-D BUILD_EXAMPLES=OFF .. && make -j4 && make install && ldconfig && rm -rf /opencv-3.2.0 && rm -rf /opencv_contrib-3.2.0

## Install ML Modules
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
#RUN pip3 install -r requirements.txt

VOLUME ["/notebooks", "/jupyter/certs"]

#ADD test_scripts /test_scripts
ADD jupyter /jupyter
ENV JUPYTER_CONFIG_DIR="/jupyter"

# Install extensions
RUN jupyter contrib nbextension install --user

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh"]
