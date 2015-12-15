# Workflow step of selecting report dates

class StepSelectDates < Step
  attr_reader :report_manager_service

  EARLIEST_YEAR = 1995

  def initialize( report_manager_service = ReportManager.new )
    super( :select_dates, :period, :dates )
    @report_manager_service = report_manager_service
  end

  def values( workflow )
    {latest: latest_values}
  end

  def months_for( year )
    period_values( year,
      scale: 1,
      value_fn: ->( m, y ){ "%04d-%02d" % [y, m] },
      label_fn: ->( m, y ){ I18n.t("date.abbr_month_names")[m] }
    )
  end

  def quarters_for( year )
    period_values( year,
      scale: 3,
      value_fn: ->( q, y ){ "#{y}-Q#{q}" },
      label_fn: ->( q, y ){ "Q#{q}" }
    )
  end

  def traverse( workflow )
    simple_traverse( workflow, :select_options )
  end

  def summarise( state_value, connector = "are " )
    case state_value.to_sym
    when :ytd
      "dates #{connector}year to date"
    when :latest_q
      "dates #{connector}latest quarter for which data is available"
    when :latest_m
      "dates #{connector}latest month for which data is available"
    else
      "selected dates #{connector}#{state_value}"
    end
  end

  def multivalued?
    true
  end

  def generic_name
    "select dates"
  end

  def each_hidden_year
    delta = Time.now.year - EARLIEST_YEAR
    (2..delta).each do |d|
      yield d
    end
  end

  private

  def year_values
    (EARLIEST_YEAR .. latest_year).to_a
  end

  def period_values( year, m_or_q )
    latest_m = (year == latest_year) ? report_manager_service.latest_month : 12
    latest_mq = (latest_m / m_or_q[:scale]).to_i
    (1..latest_mq).map do |mq|
      Struct::StepValue.new( m_or_q[:label_fn].call( mq, year ),
                             m_or_q[:value_fn].call( mq, year ) )
    end
  end

  def latest_year
    report_manager_service.latest_year
  end

  def latest_values
    [
      Struct::StepValue.new( "Year to date", :ytd ),
      Struct::StepValue.new( "Latest quarter for which data is available", :latest_q ),
      Struct::StepValue.new( "Latest month for which data is available", :latest_m )
    ]
  end

end
