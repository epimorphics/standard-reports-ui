# Workflow step of selecting a country
# This is a degerate case because we don't let the user choose!

class StepSelectCountry < StepSelectArea
  ENGLAND_AND_WALES = "EW"

  def initialize
    super( :select_country, :area, :none )
  end

  def traverse( workflow )
    workflow.set_state( :area, ENGLAND_AND_WALES )
    workflow.traverse_to( :select_aggregation_type )
  end

  def summarise( value, connector = "is ")
    "country #{connector}England and Wales"
  end

  def subtype
    "country"
  end
  alias :subtype_label :subtype
end
