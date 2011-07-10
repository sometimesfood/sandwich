require 'chef/recipe'

class Chef::Recipe
  def from_string(string)
    self.instance_eval(string, 'sandwich', 1)
  end
end
