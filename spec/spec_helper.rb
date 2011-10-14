require 'minitest/spec'
require 'minitest/autorun'
require 'fileutils'
require 'fakefs/safe'
require 'sandwich/runner'
require 'chef'

class Chef::Client
  def fake_converge(run_context)
    with_fakefs do
      real_converge(run_context)
    end
    true
  end
  alias :real_converge :converge
  alias :converge :fake_converge
end

# monkey patch for https://github.com/defunkt/fakefs/issues/96
class FakeFS::Dir
  def self.mkdir(path, integer = 0)
    FileUtils.mkdir(path)
  end
end

def runner_from_recipe(recipe)
  Sandwich::Runner.new(recipe, '')
end

def run_recipe(recipe)
  runner_from_recipe(recipe).run(:fatal)
end

def with_fakefs
  FakeFS.activate!
  yield
ensure
  FakeFS.deactivate!
end

def setup_standard_dirs
  FileUtils.mkdir_p '/tmp'
  FileUtils.mkdir_p File.expand_path(Dir.getwd)
end

# make sure Chef 0.10 exceptions are available when using older Chef versions
class Chef::Exceptions::EnclosingDirectoryDoesNotExist; end
