static class FiMoveEveryUnit extends Standard
{

  Set moved = new HashSet();
  
  int has = CS.unitsG( field, turn ).size();
  
  boolean execute( Unit.Move move )
  {
    final P mover = turn;
    
    final boolean r = super.execute( move );
    
    
    if( r )
    {
      moved.add( move.unit() );
      
      if( has > moved.size() )
      {
        turn = mover;
      }
      else
      {
        moved.clear();
        has = CS.unitsG( field, turn ).size();
      }
    }
    
    return r;
  }
  
  void restart()
  {
    super.restart();
    
    moved.clear();
    has = CS.unitsG( field, turn ).size();
  }

}
