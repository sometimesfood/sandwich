#!/usr/bin/env ruby
require 'chef/run_context'
require 'chef/client'

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
  runrun = Chef::Runner.new(run_context).converge
  Chef::Log.level = :info
  runrun
end

puts 'Hello chef run context world'
run_chef
