# Base class for a workflow step

Struct.new( "StepValue", :label, :value )

class Step
  attr_reader :name, :param_name, :layout, :flash

  def initialize( name, param_name, layout )
    @name = name
    @param_name = param_name
    @layout = layout
  end

  def completed?( workflow )
    workflow.has_state?( param_name )
  end

  def incomplete?( workflow )
    !completed?( workflow )
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

  def multivalued?
    false
  end

  def form_param
    "#{param_name}#{'[]' if multivalued?}"
  end

  def provides?( state_name, workflow )
    param_name == state_name
  end
end
