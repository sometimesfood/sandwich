require 'chef/config'
require 'sandwich/recipe'
require 'sandwich/client'

module Sandwich
  # This class constructs a {Chef::Recipe} from a recipe string and
  # applies it with Chef standalone mode
  class Runner
    # @param [String] recipe_string the recipe definition
    def initialize(recipe_string, filename)
      @client = Sandwich::Client.new(recipe_string, filename)
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
      @client.run
    end

    private
    def configure_chef(log_level)
      Chef::Log.level = log_level

      # don't try to write to /var as non-root user
      unless ENV['USER'] == 'root'
        local_cache = File.join(ENV['HOME'], '.cache', 'sandwich')
        Chef::Config[:cache_options][:path] = File.join(local_cache, 'cache')
        Chef::Config[:file_backup_path] = File.join(local_cache, 'backup')
      end
    end
  end
end
