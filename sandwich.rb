#!/usr/bin/env ruby
require 'chef/run_context'
require 'chef/client'
require 'chef/recipe'
require 'chef/resource'
require 'chef/providers'

class Chef::Recipe
  def from_string(string)
    self.instance_eval(string, 'sandwich', 1)
  end
end

$client = nil

def rebuild_node
  Chef::Config[:solo] = true
  $client = Chef::Client.new
  $client.run_ohai
  $client.build_node
end

def run_chef
  rebuild_node
  Chef::Log.level = :debug
  run_context = Chef::RunContext.new($client.node, {})
  recipe = Chef::Recipe.new(nil, nil, run_context)
  input = ARGF.read
  recipe.from_string(input)
  Chef::Log.level = :debug
  runrun = Chef::Runner.new(run_context).converge
  runrun
end

def install_package(package_name, run_context)
  package = Chef::Resource::Package.new(package_name, run_context)
  package.run_action(:install)
end

def add_package_to_run_context(package_name, run_context)
  package = Chef::Resource::Package.new(package_name, run_context)
  run_context.resource_collection.insert(package)
end

puts 'Hello chef run context world'
run_chef
