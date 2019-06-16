
static class Standard implements Fi, UIE
{
  

  final C topNameBuffer = new C( 0, CS.topNameBuffer * 2 );
  
  final C botNameBuffer = new C( 0, CS.topNameBuffer );
  
  
  
  
  String name;
  
  int colour;
  
  
  List<UIE> UIEs = new ArrayList();
  

  static final int game = 0, menu = 1, game_over = 2;
  
  int scene = game;

  Box texter;
  
  Set<P> loser = new HashSet();
  
  Box texterGameOver;
  
  boolean showThonking = true;
  
  Box topBoxThonking, botBoxThonking;
      
  float segThonking = 15;
  
  
  boolean rotatingBoard = true;
  
  boolean debug;
  

  int move;
  
  P[] players;

  P turn;

  C size;

  Unit[] field;

  Cam cam;

  int selected = -1;

  List<Unit.Move> cachedMoves;
  
  List<Unit>[] dead;

  Standard()
  {
    
    this.name = "Standard Chess";
    
    this.colour = RGBA( RGBRED );
    
    this.move = 0;

    this.players = new P[  ]{ P.White, P.Black };

    this.turn = this.players[ 0 ];

    this.size = new C( CS.w, CS.w );

    this.field = this.starting();

    this.cam = new Cam( new C( w / 2, 0 ), 1 );
    
    this.texter = Box.BoxSegTs( cam, C.ZERO, size.sca( CS.tilesize ).add( topNameBuffer ), CS.topNameBuffer * .03, CS.topNameBuffer * .88 );
    
    this.texterGameOver = Box.BoxLinesSeg( cam, topNameBuffer.add( new C( 0, size.y * CS.tilesize * .5 - CS.tilesize ) ), new C( size.x * CS.tilesize, 2 * CS.tilesize ), 2, 2 );
    
    this.topBoxThonking = Box.BoxLinesSeg( cam, new C( topNameBuffer.x, topNameBuffer.y - CS.topNameBuffer ), new C( size.x * CS.tilesize, CS.topNameBuffer ), 1, segThonking );
    
    this.botBoxThonking = Box.BoxLinesSeg( cam, topNameBuffer.add( new C( 0, size.y * CS.tilesize ) ), new C( size.x * CS.tilesize, CS.topNameBuffer ), 1, segThonking );
    
    this.dead = new List[ P.cP ];
    
    this.turnCache();
  }
  
  Unit[] starting()
  {
    
    return CS.basic();
  
  }
  
  int field( C loc )
  {
    int r = ( int ) loc.x + ( int ) loc.y * CS.w;
    
    if( turn == P.Black && rotatingBoard )
    {
      r = field.length - 1 - r;
    }
    
    return r;
  }
  
  Shape.Rectangle field( int location )
  {
    if( turn == P.Black && rotatingBoard )
    {
      location = field.length - 1 - location;
    }
    
    return new Shape.Rectangle( cam.px( new C( location % CS.w, location / CS.w ).sca( CS.tilesize ).add( topNameBuffer ) ), new C( CS.tilesize * cam.zoom, CS.tilesize * cam.zoom ) );
  }
  
  String name()
  {
    return name;
  }
  
  int colour()
  {
    return colour;
  }

  int move()
  {
    return move;
  }

  C size()
  {
    return size;
  }

  Unit[] field()
  {
    return field;
  }

  boolean allowedMove( Unit unit )
  {
    return unit != null && ( debug || unit.player == this.turn );
  }

  List<Unit.Move> movesG( int location )
  {
    return allowedMove( field[ location ] ) ? (List)CS.movesG( this, location ) : Collections.emptyList();
  }

  boolean relevantLegal()
  {
    return true;
  }
  
  boolean relevantMate()
  {
    return true;
  }
  
  boolean castling()
  {
    return true;
  }
  
  static final int ingame = 0, lost = 1, win = 2;
  
  int state( P player )
  {
    if( relevantMate() && CS.mate( this, CS.kingsG( field, player ).keySet().iterator().next() ) )
    {
      return lost;
    }
    return ingame;
  }
  
  void turnCache()
  {}
  
  void turnNext()
  {
    for( int i = 0 ; i < players.length ; i += 1 )
    {
      if( players[ i ] == turn )
      {
        turn = players[ i == players.length - 1 ? 0 : i + 1 ];
        break;
      }
    }
    turnCache();
  }

