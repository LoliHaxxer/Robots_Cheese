static class Fortnite extends Standard
{
  
  
  int movesIStorm;
  
  int moveLastStorm;
  
  int stormLevel;
  
  Set<Integer> blocked;
  
  Fortnite()
  {
    super();
    
    super.name = "Fortnite";
    
    super.colour = 0x9e56ebff;
    
    this.movesIStorm = 10;
    
    this.moveLastStorm = 0;
    
    this.stormLevel = 0;
    
    this.blocked = new HashSet();
  }
  
  void storm()
  {
    stormLevel += 1;
    
    final int w = (int)size.x, h = (int)size.y;
    
    for( int i = 0 ; i < field.length ; i += 1 )
    {
      final int x = i % w, y = i / w;
      
      if( x < stormLevel || y < stormLevel || w - x - 1 < stormLevel || h - y - 1 < stormLevel )
      {
        blocked.add( i );
        
        final Unit unit = field[ i ];
      
        if( unit != null && unit.type == T.King )
        {
          super.loser.add( unit.player );
          scene = game_over;
        }
      }
      
    }
  }
  
  boolean execute( Unit.Move move )
  {
    if( blocked.contains( move.tar ) )
    {
      return false;
    }
    
    final boolean r = super.execute( move );
    
    if( super.move - moveLastStorm >= movesIStorm )
    {
      storm();
    }
    
    return r;
  }
  
  void restart()
  {
    super.restart();
    
    moveLastStorm = 0;
    blocked.clear();
  }
  
  boolean tileVisible( int location )
  {
    return ! blocked.contains( location );
  }
  
  void drawBoard( PGraphics g, int ALPHASCALE )
  {
    C px = cam.px( topNameBuffer );
    
    C ar = size.sca( CS.tilesize * cam.zoom );
    
    g.noStroke();
    filla( g, ALPHASET( colour, 0x88 * ALPHASCALE / 0xff ) );
    
    g.rect( px.x, px.y, ar.x, ar.y );
    
    super.drawBoard( g, ALPHASCALE );
  }
  
}
