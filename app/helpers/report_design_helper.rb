module ReportDesignHelper
  def workflow_step_form( workflow )
    form_tag( {controller: :report_design, action: :show}, method: "get" ) do
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
    content_tag( :ul, class: "list-unstyled" ) do
      step.values( workflow ).each do |value|
        concat(
          content_tag( :li ) do
            radio_button_option( step, value )
          end
        )
      end
    end
  end

  def radio_button_option( step, value )
    capture do
      concat radio_button_tag( step.param_name, value.value )
      concat label_tag( :"#{step.param_name}_#{value.value}", value.label )
    end
  end

  def layout_submit_button
    submit_tag( "Next", class: "button", name: nil )
  end
end
