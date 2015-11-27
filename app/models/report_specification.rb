# Class encapsulating a set of options for a report

class ReportSpecification
  def initialize( params, report_manager )
    @params = HashWithIndifferentAccess.new( params )
    normalize_period( report_manager ) if @params[:period]
  end

  def to_hash
    @params
  end

  private

  def normalize_period( report_manager )
    case @params[:period].to_sym
    when :ytd
      @params[:period] = report_manager.latest_year

    when :latest_q
      @params[:period] = latest_quarter( report_manager )

    when :latest_m
      @params[:period] = report_manager.latest_month_spec
    end
  end

  def latest_quarter( report_manager )
    case report_manager.latest_month
    when 1..2
      "#{report_manager.latest_year - 1}-Q4"
    when 3..5
      "#{report_manager.latest_year}-Q1"
    when 6..8
      "#{report_manager.latest_year}-Q2"
    when 9..11
      "#{report_manager.latest_year}-Q3"
    when 12
      "#{report_manager.latest_year}-Q4"
    end
  end

end
