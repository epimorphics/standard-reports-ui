# frozen_string_literal: true

# Workflow step of selecting a county
class StepSelectDistrict < StepSelectCountyOrDistrict
  def initialize
    super(:select_district, :area)
  end

  def subtype
    'district'
  end
  alias subtype_label subtype

  def names
    NAMES
  end

  def input_label
    'District or local authority name'
  end

  def successor_step
    :select_aggregation_type
  end

  NAMES = [
    'ADUR',
    'ALLERDALE',
    'AMBER VALLEY',
    'ARUN',
    'ASHFIELD',
    'ASHFORD',
    'AYLESBURY VALE',
    'BABERGH',
    'BARKING AND DAGENHAM',
    'BARNET',
    'BARNSLEY',
    'BARROW-IN-FURNESS',
    'BASILDON',
    'BASINGSTOKE AND DEANE',
    'BASSETLAW',
    'BATH AND NORTH EAST SOMERSET',
    'BEDFORD',
    'BEXLEY',
    'BIRMINGHAM',
    'BLABY',
    'BLACKBURN WITH DARWEN',
    'BLACKPOOL',
    'BLAENAU GWENT',
    'BOLSOVER',
    'BOLTON',
    'BOSTON',
    'BOURNEMOUTH',
    'BRACKNELL FOREST',
    'BRADFORD',
    'BRAINTREE',
    'BRECKLAND',
    'BRENT',
    'BRENTWOOD',
    'BRIDGEND',
    'BRIGHTON AND HOVE',
    'BROADLAND',
    'BROMLEY',
    'BROMSGROVE',
    'BROXBOURNE',
    'BROXTOWE',
    'BURNLEY',
    'BURY',
    'CAERPHILLY',
    'CALDERDALE',
    'CAMBRIDGE',
    'CAMDEN',
    'CANNOCK CHASE',
    'CANTERBURY',
    'CARDIFF',
    'CARLISLE',
    'CARMARTHENSHIRE',
    'CASTLE POINT',
    'CENTRAL BEDFORDSHIRE',
    'CEREDIGION',
    'CHARNWOOD',
    'CHELMSFORD',
    'CHELTENHAM',
    'CHERWELL',
    'CHESHIRE EAST',
    'CHESHIRE WEST AND CHESTER',
    'CHESTERFIELD',
    'CHICHESTER',
    'CHILTERN',
    'CHORLEY',
    'CHRISTCHURCH',
    'CITY OF BRISTOL',
    'CITY OF DERBY',
    'CITY OF KINGSTON UPON HULL',
    'CITY OF LONDON',
    'CITY OF NOTTINGHAM',
    'CITY OF PETERBOROUGH',
    'CITY OF PLYMOUTH',
    'CITY OF WESTMINSTER',
    'COLCHESTER',
    'CONWY',
    'COPELAND',
    'CORBY',
    'CORNWALL',
    'COTSWOLD',
    'COUNTY DURHAM',
    'COVENTRY',
    'CRAVEN',
    'CRAWLEY',
    'CROYDON',
    'DACORUM',
    'DARLINGTON',
    'DARTFORD',
    'DAVENTRY',
    'DENBIGHSHIRE',
    'DERBYSHIRE DALES',
    'DONCASTER',
    'DOVER',
    'DUDLEY',
    'EALING',
    'EAST CAMBRIDGESHIRE',
    'EAST DEVON',
    'EAST DORSET',
    'EAST HAMPSHIRE',
    'EAST HERTFORDSHIRE',
    'EAST LINDSEY',
    'EAST NORTHAMPTONSHIRE',
    'EAST RIDING OF YORKSHIRE',
    'EAST STAFFORDSHIRE',
    'EAST SUFFOLK',
    'EASTBOURNE',
    'EASTLEIGH',
    'EDEN',
    'ELMBRIDGE',
    'ENFIELD',
    'EPPING FOREST',
    'EPSOM AND EWELL',
    'EREWASH',
    'EXETER',
    'FAREHAM',
    'FENLAND',
    'FLINTSHIRE',
    'FOLKESTONE AND HYTHE',
    'FOREST HEATH',
    'FOREST OF DEAN',
    'FYLDE',
    'GATESHEAD',
    'GEDLING',
    'GLOUCESTER',
    'GOSPORT',
    'GRAVESHAM',
    'GREAT YARMOUTH',
    'GREENWICH',
    'GUILDFORD',
    'GWYNEDD',
    'HACKNEY',
    'HALTON',
    'HAMBLETON',
    'HAMMERSMITH AND FULHAM',
    'HARBOROUGH',
    'HARINGEY',
    'HARLOW',
    'HARROGATE',
    'HARROW',
    'HART',
    'HARTLEPOOL',
    'HASTINGS',
    'HAVANT',
    'HAVERING',
    'HEREFORDSHIRE',
    'HERTSMERE',
    'HIGH PEAK',
    'HILLINGDON',
    'HINCKLEY AND BOSWORTH',
    'HORSHAM',
    'HOUNSLOW',
    'HUNTINGDONSHIRE',
    'HYNDBURN',
    'IPSWICH',
    'ISLE OF ANGLESEY',
    'ISLE OF WIGHT',
    'ISLES OF SCILLY',
    'ISLINGTON',
    'KENSINGTON AND CHELSEA',
    'KETTERING',
    "KING'S LYNN AND WEST NORFOLK",
    'KINGSTON UPON THAMES',
    'KIRKLEES',
    'KNOWSLEY',
    'LAMBETH',
    'LANCASTER',
    'LEEDS',
    'LEICESTER',
    'LEWES',
    'LEWISHAM',
    'LICHFIELD',
    'LINCOLN',
    'LIVERPOOL',
    'LUTON',
    'MAIDSTONE',
    'MALDON',
    'MALVERN HILLS',
    'MANCHESTER',
    'MANSFIELD',
    'MEDWAY',
    'MELTON',
    'MENDIP',
    'MERTHYR TYDFIL',
    'MERTON',
    'MID DEVON',
    'MID SUFFOLK',
    'MID SUSSEX',
    'MIDDLESBROUGH',
    'MILTON KEYNES',
    'MOLE VALLEY',
    'MONMOUTHSHIRE',
    'NEATH PORT TALBOT',
    'NEW FOREST',
    'NEWARK AND SHERWOOD',
    'NEWCASTLE UPON TYNE',
    'NEWCASTLE-UNDER-LYME',
    'NEWHAM',
    'NEWPORT',
    'NORTH DEVON',
    'NORTH DORSET',
    'NORTH EAST DERBYSHIRE',
    'NORTH EAST LINCOLNSHIRE',
    'NORTH HERTFORDSHIRE',
    'NORTH KESTEVEN',
    'NORTH LINCOLNSHIRE',
    'NORTH NORFOLK',
    'NORTH SOMERSET',
    'NORTH TYNESIDE',
    'NORTH WARWICKSHIRE',
    'NORTH WEST LEICESTERSHIRE',
    'NORTHAMPTON',
    'NORTHUMBERLAND',
    'NORWICH',
    'NUNEATON AND BEDWORTH',
    'OADBY AND WIGSTON',
    'OLDHAM',
    'OXFORD',
    'PEMBROKESHIRE',
    'PENDLE',
    'POOLE',
    'PORTSMOUTH',
    'POWYS',
    'PRESTON',
    'PURBECK',
    'READING',
    'REDBRIDGE',
    'REDCAR AND CLEVELAND',
    'REDDITCH',
    'REIGATE AND BANSTEAD',
    'RHONDDA CYNON TAFF',
    'RIBBLE VALLEY',
    'RICHMOND UPON THAMES',
    'RICHMONDSHIRE',
    'ROCHDALE',
    'ROCHFORD',
    'ROSSENDALE',
    'ROTHER',
    'ROTHERHAM',
    'RUGBY',
    'RUNNYMEDE',
    'RUSHCLIFFE',
    'RUSHMOOR',
    'RUTLAND',
    'RYEDALE',
    'SALFORD',
    'SANDWELL',
    'SCARBOROUGH',
    'SEDGEMOOR',
    'SEFTON',
    'SELBY',
    'SEVENOAKS',
    'SHEFFIELD',
    'SHEPWAY',
    'SHROPSHIRE',
    'SLOUGH',
    'SOLIHULL',
    'SOMERSET WEST AND TAUNTON',
    'SOUTH BUCKS',
    'SOUTH CAMBRIDGESHIRE',
    'SOUTH DERBYSHIRE',
    'SOUTH GLOUCESTERSHIRE',
    'SOUTH HAMS',
    'SOUTH HOLLAND',
    'SOUTH KESTEVEN',
    'SOUTH LAKELAND',
    'SOUTH NORFOLK',
    'SOUTH NORTHAMPTONSHIRE',
    'SOUTH OXFORDSHIRE',
    'SOUTH RIBBLE',
    'SOUTH SOMERSET',
    'SOUTH STAFFORDSHIRE',
    'SOUTH TYNESIDE',
    'SOUTHAMPTON',
    'SOUTHEND-ON-SEA',
    'SOUTHWARK',
    'SPELTHORNE',
    'ST ALBANS',
    'ST EDMUNDSBURY',
    'ST HELENS',
    'STAFFORD',
    'STAFFORDSHIRE MOORLANDS',
    'STEVENAGE',
    'STOCKPORT',
    'STOCKTON-ON-TEES',
    'STOKE-ON-TRENT',
    'STRATFORD-ON-AVON',
    'STROUD',
    'SUFFOLK COASTAL',
    'SUNDERLAND',
    'SURREY HEATH',
    'SUTTON',
    'SWALE',
    'SWANSEA',
    'SWINDON',
    'TAMESIDE',
    'TAMWORTH',
    'TANDRIDGE',
    'TAUNTON DEANE',
    'TEIGNBRIDGE',
    'TENDRING',
    'TEST VALLEY',
    'TEWKESBURY',
    'THANET',
    'THE VALE OF GLAMORGAN',
    'THREE RIVERS',
    'THURROCK',
    'TONBRIDGE AND MALLING',
    'TORBAY',
    'TORFAEN',
    'TORRIDGE',
    'TOWER HAMLETS',
    'TRAFFORD',
    'TUNBRIDGE WELLS',
    'UTTLESFORD',
    'VALE OF WHITE HORSE',
    'WAKEFIELD',
    'WALSALL',
    'WALTHAM FOREST',
    'WANDSWORTH',
    'WARRINGTON',
    'WARWICK',
    'WATFORD',
    'WAVENEY',
    'WAVERLEY',
    'WEALDEN',
    'WELLINGBOROUGH',
    'WELWYN HATFIELD',
    'WEST BERKSHIRE',
    'WEST DEVON',
    'WEST DORSET',
    'WEST LANCASHIRE',
    'WEST LINDSEY',
    'WEST OXFORDSHIRE',
    'WEST SOMERSET',
    'WEST SUFFOLK',
    'WEYMOUTH AND PORTLAND',
    'WIGAN',
    'WILTSHIRE',
    'WINCHESTER',
    'WINDSOR AND MAIDENHEAD',
    'WIRRAL',
    'WOKING',
    'WOKINGHAM',
    'WOLVERHAMPTON',
    'WORCESTER',
    'WORTHING',
    'WREKIN',
    'WREXHAM',
    'WYCHAVON',
    'WYCOMBE',
    'WYRE',
    'WYRE FOREST',
    'YORK'
  ].freeze
end
