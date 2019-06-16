static class FiEditor extends Standard
{
  
  boolean normalMovement;
  
  Box creatingSelectorPlayer, creatingSelectorType;
  
  P creatingPlayer;
  
  T creatingType;
  
  FiEditor()
  {
    
    super();
    
    this.name = "Editor";
    
    this.colour = 0xffff00ff;
    
    super.showThonking = false;
    
    final C measures = measures();
    
    final float seg = 27;
    
    this.creatingSelectorPlayer = Box.BoxLinesSeg( cam, new C( 0, topNameBuffer.y * .5 ), new C( measures.x * .5, topNameBuffer.y * .5 ), 1, seg );
    
    this.creatingSelectorPlayer.add
    (
      new Information()
      {
        public Object get()
        {
          Box.Field field = new Box.Field()
          {
            public void draw( PGraphics g, float zoom, float ltx, float lty, float arx, float ary )
            {
              super.draw( g, zoom, ltx, lty, arx, ary );
              
              stroke( g, RGBBLACK );
              g.strokeWeight( 3 * zoom );
              g.noFill();
              
              g.rect( ltx, lty, arx, ary );
            }
          };
          
          field.colorTextBack = creatingPlayer.cTrue;
          
          return field;
        }
      },
      new Runnable()
      {
        public void run()
        {
          final int i;
          creatingPlayer = P.values[ ( i = creatingPlayer.ordinal() + 1 ) >= P.values.length ? 0 : i ];
        }
      }
    );
    
    this.creatingSelectorType = Box.BoxLinesSeg( cam, new C( measures.x * .5, topNameBuffer.y * .5 ), new C( measures.x * .5, topNameBuffer.y * .5 ), 1, seg );
    
    this.creatingSelectorType.add
    (
      new Information()
      {
        public Object get()
        {
          Box.Field field = new Box.Field();
          
          field.s = new String[]{ creatingPlayer.unitChar( creatingType ) + "" };
          
          return field;
        }
      },
      new Runnable()
      {
        
        public void run()
        {
          
          final int i;
          creatingType = T.values[ ( i = creatingType.ordinal() + 1 ) >= T.values.length ? 0 : i ];
        }
      }
    );
    
    
    
    this.creatingPlayer = P.values[ 0 ];
    
    this.creatingType = T.values[ 0 ];
    
    this.turn = P.White;
    
  }
  
  List<Unit.Move> movesG( int location )
  {
    if( normalMovement )
    {
      return CS.movesG( this, location );
    }
    
    final Unit unit = field[ location ];
    
    List<Unit.Move> rr = new ArrayList();
    
    for( int i = 0 ; i < field.length ; i += 1 )
    {
      rr.add( unit.new Move( location, i ) );
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
  
  int state( P player )
  {
    return ingame;
  }
  
  boolean execute( Unit.Move move )
  {
    final boolean r = super.execute( move );
    
    return r;
  }
  
  void drawBoard( PGraphics g, int ALPHASCALE )
  {
    
    super.drawBoard( g, ALPHASCALE * 0x7f / 0xff );
    
    g.textFont( chessFont );
    
    this.creatingSelectorType.draw( g );
    
    g.textFont( textFont );
    
    this.creatingSelectorPlayer.draw( g );
    
  }
  
  void menu()
  {
    
    texter.add
    (
      ( normalMovement ? "✓" : "   " ) + "Normal Movement",
      new Runnable()
      {
        public void run()
        {
          normalMovement = ! normalMovement;
        }
      }
    );
    
    menuOptionRestart();
    
    menuOptionClear();
  }
  
  
  void boardClicked( int location, int mouseButton )
  {
    
    if( mouseButton == RIGHT )
    {
      field[ location ] = null;
      
      selected = -1;
      
      return;
    }
    
    if ( location >= 0 && location < CS.w * CS.w && tileVisible( location ) )
    {
      if( selected == -1 )
      {
        if( field[ location ] == null )
        {
          
          field[ location ] = new Unit( creatingPlayer, creatingType );
          
        }
        else
        {
          selected = location;
        
          cachedMoves = movesG( location );
          
          turn = field[ selected ].player;
        }
      }
      else
      {
        if ( bounds( location, field.length ) )
        {
          for ( Unit.Move move : cachedMoves )
          {
            if ( move.tar == location )
            {
              execute( move );
              selected = -1;
              
              return;
            }
          }
        }
        selected = - 1;
      }

    }
    
  }
  
  void mouseClicked( C mouse, int mouseButton )
  {
    
    for( Box box : new Box[]{ creatingSelectorPlayer, creatingSelectorType } )
    {
      if( mouse.collides( box.shape() ) )
      {
        box.mouseClicked( mouse, mouseButton );
        return;
      }
    }
    
    super.mouseClicked( mouse, mouseButton );
    
  }

}
