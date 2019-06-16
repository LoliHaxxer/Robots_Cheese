// Input_Robots

<A> List<A> g( Map<Integer,A> map, Pointer... p )
{
  List r = new ArrayList();
  
  for( Pointer pp : p )
  {
    r.add( map.get( pp.id ) );
  }
  
  return r;
}


List<C> startG( Pointer... p )
{
  return g( startPointer, p );
}
List<C> lastG( Pointer... p )
{
  return g( lastPointer, p );
}

static Map<Integer,UIE> startUIE = new HashMap();
static Map<Integer,C> startPointer = new HashMap();
static Map<Integer,C> lastPointer = new HashMap();

static Pointer[] lastTouches = new Pointer[]{};


void touchStarted(  )
{
  mouseClicked();
  
  startUIE.clear();
  startPointer.clear();
  for( TouchEvent.Pointer p : touches )
  {
    startUIE.put( p.id, top( new C( p.x, p.y ) ) );
    startPointer.put( p.id, new C( p.x, p.y ) );
  }
}

boolean zooming()
{
  return lastPointer.size() == 2 && touches.length == 2;
}

void touchMoved()
{
  if( zooming() )
  {
    
    List<UIE> start = g( startUIE, touches );

    
    if( start.get( 0 ) == start.get( 1 ) )
    {
      List<C> last = lastG( touches );
      List<C> moves = new ArrayList();
      
      for( int i = 0 ; i < touches.length ; i += 1 )
      {
        C l = last.get( i );
        Pointer c = touches[ i ];
        
        moves.add( new C( c.x, c.y ).sub( l ) );
      }
      
      final float dot = C.dot( moves.get( 0 ).unit(), moves.get( 1 ).unit() );

      
      if( dot < - .8 )
      {
        C diff = new C( touches[ 0 ].x - touches[ 1 ].x, touches[ 0 ].y - touches[ 1 ].y );
        C moveOne = moves.get( 0 );
        
        final float ddot = C.dot( moveOne.unit(), diff.unit() );
        
        mouse = new C( touches[ 1 ].x, touches[ 1 ].y ).add( diff.sca( .5 ) );
        
        mouseWheel( moveOne.len() * .1 * ( ddot < 0 ? 1 : -1 ) );
      }
    }
  }
  
  lastPointer.clear();
  for( TouchEvent.Pointer p : touches )
  {
    lastPointer.put( p.id, new C( p.x, p.y ) );
  }
}

void touchEnded()
{
  List<Integer> removedIds = new ArrayList();
  Set<Integer> lastIds = lastPointer.keySet();
  
  for( Pointer p : touches )
  {
    if( ! lastIds.contains( p.id ) )
    {
      removedIds.add( p.id );
    }
  }
  for( int rem : removedIds )
  {
    startUIE.remove( rem );
    startPointer.remove( rem );
  }
  
  //println( startUIE.size() );
}
