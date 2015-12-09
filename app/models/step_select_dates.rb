# Workflow step of selecting report dates

class StepSelectDates < Step
  attr_reader :report_manager_service

  EARLIEST_YEAR = 1995

  def initialize( report_manager_service = ReportManager.new )
    super( :select_dates, :period, :dates )
    @report_manager_service = report_manager_service
  end

  def values( workflow )
    {years: year_values,
     quarters: quarter_values,
     months: month_values,
     latest: latest_values
    }
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

  private

  def year_values
    (EARLIEST_YEAR .. latest_year).to_a
  end

  def quarter_values
    []
  end

  def month_values
    []
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
