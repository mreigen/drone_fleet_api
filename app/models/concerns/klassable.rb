module Klassable
  def klass_name_from_controller_class(controller_class)
    controller_class.class.to_s.gsub(/V.+::/,"").gsub(/Controller$/,"").singularize.classify
  end
end