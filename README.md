# ZNC for Docker

Run the [ZNC](http://znc.in) IRC Bouncer in a Docker container.


## Prerequisites

1. Install [Docker](http://docker.io/).
2. Make .znc folder: `mkdir $HOME/.znc`


## Running

To retain your ZNC settings between runs, you will need to bind a directory
from the host to `/znc-data` in the container. For example:

    docker run -d -p 6667 -v $HOME/.znc:/znc-data jimeh/znc

This will download the image if needed, and create a default config file in
your data directory unless you already have a config in place. The default
config has ZNC listening on port 6667. To see which port on the host has been
exposed:

    docker ps

Or if you want to specify which port to map the default 6667 port to:

    docker run -d -p 36667:6667 -v $HOME/.znc:/znc-data jimeh/znc

Resulting in port 36667 on the host mapping to 6667 within the container.


## Configuring

If you've let the container create a default config for you, the default
username/password combination is admin/admin. You can access the web-interface
to create your own user by pointing your web-browser at the opened port.

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


## Notes on DATADIR

ZNC needs a data/config directory to run. Within the container it uses
`/znc-data`, so to retain this data when shutting down a container, you should
mount a directory from the host. Hence `-v $HOME/.znc:/znc-data` is part of
the instructions above.

As ZNC needs to run as it's own user within the container, the directory will
have it's ownership changed to UID 1000 (user) and GID 1000 (group). Meaning
after the first run, you might need root access to manually modify the data
directory.


## Passing Custom Arguments to ZNC

As `docker run` passes all arguments after the image name to the entrypoint
script, the [start-znc][] script simply passes all arguments along to ZNC.

[start-znc]: https://github.com/jimeh/docker-znc/blob/master/start-znc

For example, if you want to use the `--makepass` option, you would run:

    docker run -i -t -v $HOME/.znc:/znc-data jimeh/znc --makepass

Make note of the use of `-i` and `-t` instead of `-d`. This attaches us to the
container, so we can interact with ZNC's makepass process. With `-d` it would
simply run in the background.


## Building It Yourself

1. Follow Prerequisites above.
2. Checkout source: `git clone https://github.com/jimeh/docker-znc.git && cd docker-znc`
3. Build container: `sudo docker build -t $(whoami)/znc .`
4. Run container: `sudo docker run -d -p 6667 -v $HOME/.znc:/znc-data $(whoami)/znc`
