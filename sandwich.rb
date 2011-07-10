#!/usr/bin/env ruby
require 'chef'
require 'chef/client'
require 'lib/sandwich/recipe' #FIXME: remove lib here

def solo_client
  Chef::Config[:solo] = true
  client = Chef::Client.new
  client.run_ohai
  client.build_node
end

def run_chef(run_context, log_level = :warn)
  Chef::Log.level = log_level
  Chef::Runner.new(run_context).converge
end

def main
  client = solo_client
  run_context = Chef::RunContext.new(client.node, {})
  recipe = Chef::Recipe.new(nil, nil, run_context)
  input = ARGF.read
  recipe.from_string(input)
  run_chef(run_context)
end

main
