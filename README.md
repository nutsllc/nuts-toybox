# Nuts Toybox

Docker containers management by dynamic proxy.

## Requirements

* docker
* docker-compose

## Getting started

1. Clone this repo.:

```
$ git clone https://github.com/ontheroadjp/docker-toybox.git
```

2. Set environment variables into ``~/.bash_profile``:

```bash
export TOYBOX_HOME=/path/to/clone/docker-toybox
export PATH=$TOYBOX_HOME:$PATH
```

## Usage

1. Start proxy container:

```bash
$ toybox proxy new
```

2. Start application:

```bash
$ toybox <application> new
```

You can select application from the list below:

``apache2``, ``gitbucket``, ``lychee``, ``nginx``, ``owncloud``, ``php5``, ``php7``

3. exec ``toybox`` command with no arguments and no any options to check an application status:

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

4. Open your web browser and access URL 

## Manage Application

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

## Application data

When you started an application, application data will be stoered in:

``$TOYBOX_HOME/stack/<sub domain name>/<domain name>/<application name>/data``

If you remove application by command ``toybox <URL> down`` or ``toybox <URL> rm``, application data will be also removed.
