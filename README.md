# ToyBox 

The ToyBox is a simple and an easy to manage applications on Docker.

## Requirements

* docker
* docker-compose

## Getting started

(1) Clone this repo.:

```
$ git clone https://github.com/ontheroadjp/docker-toybox.git
```

(2) Set environment variables into ``~/.bash_profile``:

```bash
export TOYBOX_HOME=/path/to/clone/toybox
export PATH=$TOYBOX_HOME:$PATH
```

## Usage

(1) Start proxy container:

```bash
$ toybox proxy new
```

(2) Start application:

```bash
$ toybox <application> new
```

You can select application from the list below:

``apache2``, ``gitbucket``, ``lychee``, ``nginx``, ``owncloud``, ``php5``, ``php7``

(We have been scheduled for adding more applications in the futuer version ot the ToyBox.)


(3) exec ``toybox`` command with no arguments and no any options to check an application status:

```bash
$ toybox 

  _____         ___          
 |_   _|__ _  _| _ ) _____ __
   | |/ _ \ || | _ \/ _ \ \ /
   |_|\___/\_, |___/\___/_\_\
           |__/  Nuts Project,LLC

proxy is running   

[docker-toybox.com]
ID        URL                                       Application              Status
-------------------------------------------------------------------------------------
8954      http://owncloud.docker-toybox.com         owncloud:9.0.2           running
```

(4) Add a line below into  ``/etc/hosts`` at the system will access to the application from. 

```bash
<your server's IP address> <URL of the toybox application>
```

example:

```bash
160.17.228.167 owncloud.docker-toybox.com
```

If you want to change the URL, see "Changing URL of the application" section under this document.

(5) Open your web browser and access to URL of the application. 

## Managing Application

### Starting application

```bash
toybox <application> new
```

### Stopping application

```bash
toybox <application URL> stop
```

### Removing application

```bash
toybox <application URL> down
```

* see ``toybox -h`` for more detail.

## The application Data

When you started an application, application data will be stoered in:

``$TOYBOX_HOME/stack/<sub domain name>/<domain name>/<application name>/data``

If you remove application by command ``toybox <URL> down`` or ``toybox <URL> rm``, application data will be also removed.

## Changing URL of the application

The URL is the ToyBox Application will be ``http::<application name>.docker-toybox.com`` in default.

If you want to use your own URL, apply ``-s`` option for changing a sub domain name and use ``-d`` option for changing a domain name when you start application.

example:

If you start the ToyBox application with a command below

```
$ toybox -s www -d mydomain.com owncloud new
```

The URL of this application will be ``http://www.mydomain.com``

