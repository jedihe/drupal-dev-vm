## Quickstart

1. If needing to import an existing site:
  1. Read import-sites/README, set up your code + settings file + DB dump.
  2. Adjust puppet/manifests/import\_sites.pp to get your new site properly imported and set up.
2. Run "vagrant up --provider=docker" and wait :)

### Do You Trust Me? (i.e. Building the Docker image by yourself)

It's a two-step process:

1. Build the *Ubuntu 12.04 i386* image; instructions in [my Docker Registry repo](https://registry.hub.docker.com/u/jedihe/ubuntu-i386/).
2. Build the final *Baseimage i386* image; instructions in [my Docker Registry repo](https://registry.hub.docker.com/u/jedihe/baseimage-i386/).

You guessed it, the build process depends on other code I own... but since it's forked way back from the original repos, you can diff and see
for yourself what changes did I make.

## Using SSH

### SSH'ing into the container

To connect as root:

    vagrant ssh

To connect as vagrant:

    vagrant ssh -- -l vagrant

### SSH Keys

(Taken almost verbatim from [FunnyMonkey/fm-vagrant](https://github.com/FunnyMonkey/fm-vagrant))

Rather than propagate private keys to the virtual machine, which is a *bad* *insecure* practice, You should set up [ssh agent forwarding](https://help.github.com/articles/using-ssh-agent-forwarding) instead. The vagrant box that is deployed will allow ssh key forwarding from your host OS.

Adding the following to my .ssh/config works when ssh'ing via the port forward of 2222.

    Host 127.0.0.1
      ForwardAgent yes

That is, once the above is added to your .ssh/config you should be able to ssh in with the follwoing and your ssh keys will be forwarded;

    ssh USERNAME@127.0.0.1 -p 2222


Assuming that this did not encounter any port collisions the port will be 2222; however, if there were port collisions you should see something like the following;

    [default] Fixed port collision for 22 => 2222. Now on port 2200.

Just adjust the port parameter to ssh to the corresponding replacement port, in the above case 2200.


## Resources
[VagrantUp](http://vagrantup.com/)

[PuppetLabs](http://puppetlabs.com/)

## Disclaimer

This Vagrant based VM started from [FunnyMonkey/fm-vagrant](https://github.com/FunnyMonkey/fm-vagrant), but I had to change it so much to suit my needs that I just decided to publish my modified version in a new repo. I plan on doing some cleanup later to get file names cleaner (no fm\_ prefix).
