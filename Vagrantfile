# vi:syntax=ruby
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
CURDIR = File.expand_path(File.dirname(__FILE__))
HOSTUID = Process.uid

Vagrant.configure("2") do |config|
  config.vm.define "env" do |v|
    v.vm.provider "docker" do |d|
      d.cmd = ["/sbin/my_init", "--enable-insecure-key"]
      d.image = "jedihe/d67-dev-env-i386:precise"
      d.has_ssh = true
      d.volumes = ["#{CURDIR}/volumes/mysql:/var/lib/mysql", "#{CURDIR}/volumes/www:/var/www"]
    end

    # Set some variables
    prod_domain = "http://acme.com"
    fqdn = "local.acme.com"

    has_proxy = ENV['http_proxy'] and !ENV['http_proxy'].empty?
    if has_proxy
      require 'uri'
      proxy_url = URI.parse(ENV['http_proxy'])

      v.vm.provision :shell, :inline => "/bin/rm -rf /vagrant/volumes/mysql/*"
      v.vm.provision :shell, :inline => "/bin/sh /vagrant/docker/99_mysql_setup.sh"
      v.vm.provision :shell, :inline => "/bin/echo 'export http_proxy=#{proxy_url}' >> /etc/profile.d/proxy.sh"
      v.vm.provision :shell, :inline => "export http_proxy='#{proxy_url}' && /usr/bin/apt-get update"
      v.vm.provision :shell, :inline => "export http_proxy='#{proxy_url}' && /usr/bin/apt-get install -y puppet libaugeas-ruby augeas-tools rubygems"
    else
      v.vm.provision :shell, :inline => "/bin/rm -rf /vagrant/volumes/mysql/*"
      v.vm.provision :shell, :inline => "/bin/sh /vagrant/docker/99_mysql_setup.sh"
      v.vm.provision :shell, :inline => "/usr/bin/apt-get update"
      v.vm.provision :shell, :inline => "/usr/bin/apt-get install -y puppet libaugeas-ruby augeas-tools rubygems"
    end

    v.vm.provision :puppet, :module_path => "puppet/modules", :options => "--verbose" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      if has_proxy
        puppet.facter = {
          "domain" => "local",
          "prod_domain" => prod_domain,
          "fqdn" => fqdn,
          "http_proxy" => "#{proxy_url}",
          "http_proxy_host_port" => "#{proxy_url.host}:#{proxy_url.port}",
          "host_uid" => "#{HOSTUID}",
          "use_proxy" => "1",
        }
      else
        puppet.facter = {
          "domain" => "local",
          "prod_domain" => prod_domain,
          "fqdn" => fqdn,
          "http_proxy" => "",
          "http_proxy_host_port" => "",
          "host_uid" => "#{HOSTUID}",
          "use_proxy" => "0",
        }
      end
    end

    # Taken from phusion/baseimage-docker
    v.ssh.username = "root"
    v.ssh.private_key_path = "insecure_key"
  end

  config.vm.network :forwarded_port, guest: 8080, host: 8080
end
