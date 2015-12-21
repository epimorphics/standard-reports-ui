# Workflow step of selecting report dates

class StepSelectDates < Step
  attr_reader :report_manager_service

  # The earliest year for which we have data
  EARLIEST_YEAR = 1995

  # The number of selectable years the step shows by default
  YEARS_SHOWN_BY_DEFAULT = 2

  def initialize( report_manager_service = ReportManager.new )
    super( :select_dates, :period, :dates )
    @report_manager_service = report_manager_service
  end

  def values( workflow )
    {latest: latest_values( workflow )}
  end

  def months_for( year, workflow )
    period_values( workflow, year,
      scale: 1,
      value_fn: ->( m, y ){ "%04d-%02d" % [y, m] },
      label_fn: ->( m, y ){ "#{I18n.t("date.abbr_month_names")[m]} #{y}" }
    )
  end

  def quarters_for( year, workflow )
    period_values( workflow, year,
      scale: 3,
      value_fn: ->( q, y ){ "#{y}-Q#{q}" },
      label_fn: ->( q, y ){ "Q#{q} #{y}" }
    )
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_options )
  end

  def summarise( state_values, connector = "are " )
    "<span class='c-review-report--summary-key'>dates #{connector}</span>" +
    "#{state_values.map( &summarise_value ).join( " <span class='c-review-report--summary-key'>and</span> " )}"
  end

  def multivalued?
    true
  end

  def generic_name
    "select dates"
  end

  def each_year( hidden_only = true )
    start_delta = hidden_only ? YEARS_SHOWN_BY_DEFAULT : 0
    delta = Time.now.year - EARLIEST_YEAR
    (start_delta..delta).each do |d|
      yield d
    end
  end

  private

  def year_values( workflow )
    (EARLIEST_YEAR .. latest_year).map do |year|
      create_value( year, year.to_s, workflow )
    end
  end

  def period_values( workflow, year, m_or_q )
    latest_m = (year == latest_year) ? report_manager_service.latest_month : 12
    latest_mq = (latest_m / m_or_q[:scale]).to_i
    (1..latest_mq).map do |mq|
      create_value( m_or_q[:label_fn].call( mq, year ),
                    m_or_q[:value_fn].call( mq, year ),
                    workflow )
    end
  end

  def latest_year
    report_manager_service.latest_year
  end

  def latest_values( workflow )
    [
      create_value( "Year to date", :ytd, workflow ),
      create_value( "Latest quarter for which data is available", :latest_q, workflow ),
      create_value( "Latest month for which data is available", :latest_m, workflow )
    ]
  end

  def summarise_value
    Proc.new {|state_value|
      s = case state_value.to_sym
      when :ytd
        "year to date"
      when :latest_q
        "latest quarter for which data is available"
      when :latest_m
        "latest month for which data is available"
      else
        state_value
      end
      "<span class='summary-value'>#{s}</span>"
    }
  end

end
