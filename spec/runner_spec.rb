$LOAD_PATH.unshift File.dirname(__FILE__)
require 'spec_helper'

describe Sandwich::Runner do
  after(:each) do
    FakeFS::FileSystem.clear
  end

  describe Chef::Resource::File do
    it 'should create files' do
      with_fakefs do
        filename = '/foo'
        content = 'hello world'
        recipe = %Q(file '#{filename}' do content '#{content}';end)
        run_recipe(recipe)
        file = File.read(filename)
        file.must_equal content
      end
    end
  end

  describe Chef::Resource::CookbookFile do
    it 'should create cookbook files' do
      with_fakefs do
        source = '/source'
        target = '/target'
        content = 'hello world'
        recipe = %Q(cookbook_file '#{target}' do source '#{source}';end)
        # create source for cookbook file
        File.open(source, 'w') { |f| f.write(content) }
        run_recipe(recipe)
        File.read(source).must_equal File.read(target)
      end
    end
  end

  describe Chef::Resource::Template do
    it 'should create templates' do
      with_fakefs do
        source = '/source.erb'
        target = '/target'
        content = 'hello <%= node[:hostname] %>'
        recipe = %Q(template '#{target}' do source '/source.erb';end)
        # create source template
        File.open(source, 'w') { |f| f.write(content) }
        run_recipe(recipe)
        hostname = ohai_data(:hostname)
        File.read(target).must_equal "hello #{hostname}"
      end
    end
  end

  describe Chef::Resource::Directory do
    it 'should create directories' do
      with_fakefs do
        dir = '/foo'
        recipe = %Q(directory '#{dir}')
        assert !Dir.exists?(dir)
        run_recipe(recipe)
        assert Dir.exists?(dir)
      end
    end
  end
end
