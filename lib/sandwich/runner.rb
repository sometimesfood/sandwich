require 'chef'
require 'sandwich/recipe'

module Sandwich
  # This class constructs a {Chef::Recipe} from a recipe string and
  # applies it with Chef standalone mode
  class Runner
    # @param [String] recipe_string the recipe definition
    def initialize(recipe_string)
      @client = solo_client
      @run_context = Chef::RunContext.new(@client.node, {})
      @recipe = Chef::Recipe.new(nil, nil, @run_context)
      @recipe.from_string(recipe_string)
    end

    # Run Chef in standalone mode, apply recipe
    #
    # @param [Symbol] log_level the log level to pass to Chef,
    #        possible values defined in +Mixlib::Log::LEVELS+
    #        (currently one of +debug+, +info+, +warn+, +error+,
    #        +fatal+)
    # @return [void]
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
