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
      run_recipe(recipe)
      with_fakefs do
        file = File.read(filename)
        file.must_equal content
      end
    end

    it 'should throw exceptions for files in missing directories' do
      filename = '/i/am/not/here'
      content = 'hello world'
      recipe = %Q(file '#{filename}' do content '#{content}';end)
      run = Proc.new { run_recipe recipe }
      run.must_raise(Errno::ENOENT,
                     Chef::Exceptions::EnclosingDirectoryDoesNotExist)
    end
  end

  describe Chef::Resource::CookbookFile do
    it 'should create cookbook files' do
      source = '/source'
      target = '/target'
      content = 'hello world'
      recipe = %Q(cookbook_file '#{target}' do source '#{source}';end)
      with_fakefs do
        setup_standard_dirs
        # create source for cookbook file
        File.open(source, 'w') { |f| f.write(content) }
      end
      run_recipe(recipe)
      with_fakefs do
        File.read(source).must_equal File.read(target)
      end
    end
  end

  describe Chef::Resource::Directory do
    it 'should create directories' do
      dir = '/foo'
      recipe = %Q(directory '#{dir}')
      with_fakefs { assert !Dir.exists?(dir) }
      run_recipe(recipe)
      with_fakefs { assert Dir.exists?(dir) }
    end
  end
end
