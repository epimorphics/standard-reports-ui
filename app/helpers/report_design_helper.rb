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

  def layout_custom_dates( delta, step )
    year = Time.now.year - delta
    content_tag( :div, class: "row") do
      concat( content_tag( :div, class: "col-sm-12 col-md-1") do
        content_tag( :h3, year.to_s )
      end )
      concat( content_tag( :div, class: "col-sm-12 col-md-11") do
        concat( layout_all_year( step, year ) )
        concat( layout_quarters( step, year ) )
        concat( layout_months( step, year ) )
      end )

    end
  end

  def layout_all_year( step, year )
    capture do
      concat prompted_row(
        ->(){ content_tag( :span, "year", {class: "prompt"} ) },
        ->(){ labelled_check_box( "#{step.param_name}[]", year, year.to_s )}
      )
    end
  end

  def layout_quarters( step, year )
    layout_quarters_or_months( step.quarters_for( year ), "quarters", "#{step.param_name}[]" )
  end

  def layout_months( step, year )
    layout_quarters_or_months( step.months_for( year ), "months", "#{step.param_name}[]" )
  end

  def layout_quarters_or_months( mqs, prompt, param_name )
    capture do
      concat prompted_row(
        ->(){ content_tag( :span, prompt, {class: "prompt"} ) },
        ->(){
          content_tag( :ul, {class: "list-inline"} ) do
            mqs.each do |q|
              concat( labelled_check_box_li( param_name, q.value, q.label ))
            end
          end
        }
      )
    end
  end

  def prompted_row( prompt_block, main_block )
    capture do
      concat( content_tag( :div, {class: "col-sm-12 col-md-2"} ) do
        prompt_block.call
      end )
      concat( content_tag( :div, {class: "col-sm-12 col-md-10"} ) do
        main_block.call
      end)
    end
  end

  def labelled_check_box_li( param_name, value, label )
    content_tag( :li ) do
      labelled_check_box( param_name, value, label )
    end
  end

  def labelled_check_box( param_name, value, label )
    content_tag( :label ) do
      concat check_box_tag( param_name, value )
      concat label
    end
  end
end
