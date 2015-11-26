module ReportDesignHelper
  def workflow_step_form( workflow )
    form_tag( workflow.form_action, method: "get" ) do
      concat layout_existing_values( workflow )
      concat layout_workflow_form( workflow )
      concat layout_submit_button
    end
  end

  def layout_workflow_form( workflow )
    capture do
      step = workflow.current_step
      case step.layout
      when :radio
        layout_workflow_radio_buttons( workflow, step )
      end
    end
  end

  def layout_workflow_radio_buttons( workflow, step )
    layout_values_as_toggle_buttons_list( step.param_name, step.values( workflow ), true )
  end

  def layout_values_as_toggle_buttons_list( id, values, radio )
    content_tag( :ul, class: "list-unstyled" ) do
      layout_values_as_toggle_buttons( id, values, radio )
    end
  end

  def layout_values_as_toggle_buttons( id, values, radio )
    capture do
      values.each do |value|
        concat(
          content_tag( :li ) do
            toggle_button_option( id, value, radio )
          end
        )
      end
    end
  end

  def toggle_button_option( id, value, radio )
    content_tag( :label ) do
      if radio
        concat radio_button_tag( id, value.value )
      else
        concat check_box_tag( :"#{id}[]", value.value, false, id: nil )
      end
      concat value.label
    end
  end

  def layout_submit_button
    submit_tag( "Next", class: "button", name: nil )
  end

  def layout_existing_values( workflow )
    ignore_current_state = workflow.current_step.param_name

    capture do
      workflow.each_state( ignore_current_state ) do |state_name, state_value|
        concat(
          hidden_field_tag( state_name, state_value )
        )
      end
    end
  end
end
