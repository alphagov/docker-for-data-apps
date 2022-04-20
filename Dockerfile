# Instructions

# Docker in 2 lines:
# - An image is the definition of your VM and what's installed on it
#   (like Ubuntu + python, etc)
# - A container is a running instance of an image. Just like you could
#   run multiple virtual instances of  Linux on your laptop, you can run
#   multiple containers

# In a dockerfile, all but the CMD lines at the bottom are used to create the image
# That's where you specify the OS, the packages to install, etc. This is done by
# running "docker build" (details below)
# The last CMD line tells docker what to do when you start a container from this image,
# using "docker run"

# Details:
# 0. copy this file where your source code is.
# 1. create the image from this file with: "docker build -t myapp ."
#   (including the dot at the end)
# 2. create and run the container with "docker run -it myapp"
#   "docker run -i -v $(pwd):/opt -p 8080:8080 -t myapp"
#   Details on options:
#   "-i" : run the container interactively (so that you can type commands)
#   "-v $(pwd):/opt" : make the files on your laptop available to the container
#     (so you can edit them, for instance). Here, the files in the directory where
#     you run the command will be in "/opt" in the container
#   "-p 8080:8080" : make port 8080 in the container accessible from outside of it at port 8080
    (if you run a web server in your container, this will make it possible to access it in your browser
    at http://localhost:8080)
#   "-t myapp" : use the image called myapp

#----------

FROM python:3.7.13-buster
# This means: build my image from a pre-made Python image on Linux Debian 10
# (see https://hub.docker.com/_/python)


WORKDIR /opt
# Go to this folder to find my app's files


# Add all your setup commands here (pip, apt and other commands).
# They will only be performed once when the image is created.
# As containers are created from the image, those commands won't be re-run.
# For instance:
# RUN pip install -r requirements.txt
# RUN apt-get install aws-cli


CMD /bin/bash
# When running "docker run", take the image created from the lines above,
# create a container and run bash (or it could be starting a web server)
