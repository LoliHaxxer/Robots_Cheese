static class FiAntichess extends Standard
{
  
  List<Unit.Move> legals = new ArrayList();
  
  FiAntichess()
  {
    super();
    
    super.name = "Antichess";
    
    super.colour = RGBA( 0xf7bd0e );
  }
  
  
  List<Unit.Move> legals( P player )
  {
    List<Unit.Move> rr = new ArrayList();
    
    boolean slayerFound = false;
    
    for( int i = 0 ; i < field.length ; i += 1 )
    {
      if( field[ i ] != null && field[ i ].player == player )
      {
        for( Unit.Move move : CS.movesG( this, i ) )
        {
          if( ! slayerFound )
          {
            if( move.parameter.slaying )
            {
              
              rr.clear();
              slayerFound = true;
            }
            rr.add( move );
          }
          else if( move.parameter.slaying )
          {
            rr.add( move );
          }
        }
      }
    }
    
    return rr;
  }
  
  
  List<Unit.Move> movesG( int location )
  {
    List rr = new ArrayList();
    
    for( Unit.Move legal : legals )
    {
      if( legal.org == location )
      {
        rr.add( legal );
      }
    }
    
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
  
  void turnCache()
  {
    this.legals = this.legals( turn );
  }
  
  boolean execute( Unit.Move move )
  {
    final boolean r = super.execute( move );
    
    if( CS.unitsG( field, turn ).isEmpty() )
    {
      for( P player : players )
      {
        if( player != turn )
        {
          super.loser.add( player );
          scene = game_over;
        }
      }
    }
    
    return r;
  }
  
}
