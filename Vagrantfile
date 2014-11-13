# vi:syntax=ruby
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Set some variables
  prod_domain = "http://acme.com"
  fqdn = "local.acme.com"

  config.vm.box = "precise32"
  # If automated download of box doesn't work, try:
  # 1. Manually download http://files.vagrantup.com/precise32.box
  # 2. Run: vagrant box add precise32 /path/to/precise32.box
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  has_proxy = ENV['http_proxy'] and !ENV['http_proxy'].empty?
  if has_proxy
    require 'uri'
    proxy_url = URI.parse(ENV['http_proxy'])

    config.vm.provision :shell, :inline => "/bin/echo 'export http_proxy=#{proxy_url}' >> /etc/profile.d/proxy.sh"
    config.vm.provision :shell, :inline => "export http_proxy='#{proxy_url}' && /usr/bin/apt-get update"
    config.vm.provision :shell, :inline => "export http_proxy='#{proxy_url}' && /usr/bin/apt-get install -y puppet libaugeas-ruby augeas-tools rubygems"
  else
    config.vm.provision :shell, :inline => "/usr/bin/apt-get update"
    config.vm.provision :shell, :inline => "/usr/bin/apt-get install -y puppet libaugeas-ruby augeas-tools rubygems"
  end

  config.vm.provision :puppet, :module_path => "puppet/modules", :options => "--verbose" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "site.pp"
    if has_proxy
      puppet.facter = {
        "domain" => "local",
        "prod_domain" => prod_domain,
        "fqdn" => fqdn,
        "http_proxy" => "#{proxy_url}",
        "http_proxy_host_port" => "#{proxy_url.host}:#{proxy_url.port}",
        "use_proxy" => "1",
      }
    else
      puppet.facter = {
        "domain" => "local",
        "prod_domain" => prod_domain,
        "fqdn" => fqdn,
        "http_proxy" => "",
        "http_proxy_host_port" => "",
        "use_proxy" => "0",
      }
    end
  end

  config.vm.network "private_network", ip: "33.33.33.11"

  # Forwarding works in tandem with the drupal_site{ ... } definitions (puppet/manifests/classes/import_sites.pp)
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 8181, host: 8181

  # Additional customizations for the VM itself
  config.vm.provider "virtualbox" do |vm|
    # Enable to get the GUI of the VM
    #vm.gui = true
    vm.customize ["modifyvm", :id, "--memory", 3072]
    vm.customize ["modifyvm", :id, "--cpus", "2"]
    vm.customize ["modifyvm", :id, "--ioapic", "on"]
  end
end
