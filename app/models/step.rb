# Base class for a workflow step

Struct.new( "StepValue", :label, :value )

class Step
  attr_reader :name, :param_name

  def initialize( name, param_name )
    @name = name
    @param_name = param_name
  end

  def completed?( params )
    params.has_key?( param_name )
  end
end
