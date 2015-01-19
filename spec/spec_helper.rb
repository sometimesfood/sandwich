require 'minitest/spec'
require 'minitest/autorun'
require 'fileutils'
require 'fakefs/safe'
require 'sandwich/runner'
require 'chef'

# Ohai::System, monkey patched to return static values
class Ohai::System
  def all_plugins
    @data = Mash.new({ :hostname => 'archie',
                       :platform => 'ubuntu',
                       :fqdn => 'archie.example.com',
                       :platform_version => '11.04',
                       :os_version => '2.6.38-10-generic' })
  end
end

def ohai_data(key)
  ohai = Ohai::System.new
  ohai.all_plugins
  ohai.data[key]
end

def runner_from_recipe(recipe)
  Sandwich::Runner.new('<SPEC_HELPER>', recipe)
end

def run_recipe(recipe)
  runner_from_recipe(recipe).run(:fatal)
end

# fakefs does not support IO.binread (which is used a lot by chef),
# therefore monkey patch IO.binread to use FakeFS::File.binread
def with_fake_io_binread
  IO.instance_eval do
    alias :binread_orig :binread
    def self.binread(path); FakeFS::File.binread(path); end
  end
  yield
ensure
  IO.instance_eval { alias :binread :binread_orig }
end

def with_fakefs
  FakeFS do
    setup_standard_dirs
    with_fake_io_binread { yield }
  end
end

def setup_standard_dirs
  FileUtils.mkdir_p '/tmp'
  FileUtils.mkdir_p Chef::Config[:file_cache_path]
end

# make sure Chef 0.10 exceptions are available when using older Chef versions
class Chef::Exceptions::EnclosingDirectoryDoesNotExist; end

Chef::Config[:client_fork] = false
Chef::Config[:force_logger] = true

# FakeFS does not provide File.realpath, but for our simple tests
# expand_path is close enough
class FakeFS::File
  def self.realpath(*args)
    expand_path(*args)
  end
end

# disable Chef run locks
class Chef::RunLock
  def test; true; end
  def save_pid; end
end
