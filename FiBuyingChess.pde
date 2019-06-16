static class FiBuyingChess extends Standard
{
  
  Box topBoxBuy, botBoxBuy;
  
  Map<P,List<Unit>> currency;
  
  int[][] selectedCurrency;
  
  List<T> buyables;
  
  int selectedBuy;
  
  FiBuyingChess()
  {
    super();
    
    super.name = "Buying Chess";
    
    this.colour = 0xc1baa8ff;
    
    this.currency = new HashMap();
    
    for( P player : players )
    {
      currency.put( player, new ArrayList() );
    }
    
    this.selectedCurrency = new int[ P.cP ][ T.cT ];
    
    this.buyables = this.buyables( turn );
    
    this.selectedBuy = 0;
    
    
    final float buyBoxSize = CS.topNameBuffer;
    
    this.topBoxBuy = Box.BoxLinesSeg( cam, new C( topNameBuffer.x, topNameBuffer.y ), new C( size.x * CS.tilesize, buyBoxSize ), 1, segThonking );
    
    this.botBoxBuy = Box.BoxLinesSeg( cam, topNameBuffer.add( new C( 0, size.y * CS.tilesize + topBoxBuy.ar.y ) ), new C( size.x * CS.tilesize, buyBoxSize ), 1, segThonking );
    
    
    this.botBoxThonking.lt = this.botBoxThonking.lt.add( new C( 0, topBoxBuy.ar.y + botBoxBuy.ar.y ) );
    
    
    
    topNameBuffer.y += topBoxBuy.ar.y;
    
    botNameBuffer.y += botBoxBuy.ar.y;
    
    
  }
  
  List<T> buyables( P player )
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
    
    for( List<Unit> us : currency.values() )
    {
      for( Unit u : us )
      {
        if( u.player == player )
        {
          cs[ u.type.ordinal() ] += 1;
        }
      }
    }
    
    List<T> r = new ArrayList();
    
    for( int i = 0 ; i < T.cT ; i += 1 )
    {
      final T t = T.values[ i ];
      
      if( cs[ i ] < t.count )
      {
        r.add( t );
      }
    }
    
    return r;
  }
  
  int[] cBuyables( P player )
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
    
    for( List<Unit> us : currency.values() )
    {
      for( Unit u : us )
      {
        if( u.player == player )
        {
          cs[ u.type.ordinal() ] += 1;
        }
      }
    }
    
    int[] r = new int[ T.cT ];
    
    for( int i = 0 ; i < T.cT ; i += 1 )
    {
      final T t = T.values[ i ];
      
      if( cs[ i ] < t.count )
      {
        r[ i ] = t.count - cs[ i ];
      }
    }
    
    return r;
  }
  
  Unit[] starting()
  {
    
    return new Unit[]{
      
      null, new Unit( P.Black, T.Knight ), new Unit( P.Black, T.Bishop ), null, new Unit( P.Black, T.King ), new Unit( P.Black, T.Bishop ), new Unit( P.Black, T.Knight ), null,
      new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), 
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ),
      null, new Unit( P.White, T.Knight ), new Unit( P.White, T.Bishop ), null, new Unit( P.White, T.King ), new Unit( P.White, T.Bishop ), new Unit( P.White, T.Knight ), null, 
      
    };
  
  }
  
  void cache()
  {
    this.selectedCurrency = new int[ P.cP ][ T.cT ];
    
    this.buyables = this.buyables( turn );
    
    selectedBuy = 0;
  }
  
  boolean execute( Unit.Move move )
  {
    final P mover = turn;
    
    final boolean r = super.execute( move );
    
    if( move.slain != null )
    {
      currency.get( mover ).add( move.slain );
    }
    
    cache();
    
    return r;
  }
  
  void restart()
  {
    super.restart();
    
    this.currency = new HashMap();
    
    for( P player : players )
    {
      currency.put( player, new ArrayList() );
    }
    
    this.selectedCurrency = new int[ P.cP ][ T.cT ];
    
    this.buyables = this.buyables( turn );
    
    selectedBuy = 0;
  }
  
  void drawBoard( PGraphics g, int ALPHASCALE )
  {
    
    super.drawBoard( g, ALPHASCALE );
    
    g.textFont( chessFont );
    
    super.UIEs.clear();
    
    for( final P player : players )
    {
      Box referenceBox = null;
    
      if( player == P.Black && ! rotatingBoard )
      {
        referenceBox = topBoxBuy;
      }
      else if( turn != null )
      {
        referenceBox = botBoxBuy;
      }
      
      if( referenceBox != null )
      {
        
        final List<Unit> currency = this.currency.get( player );
        
        final int[][] cs = new int[ P.cP ][ T.cT ];
        
        for( Unit unit : currency )
        {
          cs[ unit.player.ordinal() ][ unit.type.ordinal() ] += 1;
        }
        
        int i = -1;
        for( int iP = 0 ; iP < P.cP ; iP += 1 )
        for( int iT = 0 ; iT < T.cT ; iT += 1 )
        {
          if( cs[ iP ][ iT ] <= 0 )
          {
            continue;
          }
          
          i += 1;
          
          final int iiP = iP, iiT = iT;
          
          final T t = T.values[ iT ];
          
          final Box box = Box.BoxLinesSeg( cam, referenceBox.lt.add( new C( referenceBox.ar.y * i, 0 ) ), new C( referenceBox.ar.y, referenceBox.ar.y ), 1, 0 );
          
          box.add
          ( 
            new Information()
            {
              final Box.Field field = new Box.Field()
              {
                public void draw( PGraphics g, float zoom, float ltx, float lty, float arx, float ary )
                {
                  super.draw( g, zoom, ltx, lty, arx, ary );
                  
                  g.textFont( textFont );
                  fill( g, RGBBLACK );
                  
                  final float ts = arx * .25;
                  
                  g.textSize( ts );
                  
                  println( g.textSize, ts );
                  
                  if( player == turn )
                  {
                    final int count = selectedCurrency[ iiP ][ iiT ];
                    
                    g.text( count, ltx, lty + ts );
                  }
                  
                  final int c = cs[ iiP ][ iiT ];
                  
                  g.text( c, ltx + arx - g.textWidth( c + "" ), lty + ts );
                }
              };
                
              {
                field.s = new String[]{ P.values[ iiP ].unitChar( t ) + "" };
                
                field.font = chessFont;
              }
              public Object get()
              {
                return field;
              }
            },
            new Runnable()
            {
              public void run()
              {
                if( player == turn )
                {
                  selectedCurrency[ iiP ][ iiT ] += 1;
                  
                  if( selectedCurrency[ iiP ][ iiT ] > cs[ iiP ][ iiT ] )
                  {
                    selectedCurrency[ iiP ][ iiT ] = 0;
                  }
                }
              }
            }
          );
          
          super.UIEs.add( box );
        }
        
        
        if( player == turn && ! buyables.isEmpty() )
        {
          i += 1;
        
          Box box;
        
          int buyingPower = 0;
          
          for( int[] a : selectedCurrency )
          {
            for( int j = 0 ; j < T.cT ; j += 1 )
            {
              if( a[ j ] > 0 )
              {
                buyingPower += T.values[ j ].valuationStandard * a[ j ];
              }
            }
          }
          
          box = Box.BoxLinesSeg( cam, referenceBox.lt.add( new C( referenceBox.ar.y * i, 0 ) ), new C( referenceBox.ar.y, referenceBox.ar.y ), 1, 0 );
          
          box.fontText = textFont;
          
          box.add
          (
            buyingPower + ""
          );
          
          super.UIEs.add( box );
          
          
          
        }
        
        final int[] cbs = cBuyables( player );
        
        {
          Box box;
          
          for( int size = buyables.size(), j = 0; j < size ; j += 1 )
          {
            final int jj = j;
            final T t = buyables.get( j );
            
            box = Box.BoxLinesSeg( cam, referenceBox.lt.add( new C( referenceBox.ar.x + ( - size + j ) * referenceBox.ar.y, 0 ) ), new C( referenceBox.ar.y, referenceBox.ar.y ), 1, 0 );
            
            box.add
            ( 
              new Information()
              {
                final Box.Field field = new Box.Field()
                {
                  public void draw( PGraphics g, float zoom, float ltx, float lty, float arx, float ary )
                  {
                    super.draw( g, zoom, ltx, lty, arx, ary );
                    
                    g.textFont( textFont );
                    fill( g, RGBBLACK );
                    
                    final float ts = arx * .25;
                    
                    g.textSize ( ts );
                    
                    g.text( t.valuationStandard, ltx + arx - g.textWidth( t.valuationStandard + "" ), lty + ary );
                    
                    final int c = cbs[ t.ordinal() ];
                  
                    g.text( c, ltx + arx - g.textWidth( c + "" ), lty + ts );
                  }
                };
                  
                {
                  field.colorTextBack = ALPHASET( RGBA( RGBRED ), player == turn && jj == selectedBuy ? 0xaa : 55 );
                  
                  field.s = new String[]{ player.unitChar( t ) + "" };
                  
                  field.font = chessFont;
                }
                public Object get()
                {
                  return field;
                }
              },
              new Runnable()
              {
                public void run()
                {
                  if( player == turn )
                  {
                    if( selectedBuy == jj )
                    {
                      selectedBuy = 0;
                    }
                    else
                    {
                      selectedBuy = jj;
                    }
                  }
                }
              }
            );
            
            super.UIEs.add( box );
          }
        }
        
      }
    }
    
  }
  
  void boardClicked( int location, int mouseButton )
  {
    
    if( mouseButton == RIGHT )
    {
      selected = -1;
      
      return;
    }
    
    if ( location >= 0 && location < CS.w * CS.w && tileVisible( location ) )
    {
      if( selected != -1 )
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
          selected = -1;
        }
      }
      
      if( selected == -1 )
      {
        if( field[ location ] == null )
        {
          int buyingPower = 0;
          
          for( int[] a : selectedCurrency )
          {
            for( int i = 0 ; i < T.cT ; i += 1 )
            {
              if( a[ i ] > 0 )
              {
                buyingPower += T.values[ i ].valuationStandard * a[ i ];
              }
            }
          }
          
          final T buy = buyables.get( selectedBuy );
          
          if( buyingPower >= buy.valuationStandard )
          {
            field[ location ] = new Unit( turn, buyables.get( selectedBuy ) );
          
            for( int iP = 0 ; iP < P.cP ; iP += 1 )
            for( int iT = 0 ; iT < T.cT ; iT += 1 )
            { 
              final int count = selectedCurrency[ iP ][ iT ];
              
              if( count > 0 )
              {
                final List<Unit> currency = this.currency.get( turn );
                
                for( int i = 0, rem = 0; i < currency.size() && rem < count ; i += 1 )
                {
                  final Unit unit = currency.get( i );
                  if( unit.player == P.values[ iP ] && unit.type == T.values[ iT ] )
                  {
                    currency.remove( i -- );
                    rem += 1;
                  }
                }
              }
            }
            
            this.turnNext();
            this.cache();
          }
        }
        else
        {
          selected = location;
        
          cachedMoves = movesG( location );
        }
      }

    }
    
  }
  
}
