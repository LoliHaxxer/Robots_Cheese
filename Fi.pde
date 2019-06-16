static interface FiEx
{
  int move();
  C size();
  Unit[] field();
  List<Unit.Move> movesG( int location );
  boolean execute( Unit.Move move );
  boolean castling();
}

static interface Fi extends FiEx, UIE
{
  
  String name();
  int colour();
  
}

static int iFiStandard = 0, iFiFortnite = 3, iFiCGOC = 2, iFiBuyingChess = 1, iFiEditor = 6, iFiAntichess = 4, iFiTandem = 5, cField = 7;

static Fi[] fields = new Fi[ cField ];

static void fi()
{
  fields[ iFiStandard ] = new Standard();
  fields[ iFiFortnite ] = new Fortnite();
  fields[ iFiCGOC ] = new FiCGOC();
  fields[ iFiBuyingChess ] = new FiBuyingChess();
  fields[ iFiEditor ] = new FiEditor();
  fields[ iFiAntichess ] = new FiAntichess();
  fields[ iFiTandem ] = new FiTandem();
}

static void engage( int i )
{
  UIEs.add( fields[ i ] );
  
}

static void disengage( int i )
{
  UIEs.remove( fields[ i ] );
}
