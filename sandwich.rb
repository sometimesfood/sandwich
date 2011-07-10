#!/usr/bin/env ruby
require 'chef'

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

run_chef
