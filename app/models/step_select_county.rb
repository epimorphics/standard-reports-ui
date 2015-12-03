# Workflow step of selecting a county

class StepSelectCounty < Step

  def initialize
    super( :select_county, :area, :textinput )
  end

  def values( workflow = nil )
    NAMES.map do |county_name|
      Struct::StepValue.new( county_name.split.map(&:capitalize).join(' '), county_name )
    end
  end

  def traverse( workflow )
    value = workflow.state( param_name )
    if value
      validate_with( workflow, value )
    else
      self
    end
  end

  def validate_with( workflow, value )
    validated_value = validate( value )
    if validated_value
      workflow.set_state( param_name, validated_value )
      workflow.traverse_to( :select_aggregation_type )
    else
      set_flash( "Sorry, county '#{value}' was not recognised" )
    end
  end

  def summarise( state_value )
    "Region is #{state_value}"
  end

  def validate( value )
    normalized_value = value.upcase
    NAMES.include?( normalized_value ) && normalized_value
  end

  NAMES = [
    "BATH AND NORTH EAST SOMERSET",
    "BEDFORD",
    "BLACKBURN WITH DARWEN",
    "BLACKPOOL",
    "BLAENAU GWENT",
    "BOURNEMOUTH",
    "BRACKNELL FOREST",
    "BRIDGEND",
    "BRIGHTON AND HOVE",
    "BUCKINGHAMSHIRE",
    "CAERPHILLY",
    "CAMBRIDGESHIRE",
    "CARDIFF",
    "CARMARTHENSHIRE",
    "CENTRAL BEDFORDSHIRE",
    "CEREDIGION",
    "CHESHIRE EAST",
    "CHESHIRE WEST AND CHESTER",
    "CITY OF BRISTOL",
    "CITY OF DERBY",
    "CITY OF KINGSTON UPON HULL",
    "CITY OF NOTTINGHAM",
    "CITY OF PETERBOROUGH",
    "CITY OF PLYMOUTH",
    "CONWY",
    "CORNWALL",
    "COUNTY DURHAM",
    "CUMBRIA",
    "DARLINGTON",
    "DENBIGHSHIRE",
    "DERBYSHIRE",
    "DEVON",
    "DORSET",
    "EAST RIDING OF YORKSHIRE",
    "EAST SUSSEX",
    "ESSEX",
    "FLINTSHIRE",
    "GLOUCESTERSHIRE",
    "GREATER LONDON",
    "GREATER MANCHESTER",
    "GWYNEDD",
    "HALTON",
    "HAMPSHIRE",
    "HARTLEPOOL",
    "HEREFORDSHIRE",
    "HERTFORDSHIRE",
    "ISLE OF ANGLESEY",
    "ISLE OF WIGHT",
    "ISLES OF SCILLY",
    "KENT",
    "LANCASHIRE",
    "LEICESTER",
    "LEICESTERSHIRE",
    "LINCOLNSHIRE",
    "LUTON",
    "MEDWAY",
    "MERSEYSIDE",
    "MERTHYR TYDFIL",
    "MIDDLESBROUGH",
    "MILTON KEYNES",
    "MONMOUTHSHIRE",
    "NEATH PORT TALBOT",
    "NEWPORT",
    "NORFOLK",
    "NORTH EAST LINCOLNSHIRE",
    "NORTH LINCOLNSHIRE",
    "NORTH SOMERSET",
    "NORTH YORKSHIRE",
    "NORTHAMPTONSHIRE",
    "NORTHUMBERLAND",
    "NOTTINGHAMSHIRE",
    "OXFORDSHIRE",
    "PEMBROKESHIRE",
    "POOLE",
    "PORTSMOUTH",
    "POWYS",
    "READING",
    "REDCAR AND CLEVELAND",
    "RHONDDA CYNON TAFF",
    "RUTLAND",
    "SHROPSHIRE",
    "SLOUGH",
    "SOMERSET",
    "SOUTH GLOUCESTERSHIRE",
    "SOUTH YORKSHIRE",
    "SOUTHAMPTON",
    "SOUTHEND-ON-SEA",
    "STAFFORDSHIRE",
    "STOCKTON-ON-TEES",
    "STOKE-ON-TRENT",
    "SUFFOLK",
    "SURREY",
    "SWANSEA",
    "SWINDON",
    "THE VALE OF GLAMORGAN",
    "THURROCK",
    "TORBAY",
    "TORFAEN",
    "TYNE AND WEAR",
    "WARRINGTON",
    "WARWICKSHIRE",
    "WEST BERKSHIRE",
    "WEST MIDLANDS",
    "WEST SUSSEX",
    "WEST YORKSHIRE",
    "WILTSHIRE",
    "WINDSOR AND MAIDENHEAD",
    "WOKINGHAM",
    "WORCESTERSHIRE",
    "WREKIN",
    "WREXHAM",
    "YORK"
  ]

end
