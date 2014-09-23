module Paramable
  # returns only the attributes that the current class allows
  def allowed_keys_in_params(params_hsh)
    self.attribute_names & params_hsh.keys
  end
end