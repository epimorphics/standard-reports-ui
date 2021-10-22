# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectCounty < StepSelectCountyOrDistrict # rubocop:disable Metrics/ClassLength
  def initialize
    super(:select_county, :area)
  end

  def subtype
    'county'
  end
  alias subtype_label subtype

  def names
    NAMES
  end

  def input_label
    'County or unitary authority name'
  end

  def map_enabled?
    true
  end

  NAMES = [
    'BATH AND NORTH EAST SOMERSET',
    'BEDFORD',
    'BLACKBURN WITH DARWEN',
    'BLACKPOOL',
    'BLAENAU GWENT',
    'BOURNEMOUTH',
    'BRACKNELL FOREST',
    'BRIDGEND',
    'BRIGHTON AND HOVE',
    'BUCKINGHAMSHIRE',
    'CAERPHILLY',
    'CAMBRIDGESHIRE',
    'CARDIFF',
    'CARMARTHENSHIRE',
    'CENTRAL BEDFORDSHIRE',
    'CEREDIGION',
    'CHESHIRE EAST',
    'CHESHIRE WEST AND CHESTER',
    'CITY OF BRISTOL',
    'CITY OF DERBY',
    'CITY OF KINGSTON UPON HULL',
    'CITY OF NOTTINGHAM',
    'CITY OF PETERBOROUGH',
    'CITY OF PLYMOUTH',
    'CONWY',
    'CORNWALL',
    'COUNTY DURHAM',
    'CUMBRIA',
    'DARLINGTON',
    'DENBIGHSHIRE',
    'DERBYSHIRE',
    'DEVON',
    'DORSET',
    'EAST RIDING OF YORKSHIRE',
    'EAST SUSSEX',
    'ESSEX',
    'FLINTSHIRE',
    'GLOUCESTERSHIRE',
    'GREATER LONDON',
    'GREATER MANCHESTER',
    'GWYNEDD',
    'HALTON',
    'HAMPSHIRE',
    'HARTLEPOOL',
    'HEREFORDSHIRE',
    'HERTFORDSHIRE',
    'ISLE OF ANGLESEY',
    'ISLE OF WIGHT',
    'ISLES OF SCILLY',
    'KENT',
    'LANCASHIRE',
    'LEICESTER',
    'LEICESTERSHIRE',
    'LINCOLNSHIRE',
    'LUTON',
    'MEDWAY',
    'MERSEYSIDE',
    'MERTHYR TYDFIL',
    'MIDDLESBROUGH',
    'MILTON KEYNES',
    'MONMOUTHSHIRE',
    'NEATH PORT TALBOT',
    'NEWPORT',
    'NORFOLK',
    'NORTH EAST LINCOLNSHIRE',
    'NORTH LINCOLNSHIRE',
    'NORTH NORTHAMPTONSHIRE',
    'NORTH SOMERSET',
    'NORTH YORKSHIRE',
    'NORTHAMPTONSHIRE',
    'NORTHUMBERLAND',
    'NOTTINGHAMSHIRE',
    'OXFORDSHIRE',
    'PEMBROKESHIRE',
    'POOLE',
    'PORTSMOUTH',
    'POWYS',
    'READING',
    'REDCAR AND CLEVELAND',
    'RHONDDA CYNON TAFF',
    'RUTLAND',
    'SHROPSHIRE',
    'SLOUGH',
    'SOMERSET',
    'SOUTH GLOUCESTERSHIRE',
    'SOUTH YORKSHIRE',
    'SOUTHAMPTON',
    'SOUTHEND-ON-SEA',
    'STAFFORDSHIRE',
    'STOCKTON-ON-TEES',
    'STOKE-ON-TRENT',
    'SUFFOLK',
    'SURREY',
    'SWANSEA',
    'SWINDON',
    'THE VALE OF GLAMORGAN',
    'THURROCK',
    'TORBAY',
    'TORFAEN',
    'TYNE AND WEAR',
    'WARRINGTON',
    'WARWICKSHIRE',
    'WEST BERKSHIRE',
    'WEST MIDLANDS',
    'WEST NORTHAMPTONSHIRE',
    'WEST SUSSEX',
    'WEST YORKSHIRE',
    'WILTSHIRE',
    'WINDSOR AND MAIDENHEAD',
    'WOKINGHAM',
    'WORCESTERSHIRE',
    'WREKIN',
    'WREXHAM',
    'YORK'
  ].freeze
end
