module Paramable
  # Prune the msg_hsh[:params] of any attributes
  # the model doesn't respond to
  # and returns the keys
  def allowed_keys_in_params(params_hsh)
    params_hsh.collect do |k,_|
      return k.to_sym if self.attribute_names.include? k.to_s
    end
  end
end