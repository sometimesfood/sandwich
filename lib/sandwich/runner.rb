require 'chef'
require 'sandwich/recipe'

module Sandwich
  class Runner
    def initialize(recipe_string)
      @client = solo_client
      @run_context = Chef::RunContext.new(@client.node, {})
      @recipe = Chef::Recipe.new(nil, nil, @run_context)
      @recipe.from_string(recipe_string)
    end

    def run(log_level = :warn)
      Chef::Log.level = log_level
      Chef::Runner.new(@run_context).converge
    end

    private
    def solo_client
      Chef::Config[:solo] = true
      client = Chef::Client.new
      client.run_ohai
      client.build_node
    end
  end
end
