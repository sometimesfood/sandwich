sandwich
========

The easiest way to get started as a [chef](http://www.opscode.com/chef/).

Documentation
-------------

Sandwich is the easiest way to get started with [Chef](http://www.opscode.com/chef/), a Ruby-based configuration management tool.

Sandwich lets you apply Chef recipes to your system without having to worry about setting up cookbooks, runlists or any configuration at all. Using Sandwich you can run Chef recipes the way you would run shell scripts: by piping recipes directly to Sandwich or running recipe files locally.

For example, installing the package `htop` works like this:

    echo "package 'htop'" | sudo sandwich

If you wanted to install zsh, make it the default shell for root and add a simple alias (without overwriting the existing zshrc), you could do something like this:

    cat <<EOF | sudo sandwich -l info
    package "zsh"
    
    user "root" do
      shell "/bin/zsh"
    end
    
    file "/root/.zshrc" do
      content "alias ll='ls -l'"
      not_if { File.exist? "/root/.zshrc" }
    end
    EOF

(Yes, you can just copy & paste this. Go ahead, I'll be waiting.)

Sandwich even makes managing cron jobs easy. Say you want to generate a new signature file `~/.signature.sample` every day at 4:02 AM by running `fortune` and ensure fortune is actually installed, the recipe would look something like this:

    cat <<EOF > fortune-signature.rb
    package "fortunes-bofh-excuses"
    cron "email-signature" do
      hour "4"
      minute "02"
      user ENV['SUDO_USER']
      command "fortune bofh-excuses > ~/.signature.sample"
    end
    EOF
    sudo sandwich -l info fortune-signature.rb

Installation
------------

Sandwich is available as a gem called `chef-sandwich`:

    sudo gem install chef-sandwich

There's also a [chef-sandwich package for Debian/Ubuntu](https://launchpad.net/~sometimesfood/+archive/chef-sandwich/). Make sure to install a recent Chef version to go with Sandwich:

    sudo apt-get install curl lsb-release python-software-properties
    bash < <( curl -sL https://raw.github.com/sometimesfood/chef-admin-essentials/master/contrib/install-chef.sh )
    sudo add-apt-repository ppa:sometimesfood/chef-sandwich
    sudo apt-get update
    sudo apt-get install chef-sandwich

Limitations
-----------

Sandwich does not currently suppport cookbooks. Dont't worry, it's on my TODO list.

Extras
------

For a more in depth description of Chef's resources, see [Chef Resources](http://wiki.opscode.com/display/chef/Resources).

Note: Sandwiches with a side of [rocco](https://github.com/rtomayko/rocco) help aspiring chefs to share their recipes.

Copyright
---------

Copyright (c) 2011 Sebastian Boehm. See LICENSE for details.
