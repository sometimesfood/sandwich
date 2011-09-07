$LOAD_PATH.unshift File.dirname(__FILE__)
require 'spec_helper'

describe Sandwich::Runner do
  after(:each) do
    FakeFS::FileSystem.clear
  end

  describe Chef::Resource::File do
    it 'should create files' do
      filename = '/foo'
      content = 'hello world'
      recipe = %Q(file '#{filename}' do content '#{content}';end)
      runner = runner_from_recipe(recipe)
      with_fakefs do
        runner.run(:fatal)
        file = File.read(filename)
        file.must_equal content
      end
    end

    # FIXME: chef 0.9 throws Errno::ENOENT while chef 0.10 throws
    # EnclosingDirectoryDoesNotExist
    it 'should throw exceptions for files in missing directories' do
      filename = '/i/am/not/here'
      content = 'hello world'
      recipe = %Q(file '#{filename}' do content '#{content}';end)
      proc { run_recipe recipe }.must_raise Chef::Exceptions::EnclosingDirectoryDoesNotExist
    end
  end

  describe Chef::Resource::CookbookFile do
    it 'should create cookbook files' do
      source = '/source'
      target = '/target'
      content = 'hello world'
      recipe = %Q(cookbook_file '#{target}' do source '#{source}';end)
      runner = runner_from_recipe(recipe)
      with_fakefs do
        setup_standard_dirs
        # create source for cookbook file
        File.open(source, 'w') { |f| f.write(content) }
        runner.run(:fatal)
        File.read(source).must_equal File.read(target)
      end
    end
  end

  describe Chef::Resource::Directory do
    it 'should create directories' do
      dir = '/foo'
      recipe = %Q(directory '#{dir}')
      runner = runner_from_recipe(recipe)
      with_fakefs do
        assert !Dir.exists?(dir)
        runner.run(:fatal)
        assert Dir.exists?(dir)
      end
    end
  end
end
