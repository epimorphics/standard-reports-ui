# Base class for a workflow step

Struct.new( "StepValue", :label, :value )

class Step
  attr_reader :name, :param_name, :layout, :flash

  def initialize( name, param_name, layout )
    @name = name
    @param_name = param_name
    @layout = layout
  end

  def completed?( params )
    params.has_key?( param_name )
  end

  def incomplete?( params )
    !completed?( params )
  end

  # Simple traversal requires only that the parameter for this
  # step has some value
  def simple_traverse( workflow, following_state )
    if workflow.has_state?( param_name )
      workflow.traverse_to( following_state )
    else
      self
    end
  end

  def set_flash( message )
    @flash = message
    self
  end

  def value( workflow )
    workflow.state( param_name )
  end

  def summarise_current_value( workflow, connector = "" )
    if v = value( workflow )
      summarise( v, connector )
    else
      "unassigned"
    end
  end
end
