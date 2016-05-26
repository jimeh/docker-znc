# ZNC for Docker

Run the [ZNC][] IRC Bouncer in a Docker container.

[ZNC]: http://znc.in

## Prerequisites

1. Install [Docker][].

[Docker]: http://docker.com/

## Running

ZNC needs to store settings somewhere, so simplest way to run it is to mount a
directory from the host machine to `/znc-data` in the container:

    mkdir -p $HOME/.znc
    docker run -d -p 6667 -v $HOME/.znc:/znc-data jimeh/znc

This will download the image if needed, and create a default config file in
your data directory unless you already have a config in place. The default
config has ZNC listening on port 6667. To see which port on the host has been
exposed:

    docker ps

Or if you want to specify which port to map the default 6667 port to:

    docker run -d -p 36667:6667 -v $HOME/.znc:/znc-data jimeh/znc

Resulting in port 36667 on the host mapping to 6667 within the container.

## Configuring ZNC

If you've let the container create a default config for you, the default
username/password combination is `admin`/`admin`. You can access the
web-interface to create your own user by pointing your web-browser at the opened
port.

For example, if you passed in `-p 36667:6667` like above when running the
container, the web-interface would be available on: `http://hostname:36667/`

I'd recommend you create your own user by cloning the admin user, then ensure
your new cloned user is set to be an admin user. Once you login with your new
user go ahead and delete the default admin user.

## External Modules

If you need to use external modules, simply place the original `*.cpp` source
files for the modules in your `{DATADIR}/modules` directory. The startup
script will automatically build all .cpp files in that directory with
`znc-buildmod` every time you start the container.

This ensures that you can easily add new external modules to your znc
configuration without having to worry about building them. And it only slows
down ZNC's startup with a few seconds.

## DATADIR

ZNC stores all it's settings in a Docker volume mounted to `/znc-data` inside
the container.

### Mount a Host Directory

The simplest approach is typically to mount a directory off of your host machine
into the container. This is done with `-v $HOME/.znc:/znc-data` like in the
example above.

One issue with this though is that ZNC needs to run as it's own user within the
container, the directory will have it's ownership changed to UID 1000 (user) and
GID 1000 (group). Meaning after the first run, you might need root access to
manually modify the data directory.

### Use a Volume Container

First we need to create a volume container:

    docker run -v /znc-data --name znc-data busybox echo "data for znc"

And then run the znc container using the `--volumes-from` option instead of
`-v`:

    docker run -d -p 6667 --name znc --volumes-from znc-data jimeh/znc

You'll want to periodically back up your znc data to the host:

    docker run --volumes-from znc-data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /znc-data

And restore them later:

    docker run --volumes-from znc-data -v $(pwd):/backup busybox tar xvf /backup/backup.tar

## Passing Custom Arguments to ZNC

As `docker run` passes all arguments after the image name to the entrypoint
script, the [start-znc][] script simply passes all arguments along to ZNC.

[start-znc]: https://github.com/jimeh/docker-znc/blob/master/start-znc

For example, if you want to use the `--makepass` option, you would run:

    docker run -i -t -v $HOME/.znc:/znc-data jimeh/znc --makepass

Make note of the use of `-i` and `-t` instead of `-d`. This attaches us to the
container, so we can interact with ZNC's makepass process. With `-d` it would
simply run in the background.

## A note about ZNC 1.6

Starting with version 1.6, ZNC now requires ssl/tls certificate verification!
This means that it will *not* connect to your IRC server(s) if they don't
present a valid certificate. This is meant to help keep you safer from MitM
attacks.

This image installs the debian/ubuntu `ca-certificates`
[package](http://packages.ubuntu.com/vivid/ca-certificates) so that servers with
valid certificates will automatically be connected to ensuring no additional
user intervention needed. If one of your servers doesn't have a valid
fingerprint, you will need to connect to your bouncer and respond to `*status`.

See [this](https://mikaela.info/english/2015/02/24/znc160-ssl.html) article for
more information.

## Building It Yourself

1. Follow Prerequisites above.
2. Checkout source: `git clone https://github.com/jimeh/docker-znc.git && cd docker-znc`
3. Build container: `sudo docker build -t $(whoami)/znc .`
4. Run container: `sudo docker run -d -p 6667 -v $HOME/.znc:/znc-data $(whoami)/znc`
