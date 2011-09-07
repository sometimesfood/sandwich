require 'minitest/spec'
require 'minitest/autorun'
require 'fileutils'
require 'fakefs/safe'
require 'sandwich/runner'

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
  r = runner_from_recipe(recipe)
  with_fakefs { r.run(:fatal) }
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
