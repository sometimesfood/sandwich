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

# monkey patch for https://github.com/defunkt/fakefs/issues/96
class FakeFS::Dir
  def self.mkdir(path, integer = 0)
    FileUtils.mkdir(path)
  end
end

def runner_from_recipe(recipe)
  Sandwich::Runner.new('<SPEC_HELPER>', recipe)
end

def run_recipe(recipe)
  runner_from_recipe(recipe).run(:fatal)
end

# fakefs does not support IO.read (which is used a lot by chef),
# therefore monkey patch IO.read to use FakeFS::File.read
def with_fake_io_read
  IO.instance_eval do
    alias :read_orig :read
    def self.read(path); FakeFS::File.read(path); end
  end
  yield
ensure
  IO.instance_eval { alias :read :read_orig }
end

def with_fakefs
  FakeFS do
    setup_standard_dirs
    with_fake_io_read { yield }
  end
end

def setup_standard_dirs
  FileUtils.mkdir_p '/tmp'
end

# make sure Chef 0.10 exceptions are available when using older Chef versions
class Chef::Exceptions::EnclosingDirectoryDoesNotExist; end
