static class FiCGOC extends FiMoveEveryUnit implements Fi
{
  
  static final int minSurviveReq = 2, maxSurviveReq = 3;
  
  static final int minBirthReq = 3, maxBirthReq = 3;
  
  
  FiCGOC()
  {
    super();
    
    super.name = "Conway's Game of Chess";
    
    super.colour = RGBA( 0x91f94f );
    
  }
  
  Unit[] starting()
  {
    
    return new Unit[]{
      
      null, null, null, new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.King ), new Unit( P.Black, T.Pawn ), null, null,
      null, null, null, null, null, null, null, null, 
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, new Unit( P.White, T.Pawn ), new Unit( P.White, T.King ), new Unit( P.White, T.Pawn ), null, null, 
      
    };
  
  }
  
  void generate( P player )
  {
    final int w = (int)size.x;
    
    final Unit[] toPlace = new Unit[ field.length ];
    
    for( int i = 0 ; i < field.length ; i += 1 )
    {
      
      final Unit unit = field[ i ];
      
      final boolean occupied = unit != null;
      
      if( occupied && unit.player != player )
      {
        toPlace[ i ] = unit;
        continue;
      }
      
      int neighbours = 0;
      
      for( int add : new int[]{ - 1 - w, - w, 1 - w, - 1, 1, - 1 + w, w, 1 + w, } )
      {
        final int tar = i + add;
        
        if( ! bounds( tar, field.length ) )
        {
          continue;
        }
        
        final Unit u = field[ tar ];
        
        if( u != null && u.player == player )
        {
          neighbours += 1;
        }
      }
      
      if( occupied )
      {
        if( neighbours >= minSurviveReq && neighbours <= maxSurviveReq )
        {
          toPlace[ i ] = field[ i ];
        }
      }
      else
      {
        if( neighbours >= minBirthReq && neighbours <= maxBirthReq )
        {
          toPlace[ i ] = next( player );
        }
      }
      
    }
    
    this.field = toPlace;
  }
  
  Unit next( final P player )
  {
    final int[] cs = new int[ T.cT ];
    
    for( Unit u : field )
    {
      if( u != null && u.player == player )
      {
        {
          cs[ u.type.ordinal() ] += 1;
        }
      }
    }
    
    for( int i = 0 ; i < T.cT ; i += 1 )
    {
      final int c = cs[ i ];
      
      final T t = T.values[ i ];
      
      if( c < t.count )
      {
        return new Unit( player, t );
      }
    }
    
    return null;
    
  }
  
  
  List<Unit.Move> movesG( int location )
  {
    
    final Unit unit = field[ location ];
    
    final List<Unit.Move> rr;
    
    if( unit.type == T.Pawn )
    {
      
      rr = new ArrayList();
    
      final int w = (int)size.x;
      final int size = field.length;
      
      for( int dir : new int[]{ 1, - 1, w, - w, } )
      {
        final int tar = location + dir;
        
        if( bounds( tar, size ) && field[ tar ] == null )
        {
          rr.add( unit.new Move( location, tar, Unit.Note.PawnMove ) );
          
        }
      }
      
      for( int dir : new int[]{ - 1 - w, 1 - w, - 1 + w, 1 + w } )
      {
        final int tar = location + dir;
        
        final Unit u;
        
        if( bounds( tar, size ) && ( u = field[ tar ] ) != null && u.player != unit.player )
        {
          rr.add( unit.new Move( location, tar, Unit.Note.KillingBlow ) );
        }
      }
      
    }
    else
    {
      rr = CS.movesG( this, location );
    }
      
    rr.add( unit.new Move( location, location ) );
    
    return rr;
  }
  
  boolean relevantLegal()
  {
    return false;
  }
  
  boolean relevantMate()
  {
    return false;
  }
  
  boolean castling()
  {
    return false;
  }
  
  boolean execute( Unit.Move move )
  {
    final P mover = turn;
    
    final boolean r = super.execute( move );
    
    if( turn != mover )
    {
      generate( mover );
    
      if( CS.unitsG( field, mover ).isEmpty() )
      {
        loser.add( mover );
        
        scene = game_over;
      }
    }
    
    return r;
  }
  
  void markup( PGraphics g, int ALPHASCALE, int location )
  {
    final Unit unit = field[ location ];
    
    if( unit != null && unit.player == turn && ! moved.contains( unit ) )
    {
      g.noStroke();
      filla( g, ALPHASCALE( 0xff000023, ALPHASCALE ) );
      
      C px = cam.px( new C( location % CS.w, location / CS.w ).sca( CS.tilesize ).add( topNameBuffer ) );
      
      g.rect( px.x, px.y, CS.tilesize * cam.zoom, CS.tilesize * cam.zoom );
    }
  }
  
}
