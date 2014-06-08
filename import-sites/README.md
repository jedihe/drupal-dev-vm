## Drupal dev VM - Drupal sites auto-import functionality

The provisioning includes auto-importing for the sites added via drupal\_site
resource. The naming convention is as follows (assuming import-sites is the
current directory):

1. Drupal's directory must be named "<site-name>", such that index.php is at
   <site-name>/<site-name>/index.php (yes, 2 directories with same name)
2. SQL dump must be gzipped and named "<site-name>/<site-name>.sql.gz"
3. settings.php must be named "<site-name>/<site-name>.settings.php"

### Please note:

- Once a DB dump is imported, a .lock file is added to prevent importing it next
time the VM is provisioned; removing the .lock file will get the DB re-imported
by the provisioner.

For more info, see:
- puppet/manifests/classes/import\_sites.pp: provisioning of sites via drupal\_site{}.
- puppet/manifests/classes/drupal\_site.pp: definition of drupal\_site{} resource.

### Special files

There are some special files included for auto-import:
- apc.php: copied to the main docroot to allow seeing apc status.
- pma-autologin-config.inc.php: phpmyadmin config file adjusted to log in
  automatically.
- .gitconfig: global git config for "vagrant" user, edit to set your name/email
  or other preferences.
- .vimrc: minimal vim configuration, enabling pathogen + settings for some of
  of the plugins downloaded automatically. .vimrc-supercharged is my personal
  .vimrc; you may want to replace .vimrc with it :)
- .zshrc: minimal zsh config file; edit to suit your needs. .zshrc-supercharged
  includes my personal customizations.
