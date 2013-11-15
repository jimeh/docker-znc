# ZNC for Docker

Run the [ZNC](http://znc.in) IRC Bouncer in a Docker container.


## Running

To retain your ZNC settings between runs, you will need to bind a directory
from the host to `/znc-data` in the container. For example:

    docker run -v /home/$(whoami)/.znc:/znc-data jimeh/znc

This will download the image if needed, and create a default config file in
your data directory unless you already have a config in place. The default
config has ZNC listening on port 6667. To see which port on the host has been
exposed:

    docker ps

Or if you want to specify which port to map the default 6667 port to:

    docker run -p 36667:6667-v /home/$(whoami)/.znc:/znc-data jimeh/znc

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


## Building It Yourself

1. Install Docker (http://docker.io/).
2. Checkout source: `git clone https://github.com/jimeh/docker-znc.git`
3. Build container: `sudo docker build -t $(whoami)/znc .`
4. Run container: `sudo docker run -v /home/$(whoami)/.znc:/znc-data $(whoami)/znc`