  boolean execute( Unit.Move move )
  {
    this.move += 1;
    
    if( relevantLegal() && ! CS.legal( this, move ) )
    {
      return false;
    }
    
    boolean r = move.execute( field );
    
    if( move.slain != null )
    {
      final int pid = move.slain.player.ordinal();
      
      if( dead[ pid ] == null )
      {
        dead[ pid ] = new ArrayList();
        
        dead[ pid ].add( move.slain );
      }
      
    }
    
    if( ! debug )
    {
      turnNext();
    }
    
    if( state( turn ) == lost )
    {
      loser.add( turn );
      
      scene = game_over;
    }

    return r;
    
  }
  
  boolean loadState( Unit[] field )
  {
    if( field.length != this.field.length )
    {
      return false;
    }
    else if( relevantLegal() || relevantMate() )
    {
      for( P player : players )
      {
        if( CS.kingsG( field, player ).isEmpty() )
        {
          return false;
        }
      }
    }
    
    this.field = field;
    this.turnCache();
    
    return true;
  }
  
  void restart()
  {
    for( int i = 0 ; i < P.cP ; i += 1 )
    {
      dead[ i ] = null;
    }
    
    loser.clear();
    
    field = starting();
    turn = P.White;
    move = 0;
  }
  
  boolean tileVisible( int location )
  {
    return true;
  }
  
  // mark up a certain tile for more info
  void markup( PGraphics g, int ALPHASCALE, int location )
  {
  
  }
  
  void drawBoard( PGraphics g, int ALPHASCALE )
  {
      g.textFont( chessFont );

      int k, kcon, kdir;
      
      //println( turn, rotatingBoard );
      
      if( turn == P.Black && rotatingBoard )
      {
        k = field.length - 1;
        kcon = -1;
        kdir = -1;
      }
      else
      {
        k = 0;
        kcon = field.length;
        kdir = 1;
      }
      
      for ( int i = 0 ; k != kcon; k += kdir, i += 1 )
      {
        
        if( ! tileVisible( k ) )
        {
          continue;
        }
        
        filla( g, ( k % CS.w + k / CS.w ) % 2 == 0 ? ALPHASCALE( RGBA( RGBWHITE ), ALPHASCALE ) : ALPHASCALE( 0x888888ff, ALPHASCALE ) );
        g.noStroke();
  
        C px = cam.px( new C( i % CS.w, i / CS.w ).sca( CS.tilesize ).add( topNameBuffer ) );
  
        g.rect( px.x, px.y, CS.tilesize * cam.zoom, CS.tilesize * cam.zoom );
        
        
        boolean target = false;
        if( selected != -1 )
        {
          for( Unit.Move move : cachedMoves )
          {
            if( move.tar == k )
            {
              filla( g, ALPHASET( move.parameter.slaying ? RGBA( 0xf7635d ) : RGBA( 0x5df763 ), 0x55 ) );
              g.rect( px.x, px.y, CS.tilesize * cam.zoom, CS.tilesize * cam.zoom );
              target = true;
            }
          }
        }
        
        if( ! target )
        {
          //void markup( PGraphics g, int ALPHASCALE, int location )
          markup( g, ALPHASCALE, k );
        }
  
        Unit unit = field[ k ];
  
        if ( unit != null )
        {
          filla( g, ALPHASCALE( unit.player.c, ALPHASCALE ) );
          g.textSize( CS.tilesize * cam.zoom );
  
          g.text( unit.player.unitChar( unit.type ), px.x, px.y + g.textSize );
        }
      }
  
      if ( selected != -1 )
      {
        g.noFill();
        strokea( g, ALPHASCALE( 0x00ff00ff, ALPHASCALE ) );
        g.strokeWeight( 5 * cam.zoom );
  
        field( selected ).draw( g );
      }
      
      g.textFont( textFont );
      
      Box box = null;
      
      if( showThonking )
      {
        if( turn == P.Black && ! rotatingBoard )
        {
          box = topBoxThonking;
        }
        else if( turn != null )
        {
          box = botBoxThonking;
        }
      }
      
      if( box != null )
      {
        box.clear();
        
        box.add( "Thonking..." );
      
        box.draw( g );
      }
      
  }
  
  void menuOptionRotatingBoard()
  {
    texter.add
    (
      ( rotatingBoard ? "✓" : "   " ) + " Toggle rotating board",
      new Runnable()
      {
        public void run()
        {
          rotatingBoard = ! rotatingBoard;
        }
      }
    );
  }
  
  void menuOptionRestart()
  {
    texter.add
    (
      "Restart",
      new Runnable()
      {
        public void run()
        {
          restart();
          
          scene = game;
        }
      }
    );
  }
  
  void menuOptionClear()
  {
    texter.add
    (
      "Clear",
      new Runnable()
      {
        public void run()
        {
          field = new Unit[ field.length ];
          scene = game;
        }
      }
    );
  }
  
