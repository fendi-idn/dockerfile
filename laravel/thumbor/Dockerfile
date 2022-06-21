FROM python:2-jessie

LABEL maintainer ="donny.arieffian@gmail.com"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get -y -q install python-numpy python-opencv git curl build-essential libcurl4-openssl-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev libmemcached-dev libjpeg-turbo-progs graphicsmagick libgraphicsmagick++3 libgraphicsmagick3 libgraphicsmagick++1-dev libgraphicsmagick1-dev python-dev libboost-python-dev && \
    apt-get clean

