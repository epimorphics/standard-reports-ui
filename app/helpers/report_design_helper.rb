# frozen_string_literal: true

# :nodoc:
module ReportDesignHelper # rubocop:disable Metrics/ModuleLength
  def workflow_step_form(workflow) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    step = workflow.current_step

    form_tag(workflow.form_action, method: 'get') do
      content_tag(:div, class: 'row') do
        concat(content_tag(:fieldset, class: 'col-sm-12 col-md-6') do
          concat layout_existing_values(workflow)
          concat layout_flash(step)
          concat layout_workflow_form(workflow, step)
        end)
        concat layout_map_control(step) if step.map_enabled?
        concat layout_submit_button
      end
    end
  end

  def layout_workflow_form(workflow, step)
    capture do
      case step.layout
      when :radio
        layout_workflow_radio_buttons(workflow, step)
      when :textinput
        layout_textinput(workflow, step)
      end
    end
  end

  def layout_workflow_radio_buttons(workflow, step)
    layout_values_as_toggle_buttons_list(step, step.values(workflow), true)
  end

  def layout_values_as_toggle_buttons_list(step, values, radio, cls = '')
    content_tag(:ul, class: 'list-unstyled') do
      layout_values_as_toggle_buttons(step, values, radio, cls)
    end
  end

  def layout_values_as_toggle_buttons(step, values, radio, cls = '')
    capture do
      values.each do |value|
        concat(
          content_tag(:li, class: cls) do
            toggle_button_option(step, value, radio, values.size == 1)
          end
        )
      end
    end
  end

  def toggle_button_option(step, value, radio, single_value) # rubocop:disable Metrics/MethodLength
    active = value.active? || single_value

    content_tag(:div, class: 'o-form-control') do
      content_tag(:label, class: 'o-form-control--label') do
        if radio
          concat radio_button_tag(step.form_param, value.value, active,
                                  class: 'o-form-control--input')
        else
          concat check_box_tag(step.form_param, value.value, active,
                               id: nil,
                               class: 'o-form-control--input')
        end
        concat value.label
      end
    end
  end

  def layout_textinput(workflow, step)
    content_tag(:div, class: 'o-form-control') do
      content_tag(:label, class: 'o-form-control--label form-label') do
        concat(step.input_label)
        concat(text_field_tag(step.param_name, workflow.state(step.param_name),
                              id: nil,
                              class: 'o-form-control--input'))
      end
    end
  end

  def layout_flash(step)
    capture do
      if step.flash
        content_tag(:p, nil, class: 'bg-warning flash warning') do
          step.flash
        end
      end
    end
  end

  def layout_submit_button
    content_tag(:div, class: 'c-form-actions col-sm-12') do
      concat submit_tag('Next', class: 'button c-form-submit', name: nil)
      concat link_to('back', '#', class: 'button button--secondary c-back-action')
    end
  end

  def layout_existing_values(workflow)
    current_param = workflow.current_step.param_name

    capture do
      workflow.each_state_ignoring(current_param) do |_state_name, state_value, param_name|
        concat(
          hidden_field_tag(param_name, state_value)
        )
      end
    end
  end

  def selected_area_summary(workflow)
    workflow
      .prior_step
      .summarise_current_value(workflow)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def layout_custom_dates(delta, step, workflow)
    year = Time.now.year - delta
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'col-sm-12 col-md-1') do
        content_tag(:h3, year.to_s, class: 'u-font-bold u-align-top')
      end)
      concat(content_tag(:div, class: 'col-sm-12 col-md-11') do
        concat(layout_all_year(step, year, workflow))
        concat(layout_quarters(step, year, workflow))
        concat(layout_months(step, year, workflow))
      end)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def layout_all_year(step, year, workflow)
    all_year = year == Time.now.year ? 'to date' : 'all year'
    checked = workflow.has_state?(step.param_name, year.to_s)
    capture do
      concat prompted_row(
        -> { labelled_check_box("#{step.param_name}[]", year, "#{year} #{all_year}", checked) }
      )
    end
  end

  def layout_quarters(step, year, workflow)
    layout_quarters_or_months(step.quarters_for(year, workflow), 'quarters', "#{step.param_name}[]")
  end

  def layout_months(step, year, workflow)
    layout_quarters_or_months(step.months_for(year, workflow), 'months', "#{step.param_name}[]")
  end

  def layout_quarters_or_months(mqs, _prompt, param_name) # rubocop:disable Metrics/MethodLength
    capture do
      concat prompted_row(
        lambda {
          content_tag(:ul, class: 'list-inline') do
            mqs.each do |q|
              concat(labelled_check_box_li(param_name, q.value, q.label, q.active?))
            end
          end
        }
      )
    end
  end

  def prompted_row(main_block)
    capture do
      content_tag(:div, class: 'col-sm-12 col-md-10') do
        content_tag(:div, class: 'o-form-control') do
          main_block.call
        end
      end
    end
  end

  def labelled_check_box_li(param_name, value, label, checked)
    content_tag(:li, class: 'o-form-control--label-inline') do
      labelled_check_box(param_name, value, label, checked)
    end
  end

  def labelled_check_box(param_name, value, label, checked)
    content_tag(:label, class: 'o-form-control--label-inline') do
      concat check_box_tag(
        "#{param_name}#{value}",
        value.to_s, checked,
        class: 'o-form-control--input',
        name: param_name
      )
      concat label
    end
  end

  def review_selections(workflow)
    params = Workflow::STEP_SEQUENCE.map(&:param_name)
    capture do
      params.each do |state_name|
        if (step = workflow.step_with_param(state_name))
          concat(review_selection(workflow, step)) if step.respond_to?(:summarise)
        end
      end
    end
  end

  def review_selection(workflow, step)
    content_tag(:li) do
      concat step.summarise(workflow.state(step.param_name)).html_safe
      concat show_change_link(workflow, step)
    end
  end

  def show_change_link(workflow, step)
    link_to(
      'change&hellip;'.html_safe,
      workflow.params.merge(stop: step.param_name),
      class: 'c-review-report--change-option copy-14',
      'aria-label' => "change report option #{step.name}"
    )
  end

  def layout_map_control(_step)
    content_tag(:div, class: 'col-sm-12 col-md-6') do
      content_tag(:div, id: 'map', class: 'o-map') do
      end
    end
  end
end
