require 'chef/recipe'

# Chef::Recipe, monkey patched to load recipes from strings
class Chef::Recipe
  # Loads a recipe from a string
  #
  # @param [String] string the recipe definition
  # @return [void]
  def from_string(string)
    self.instance_eval(string, 'sandwich', 1)
  end
end
