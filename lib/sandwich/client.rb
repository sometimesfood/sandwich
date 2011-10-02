require 'sandwich/cookbook_version'
require 'chef'

module Sandwich
  class Client < Chef::Client
    def initialize(recipe_string, filename)
      Chef::Config[:solo] = true
      super()
      uuid = UUIDTools::UUID.random_create
      @sandwich_cookbook = "sandwich_#{uuid}"
      @sandwich_recipe = recipe_string
      @sandwich_filename = filename
    end

    def setup_run_context
      run_context = super
      cookbook = Sandwich::CookbookVersion.new(@sandwich_cookbook)
      run_context.cookbook_collection[@sandwich_cookbook] = cookbook
      recipe = Chef::Recipe.new(@sandwich_cookbook, nil, run_context)
      recipe.from_string(@sandwich_recipe, @sandwich_filename)
      run_context
    end
  end
end