  void menuOptionLoadEditorState()
  {
    texter.add
    (
      "Load Editor State",
      new Runnable()
      {
        public void run()
        {
          final Unit[] org = fields[ iFiEditor ].field(); 
          final Unit[] copy = new Unit[ org.length ];
          System.arraycopy( org, 0, copy, 0, org.length );
          
          turn = ( (Standard) fields[ iFiEditor ] ).turn;
          
          loadState( copy );
          scene = game;
        }
      }
    );
  }
  
  void menuOptionDebug()
  {
    texter.add
    (
      ( debug ? "✓" : "   " ) + " Debug",
      new Runnable()
      {
        public void run()
        {
          debug = ! debug;
        }
      }
    );
  }
  
  void menu()
  {
    menuOptionLoadEditorState();
    
    menuOptionRestart();
    
    menuOptionRotatingBoard();
    
    menuOptionDebug();
  }

  void draw( PGraphics g )
  {

    strokea( g, colour );
    g.strokeWeight( cam.zoom );
    g.noFill();
    shape().draw( g );

    texter.colorText = colour;
    
    {
      g.textFont( textFont );
      
      texter.clear();
      
      texter.add(
        this.name,
        new Runnable()
        {
          public void run()
          {
            if( scene == menu )
            {
              if( loser.isEmpty() )
              {
                scene = game;
              }
              else
              {
                scene = game_over;
              }
            }
            else
            {
              scene = menu;
            }
          }
        }
      );
    }

    if( scene == game )
    {
      
      texter.draw( g );
      
      drawBoard( g, 0xff );
      
    }
    else if( scene == menu )
    {
      texter.at += 1;
      
      menu();
      
      texter.draw( g );
    }
    else if( scene == game_over )
    {
      
      texter.draw( g );
      
      drawBoard( g, 0x55 );
      
      texterGameOver.clear();
      
      texterGameOver.colorBack = 0;
      
      for( P loser : loser )
      {
        texterGameOver.colorText = loser.c;
        
        texterGameOver.add( loser + " loses"  );
      }
      
      g.textFont( textFont );
      
      texterGameOver.draw( g );
      
    }
    
    for( UIE uie : this.UIEs )
    {
      uie.draw( g );
    }
    
  }
  
  void boardClicked( final int hit, final int mouseButton )
  {
    if( mouseButton == RIGHT )
    {
      selected = -1;
      
      return;
    }
    
    if ( selected != -1 )
    {
      if ( bounds( hit, CS.w * CS.w ) )
      {
        for ( Unit.Move move : cachedMoves )
        {
          if ( move.tar == hit )
          {
            execute( move );
            selected = -1;
            return;
          }
        }
      }
    }
    if ( hit >= 0 && hit < CS.w * CS.w && tileVisible( hit ) )
    {
      selected = hit;

      Unit unit = field[ hit ];

      cachedMoves = this.movesG( selected );
    }
    else
    {
      selected = -1; 
    }
  }

  void mouseClicked( C mouse, int mouseButton  )
  {
    UIE uie = top( mouse, this.UIEs );
    
    if( uie != null )
    {
      uie.mouseClicked( mouse, mouseButton );
      return;
    }
    
    if( scene == game )
    {
    
      C loc = cam.loc( mouse ).sub( topNameBuffer ).sca( 1 / CS.tilesize );
      
      if( loc.y < 0 )
      {
        scene = menu;
        return;
      }
  
      int hit = field( loc );
  
      boardClicked( hit, mouseButton );
    }
    else if( scene == menu || scene == game_over )
    {
      
      texter.mouseClicked( mouse, mouseButton );
      
      if( mouseButton == RIGHT )
      {
        restart();
        
        scene = game;
      }
      
    }
  }

  void mouseDragged( C drag, C last, C mouse )
  {
    UIE uie = top( mouse, this.UIEs );
    
    if( uie != null )
    {
      uie.mouseDragged( drag, last, mouse );
      return;
    }
    
    cam.loc = cam.loc.add( drag );
  }

  void mouseWheel( float count )
  {
    
    UIE uie = top( mouse, this.UIEs );
    
    if( uie != null )
    {
      uie.mouseWheel( count );
      return;
    }
    
    cam.zoom *= 1 - count * spdZoom;
  }

  void keyPressed()
  {
    
    
    
  }
  
  C measures()
  {
    return size.sca( CS.tilesize ).add( topNameBuffer ).add( botNameBuffer );
  }


  Shape shape()
  {

    return new Shape.Rectangle( cam.loc, measures().sca( cam.zoom ) );
  }
  
  Cam cam()
  {
    return cam;
  }
  
}
