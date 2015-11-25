# Base class for a workflow step

Struct.new( "StepValue", :label, :value )

class Step
  attr_reader :name, :param_name, :layout

  def initialize( name, param_name, layout )
    @name = name
    @param_name = param_name
    @layout = layout
  end

  def completed?( params )
    params.has_key?( param_name )
  end
end
