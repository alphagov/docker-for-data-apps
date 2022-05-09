# docker-for-data-apps


## Who is this for?

Anyone who wants to create python apps that can be run elsewhere than their own computer.

## How does it work?

Docker is essentially a generalisation of virtualenv: like virtualenv, docker
lets you create environments on your machine, in which you can run your python
apps. But while virtualenv only deals with python package versions, docker
creates environments that include python version, package version, system
libraries, all the way to the operating system on which to run the app.

Through a file called `Dockerfile` you can specify that your app is meant to run
using, for example, Python 3.7.13 on Debian buster.  When Docker reads that file
it will create a Debian Buster virtual machine, install python 3.7.13 on it,
install your python libraries as needed, and run your app. Whether your computer
(the "host") runs Windows, OSX or Linux, docker will create a virtual machine
(the "guest") as you specified, to run your application.


This means that if you distribute the Dockerfile along with your application's
source code docker will make it sure that your application will run in the same
environment, whatever the host as long as it has docker installed. Hosts can
therefore be your other computer, your colleague's or a production server, for
instance.


## Why use docker?

- So you don't need to install anything on your machine other than docker
- So you can share your work with colleagues or run it in the cloud
- So you don't have to deal with virtualenv, pyenv, system libraries, etc.

## Any drawbacks?

Small ones:

- Docker adds a layer of abstraction on top of your existing environment
- Programs are sometimes harder to debug since they run in an enclosed environment
- For more complex apps, like ones that require databases, configuration can become complex

Those drawback disappear as you get more familiar with docker.

## What do I need to know?

Docker's basic principles are:

- your apps run in a _container_: a virtual machine that runs your application
  on your computer. Multiple containers can run simultaneously on the same host
  computer

- containers are created from _images_: templates that describe what software
  will run in a container (for instance: Debian Buster + Python 3.7.13)

- you need to create a `Dockerfile` to specify what your image contains, and what needs to happen when you create a container from your image.

You need to type terminal commands to run docker. The most common ones are:

- `docker build`: creates an image from a `Dockerfile`
- `docker run`: starts a container from a specified image

## How do I get started

- [Install Docker](https://docs.docker.com/get-docker/) on your machine

- Create a folder and download the `Dockerfile` from this repository in it

- run

    docker build -t my_first_image .

  followed by

    docker run -i -v $(pwd):/opt -p 8080:8080 my_first_image


You've now got a container running, within which you can type commands. Try:

    python -V

and you'll see 3.7.13.

This is where your app will run.


Let's examine that `Dockerfile`. It's only 3 lines long if we remove the comments:

```
FROM python:3.7.13-buster
WORKDIR /opt
CMD /bin/bash
```

- The first line says: this image will be based on a public image called
  `python:3.7.13-buster` available on the docker site.  That image gives us
  python 3.7.13 on a Debian Buster virtual machine. There are hundreds of
  existing images to choose from, including any Python version.

- This says tells docker that the container will find the application files in the `/opt` directory inside the container.
  See below for details.


- The third line means: when a container is instantiated from this image, make it run the
  command `/bin/bash`, which is why you got a command prompt once you execute `docker run`.


Now let's look at the docker commands we've just run:

    docker build -t my_first_image .

As we've seen, this reads the Dockerfile and creates the image. `-t my_first_image` gives the image a name,
which we'll refer to when building containers based on this image. And do include the `.` at the end of the command, as
it means "look for the Dockerfile in this directory"

    docker run -i -v $(pwd):/opt -p 8080:8080 my_first_image

This creates and starts a container using the "my_first_image" image that we created above. Here's what each argument means:

- `-i` : because our container will run `bash`, we need to specify it will need to be "interactive"

- `-v $(pwd):/opt` : we said above that, by default, containers are black boxes: they have their own files, network, etc.
  Obviously we won't get very far if we don't change that. And so this argument means: make all the files that are in the current directory
  of the host (for instance, `/Users/maxfroumentin/Documents/docker-for-data-apps`) available to the container in the `/opt` directory.
  This means that we can create or edit files on our machine using our normal text editor and those files will be visible in the
  container, in `/opt`

- `-p 8080:8080` : is the same thing, but for the network. By default, if your code starts a web server it will only be available in the container and you won't be able to access it from a browser running on the host. This argument solves that by specifying that any web service that starts in the container and that responds to port 8080 (i.e. you would use http://localhost:8080 to see it) is also available from the host, at the same port. Therefore you can now point your browser at that URL and you'll see the web service running inside your container.


## So how do I write my app?

You can just edit files in the same folder as the Dockerfile, then in the
terminal running inside your container, you run your usual commands, like
`python myapp.py`. And when you're finished and want to share the outcome, you
just need to send the Dockerfile along with your source code, and the recipient
will just need to run the same commands as you in order to run the app.

## How do I manage my containers?

the `docker` command includes many other options, to list, stop, restart or terminate containers. You can also manage the images installed on your system. The most used are:

- `docker ps` to list all the containers on your system
- `docker stop [container ID]`
- `docker rm [container ID]` to delete a container
- `docker images` to list all the images installed on your system
- `docker rmi [image ID]` to delete an image

## How do I learn more?

- By now you'll have learned enough about docker that you'll know what to google for if you have a problem
- You can also look at the official [docker reference
  documentation](https://docs.docker.com/reference/) and lots of online
  tutorials.
