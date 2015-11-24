# Base class for a workflow step

class Step
  attr_reader :name

  def initialize( name )
    @name = name
  end
end
