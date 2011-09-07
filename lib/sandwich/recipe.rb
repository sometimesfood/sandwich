require 'chef/recipe'

# Chef::Recipe, monkey patched to load recipes from strings
class Chef::Recipe
  # Loads a recipe from a string
  #
  # @param [String] string the recipe definition
  # @param [String] filename the filename to use in error messages
  # @return [void]
  def from_string(string, filename = '(eval)')
    self.instance_eval(string, filename, 1)
  end
end
