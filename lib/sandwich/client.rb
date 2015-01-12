require 'sandwich/cookbook_version'
require 'chef'
require 'uuidtools'

module Sandwich
  # Chef::Client extended to inject a Sandwich cookbook into the
  # client's run context
  class Client < Chef::Client
    # Create a new instance of Client.
    #
    # File specified by +recipe_filename+ is only read if no
    # +recipe_string+ is supplied, otherwise +recipe_string+ is used
    # as a recipe and +recipe_filename+ is only used in log messages.
    #
    # @param [String] recipe_filename the recipe filename
    # @param [String] recipe_string the recipe definition
    def initialize(recipe_filename, recipe_string = nil)
      Chef::Config[:solo] = true
      super()

      if recipe_string
        @sandwich_basedir = Dir.getwd
      else
        @sandwich_basedir = File.expand_path(File.dirname(recipe_filename))
        recipe_string = File.read(recipe_filename)
      end

      add_cookbook_dir(@sandwich_basedir)

      @sandwich_cookbook_name = unique_cookbook_name
      @sandwich_recipe = recipe_string
      @sandwich_filename = recipe_filename
    end

    # Silently build a new node object for this client
    #
    # @return [Chef::Node] the created node object
    def build_node
      # silence build_node from super class
      silence_chef { super }
    end

    # Set up the client's run context, inject Sandwich cookbook into
    # the created run context
    #
    # @return [Chef::RunContext] the created run context
    def setup_run_context
      run_context = super
      cookbook = Sandwich::CookbookVersion.new(@sandwich_cookbook_name,
                                               @sandwich_basedir)
      run_context.cookbook_collection[@sandwich_cookbook_name] = cookbook
      recipe = Chef::Recipe.new(@sandwich_cookbook_name, nil, run_context)
      recipe.from_string(@sandwich_recipe, @sandwich_filename)
      run_context
    end

    # Add a cookbook directory to the front of the client's cookbook
    # search path.
    #
    # @param [String] cookbook_dir the cookbook directory to add
    # @return [Array] the new cookbook search path
    def add_cookbook_dir(cookbook_dir)
      Chef::Config[:cookbook_path].unshift(cookbook_dir)
    end

    private
    def silence_chef
      log_level = Chef::Log.level
      Chef::Log.level = :fatal
      yield
    ensure
      Chef::Log.level = log_level
    end

    # monkey patch: don't check for empty cookbook paths
    def assert_cookbook_path_not_empty(run_context); end

    def unique_cookbook_name
      # use uuid in sandwich cookbook name to avoid name collisions
      "sandwich_#{UUIDTools::UUID.random_create}"
    end
  end
end
