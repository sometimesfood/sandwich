#!/usr/bin/env ruby
require 'chef/run_context'
require 'chef/client'
require 'chef/recipe'
require 'chef/resource'
require 'chef/providers'

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
#  @recipe = Chef::Recipe.new(nil, nil, run_context)
  runrun = Chef::Runner.new(run_context).converge
  Chef::Log.level = :debug
  runrun
  install_package('gitg', run_context)
end

def install_package(package_name, run_context)
  package = Chef::Resource::Package.new(package_name, run_context)
  package.run_action(:install)
end

puts 'Hello chef run context world'
run_chef
