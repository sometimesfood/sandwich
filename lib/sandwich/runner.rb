require 'chef'
require 'sandwich/recipe'
require 'sandwich/cookbook_version'

module Sandwich
  # This class constructs a {Chef::Recipe} from a recipe string and
  # applies it with Chef standalone mode
  class Runner
    # @param [String] recipe_string the recipe definition
    def initialize(recipe_string, filename)
      @client = solo_client
      cookbook_name = 'sandwich'
      cookbook_collection = single_cookbook_collection(cookbook_name)
      @run_context = Chef::RunContext.new(@client.node, cookbook_collection)
      @recipe = Chef::Recipe.new(cookbook_name, nil, @run_context)
      @recipe.from_string(recipe_string, filename)
    end

    # Run Chef in standalone mode, apply recipe
    #
    # @param [Symbol] log_level the log level to pass to Chef,
    #        possible values defined in +Mixlib::Log::LEVELS+
    #        (currently one of +debug+, +info+, +warn+, +error+,
    #        +fatal+)
    # @return [void]
    def run(log_level = :warn)
      configure_chef(log_level)
      Chef::Runner.new(@run_context).converge
    end

    private
    def solo_client
      Chef::Config[:solo] = true
      client = Chef::Client.new
      client.run_ohai
      client.build_node
    end

    def configure_chef(log_level)
      Chef::Log.level = log_level

      # don't try to write to /var as non-root user
      unless ENV['USER'] == 'root'
        local_cache = File.join(ENV['HOME'], '.cache', 'sandwich')
        Chef::Config[:cache_options][:path] = File.join(local_cache, 'cache')
        Chef::Config[:file_backup_path] = File.join(local_cache, 'backup')
      end
    end

    # create a cookbook collection containing a single empty cookbook
    def single_cookbook_collection(cookbook_name)
      cookbook = Chef::CookbookVersion.new(cookbook_name)
      Chef::CookbookCollection.new({ cookbook_name => cookbook })
    end
  end
end
