# Workflow step of selecting a county

class StepSelectCountyOrDistrict < StepSelectArea

  def initialize( step_name, param_name)
    super( step_name, param_name, :textinput )
  end

  def values( workflow = nil )
    names.map do |county_or_district_name|
      Struct::StepValue.new( county_or_district_name.split.map(&:capitalize).join(' '), county_or_district_name )
    end
  end

  def traverse( workflow )
    value = workflow.state( param_name )
    if value
      validate_with( workflow, value )
    else
      self
    end
  end

  def validate_with( workflow, value )
    validated_value = validate( value )
    if validated_value
      workflow.set_state( param_name, validated_value )
      workflow.traverse_to( successor_step )
    else
      set_flash( "Sorry, #{subtype_label} '#{value}' was not recognised" )
    end
  end

  def summarise( state_value, connector = "is " )
    "#{subtype_label.capitalize} #{connector}#{state_value}"
  end

  def validate( value )
    normalized_value = value.upcase
    names.include?( normalized_value ) && normalized_value
  end

  def successor_step
    :select_aggregation_type
  end


end
