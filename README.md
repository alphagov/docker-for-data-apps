# docker-for-data-apps


## Who this is for

This is for anyone who wants to create a python app that can be run outside of their local machine.


## What Docker is

Docker, like [virtualenv](https://pypi.org/project/virtualenv/), lets you create virtual environments on your machine to run your Python apps.

However, while virtualenv only ensures that you have the right package versions for your app, Docker also makes sure that you have the right python version, the right system libraries needed, and even the right operating system to run the app on (using a virtual machine). That way you can run your app on any other machine that has Docker installed, even if that machine runs a different operating system.

To do that, you need to create a file (usually called `Dockerfile`) to specify
the environment you want to run your app in. For example, Python 3.7.13 on
Debian buster. When Docker reads that file, it will:

- create a Debian Buster virtual machine (VM)
- install python 3.7.13 on it
- install python libraries as needed
- run your app

Then you just need to distribute the Dockerfile along with your app's source code, and docker will be able to recreate the same environment on another computer, for instance someone else's local machine or a production server.


## Advantages of using docker

- You do not need to install anything on your machine other than Docker.
- You can share your work with colleagues or run the work in the Cloud.
- You do not have to manage virtualenv, pyenv, system libraries, or anything else of that type.


## Disadvantages of using Docker

- Docker adds a layer of abstraction on top of your existing environment.
- You may find it more difficult to debug apps as they run in an enclosed environment.
- For more complex apps, like ones that require databases, configuration can become complex.
- Docker doesn't always manage to abstract away the hardware, so you might need to tweak your configuration so it works on different OSs

Those disadvantages lessen as you get more familiar with docker.


## Docker basic concepts

In Docker, your apps run in a [container](https://www.docker.com/resources/what-container/). A container is a virtual machine (the "guest") that runs your app on your local machine (the "host"). Multiple containers can run simultaneously on the same host.

Containers are created from [images](https://docs.docker.com/get-started/overview/#images). An image is a template that describes a guest machine and the software installed on it. For example, Debian Buster with Python 3.7.13 installed.

You must create a Dockerfile to specify what your image contains, and what needs to happen when you create a container from that image.

You use terminal commands to run docker. The most common ones are:

- `docker build` to create an image from a Dockerfile
- `docker run` to start a container from a specified image

Not that you will have to run both commands every time you change the Dockerfile

## Getting started

1. [Install Docker](https://docs.docker.com/get-docker/) on your local machine.

1. Clone this repository and change your working directory to the one created by running `cd docker-for-data-apps`

1. Run the following terminal command to read the Dockerfile and create an image named `my_first_image`:

    ```
    docker build -t my_first_image .
    ```

    The `.` at the end of the command means "look for the Dockerfile in this directory".


    *Important note*: if you have an M1 Mac, docker isn't quite working for the M1 architecture yet. However if you add the `--platform linux/amd64` flag to this command, you can tell your local docker to retrieve and build images using the `linux/amd64` platform, which has better support (at the time of this writing).

1. Run the following to start a container from the image you created:

    ```
    docker run -ti -v $(pwd):/opt -p 8080:8080 my_first_image
    ```

The `-ti` argument specifies that the container will be interactive, which we need to do because our container will run `bash`.

Containers are virtual machines, so they have their own files. By default those files are invisible to the host. Likewise, the host's files are invisible to the container. We need to change that if we want to be able to edit files with our usual text editor on the host. The `-v $(pwd):/opt` argument does that. It says: make all the files that are in the current directory of the host available to the container in the `/opt` directory.

The `-p 8080:8080` argument is similar to the `-v $(pwd):/opt` argument, but for the network. By default, if your code starts a web server, that web server  will only be available in the container, and you will not be able to access it from a browser running on the host. This argument solves that by specifying that any web service that starts in the container and that responds to port 8080 (that is, you would use `http://localhost:8080` to see it) is also available from the host at the same port. Therefore you can now point your browser at that URL and you'll see the web service running inside your container.


You've now got a container running, within which you can type commands.

Run `python -V` to check your Python version. You should see the output `3.7.13`.

And since the `-v` argument makes your source code visible to your container, you can just run your app from the bash prompt:

    ```
    python myapp.py
    ```

should print "Hello world".


### Understanding the Dockerfile

The example Dockerfile in this repository contains 3 lines of code, excluding the comments:

    ```
    FROM python:3.7.13-buster
    WORKDIR /opt
    CMD /bin/bash
    ```

The first line says this image will be based on a public image called `python:3.7.13-buster`, available on the Docker site. That image gives us Python 3.7.13 on a Debian Buster virtual machine. There are hundreds of existing images to choose from, including most Python versions.

The second line tells Docker that the container will find the app files in the `/opt` directory inside the container.

The third line says when a container is instantiated from this image, make the container run the command `/bin/bash`. This is why you got a command prompt when you ran `docker run`.


## Writing your app

To write your app, you must create and edit source code files in the same directory as the Dockerfile.

Then run your usual commands (for example, `python myapp.py`) in the terminal running inside your container.

When you're finished and want to share your app, send the Dockerfile along with your source code to the person you want to share the app with. The recipient will need to run the same commands as you to run the app. In general, you'll change the Dockerfile so when a container starts, it starts the app directly, instead of running `bash`:

    ```
    FROM python:3.7.13-buster
    WORKDIR /opt
    CMD python myapp.py
    ```


## Managing your containers

The `docker` command has many options to list, stop, restart or terminate containers. You can also manage the images installed on your system. The most common commands are:

- `docker ps` to list all the containers on your system
- `docker stop [container ID]` to stop a container
- `docker rm [container ID]` to delete a container
- `docker images` to list all the images installed on your system
- `docker rmi [image ID]` to delete an image

## Further information

See the [official docker reference documentation](https://docs.docker.com/reference/) for more information.
