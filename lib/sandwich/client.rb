require 'sandwich/cookbook_version'
require 'chef'

module Sandwich
  # Chef::Client extended to inject a Sandwich cookbook into the
  # client's run context
  class Client < Chef::Client
    # @param [String] recipe_string the recipe definition
    # @param [String] filename the filename to use in error messages
    def initialize(recipe_string, filename)
      Chef::Config[:solo] = true
      super()
      # use uuid in @sandwich_cookbook_name to avoid name collisions
      uuid = UUIDTools::UUID.random_create
      @sandwich_cookbook_name = "sandwich_#{uuid}"
      @sandwich_recipe = recipe_string
      @sandwich_filename = filename
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
      cookbook = Sandwich::CookbookVersion.new(@sandwich_cookbook_name)
      run_context.cookbook_collection[@sandwich_cookbook_name] = cookbook
      recipe = Chef::Recipe.new(@sandwich_cookbook_name, nil, run_context)
      recipe.from_string(@sandwich_recipe, @sandwich_filename)
      run_context
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
  end
end
