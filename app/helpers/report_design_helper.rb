module ReportDesignHelper
  def workflow_step_form( workflow )
    step = workflow.current_step

    form_tag( workflow.form_action, method: "get" ) do
      concat layout_existing_values( workflow )
      concat layout_flash( step )
      concat layout_workflow_form( workflow, step )
      concat layout_submit_button
    end
  end

  def layout_workflow_form( workflow, step )
    capture do
      case step.layout
      when :radio
        layout_workflow_radio_buttons( workflow, step )
      when :textinput
        layout_textinput( workflow, step )
      end
    end
  end

  def layout_workflow_radio_buttons( workflow, step )
    layout_values_as_toggle_buttons_list( step, step.values( workflow ), true )
  end

  def layout_values_as_toggle_buttons_list( step, values, radio )
    content_tag( :ul, class: "list-unstyled" ) do
      layout_values_as_toggle_buttons( step, values, radio )
    end
  end

  def layout_values_as_toggle_buttons( step, values, radio )
    capture do
      values.each do |value|
        concat(
          content_tag( :li ) do
            toggle_button_option( step, value, radio )
          end
        )
      end
    end
  end

  def toggle_button_option( step, value, radio )
    content_tag( :label ) do
      if radio
        concat radio_button_tag( step.form_param, value.value )
      else
        concat check_box_tag( step.form_param, value.value, false, id: nil )
      end
      concat value.label
    end
  end

  def layout_textinput( workflow, step )
    content_tag( :div ) do
      content_tag( :label ) do
        concat( step.input_label )
        concat( text_field_tag( step.param_name, "", id: nil) )
      end
    end
  end

  def layout_flash( step )
    capture do
      if step.flash
        content_tag( :p, nil, {class: "bg-warning flash warning"} ) do
          step.flash
        end
      end
    end
  end

  def layout_submit_button
    submit_tag( "Next", class: "button", name: nil )
  end

  def layout_existing_values( workflow )
    ignore_current_state = workflow.current_step.param_name

    capture do
      workflow.each_state( ignore_current_state ) do |state_name, state_value, param_name|
        concat(
          hidden_field_tag( param_name, state_value )
        )
      end
    end
  end

  def selected_area_summary( workflow )
    workflow
      .prior_step
      .summarise_current_value( workflow )
  end

end
