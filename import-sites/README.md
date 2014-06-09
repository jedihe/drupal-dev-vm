## Drupal dev VM - Drupal sites auto-import functionality

The provisioning includes auto-importing for the sites added via drupal\_site
resource. The naming convention is as follows (assuming import-sites is the
current directory):

1. Drupal's directory must be named "\<domain\>/\<domain\>", such that index.php is at
   \<domain\>/\<domain\>/index.php (yes, 2 directories with same name)
2. SQL dump must be gzipped and named "\<domain\>/\<domain\>.sql.gz"
3. settings.php must be named "\<domain\>/\<domain\>.settings.php"
4. import\_sites.pp must be edited to add a new drupal\_site resource,
   be careful to set the correct value for the domain attribute.

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
