class vim {

  package { "vim": ensure => 'installed' }

  file { ["/home/vagrant/.vim", "/home/vagrant/.vim/autoload", "/home/vagrant/.vim/bundle"]:
    ensure => "directory",
    mode => 644,
    owner => "vagrant",
    group => "vagrant",
    #recurse => true,
    require => Package['vim'],
  }

  curl::fetch { "vim-pathogen":
    source => "https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim",
    destination => "/home/vagrant/.vim/autoload/pathogen.vim",
    timeout => 30,
    verbose => false,
    require => File['/home/vagrant/.vim/autoload'],
  }

  exec { "vim-plugins":
    command => "rm -rf /home/vagrant/.vim/bundle/* &&
git clone https://github.com/scrooloose/nerdtree.git &&
git clone https://github.com/kien/ctrlp.vim.git &&
git clone https://github.com/scrooloose/syntastic.git &&
git clone https://github.com/Lokaltog/vim-powerline.git &&
git clone https://github.com/ap/vim-css-color.git &&
git clone https://github.com/mattn/emmet-vim.git &&
git clone https://github.com/tpope/vim-surround.git &&
git clone https://github.com/godlygeek/tabular.git &&
git clone https://github.com/SirVer/ultisnips.git &&
git clone https://github.com/honza/vim-snippets.git &&
git clone https://github.com/joonty/vdebug.git &&
git clone https://github.com/majutsushi/tagbar.git &&
chown -R vagrant:vagrant /home/vagrant/.vim",
    logoutput => true,
    cwd => "/home/vagrant/.vim/bundle",
    timeout => 180,
    path => ['/bin/', '/usr/bin/'],
    unless => "ls /home/vagrant/.vimrc",
    require => [File["/home/vagrant/.vim/bundle"], Curl::Fetch['vim-pathogen'], Package['git']],
  }

  file { "vim-vimrc":
    ensure => present,
    source => "/vagrant/dotfiles/.vimrc",
    path => "/home/vagrant/.vimrc",
    mode => 644,
    owner => "vagrant",
    group => "vagrant",
    replace => true,
    require => Exec['vim-plugins']
  }
}
