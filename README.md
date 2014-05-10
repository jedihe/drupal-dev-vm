## Quickstart

1. If needing to import an existing site:
  1. Read import-sites/README, set up your code + settings file + DB dump.
  2. Adjust puppet/manifests/import\_sites.pp to get your new site properly imported and set up.
2. Run "vagrant up" and wait :)

### SSH Keys

(Taken almost verbatim from [FunnyMonkey/fm-vagrant](https://github.com/FunnyMonkey/fm-vagrant))

Rather than propagate private keys to the virtual machine, which is a *bad* *insecure* practice, You should set up [ssh agent forwarding]https://help.github.com/articles/using-ssh-agent-forwarding instead. The vagrant box that is deployed will allow ssh key forwarding from your host OS.

Adding the following to my .ssh/config works when ssh'ing via the port forward of 2222.

    Host 127.0.0.1
      ForwardAgent yes

That is, once the above is added to your .ssh/config you should be able to ssh in with the follwoing and your ssh keys will be forwarded;

    ssh USERNAME@127.0.0.1 -p 2222


Assuming that this did not encounter any port collisions the port will be 2222 however if there were port collisions you should see something like the following;

    [default] Fixed port collision for 22 => 2222. Now on port 2200.

Just adjust the port paramter to ssh to the corresponding replacement port, in the above case 2200.


## Resources
[VagrantUp]http://vagrantup.com/

[PuppetLabs]http://puppetlabs.com/

## Debugging

(Taken verbatim from [FunnyMonkey/fm-vagrant](https://github.com/FunnyMonkey/fm-vagrant))

If the vagrant box fails to boot and hangs at;
    "[default] Waiting for VM to boot. This can take a few minutes."

This seems to trigger when adjusting puppet files if puppet starts but does not
successfully finish due to syntax errors or changing files during runtime it
*seems* to cause the VM to hang-up. Searching for solutions points to halting at
this stage as a network DHCP issue, but I have verified that this is actually
caused by the boot process halting on the GRUB boot selection menu with default
timeout selection.

If this happens you will need to get the machine hash stored in .vagrant it will
be something like the following
    26424ca8-1f48-4ec1-9888-12b8f69f7c7e

Once you have the machine hash then you can halt the machine.
    VBoxManage controlvm '26424ca8-1f48-4ec1-9888-12b8f69f7c7e' poweroff

Then boot the machine with a GUI console
    VBoxManage startvm '26424ca8-1f48-4ec1-9888-12b8f69f7c7e'

Once the machine is booted login, and then run;
    sudo update-grub

Then you should be able to resume managing this via vagrant in the standard
headless manner.

## Disclaimer

This Vagrant based VM started from [FunnyMonkey/fm-vagrant](https://github.com/FunnyMonkey/fm-vagrant), but I had to change it so much to suit my needs that I just decided to publish my modified version in a new repo. I plan on doing some cleanup later to get file names clearner (no fm\_ prefix).
