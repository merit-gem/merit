# Hash core extensions:
#   * conditions_apply?(obj)
class Hash
  # Methods over object (applied recursively) respond what's expected?
  # Example (evaluates to true):
  #   { :first => { :odd? => true }, :count => 2 }.conditions_apply? [1,3]
  def conditions_apply?(obj)
    applies = true
    self.each do |method, value|
      called_obj = obj.send(method)
      if value.kind_of?(Hash)
        applies = applies && value.conditions_apply?(called_obj)
      else
        applies = applies && called_obj == value
      end
    end
    applies
  end
end

# Array core extensions:
#   * all_lower_than(value)
class Array
  # All array values are lower than parameter
  def all_lower_than(value)
    self.select{|elem| elem >= value }.empty?
  end
end