static class CS
{
 
  static int w = 8;
  
  static boolean locked = false;
  
  static float tilesize = 69f;
  
  // UI
  
  static float topNameBuffer = 60f;
  
  
  static Unit[] basic()
  {
    
    return new Unit[]{
      
      new Unit( P.Black, T.Rook ), new Unit( P.Black, T.Knight ), new Unit( P.Black, T.Bishop ), new Unit( P.Black, T.Queen ), new Unit( P.Black, T.King ), new Unit( P.Black, T.Bishop ), new Unit( P.Black, T.Knight ), new Unit( P.Black, T.Rook ),
      new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), new Unit( P.Black, T.Pawn ), 
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      null, null, null, null, null, null, null, null,
      new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ), new Unit( P.White, T.Pawn ),
      new Unit( P.White, T.Rook ), new Unit( P.White, T.Knight ), new Unit( P.White, T.Bishop ), new Unit( P.White, T.Queen ), new Unit( P.White, T.King ), new Unit( P.White, T.Bishop ), new Unit( P.White, T.Knight ), new Unit( P.White, T.Rook ), 
      
    };
  
  }
  
  static int v( final C move, final int w )
  {
    return (int)move.x + (int)move.y * w;
  }
  
  static C c( final int move, final int w )
  {
    return new C( move % w, move / w );
  }
  
  static boolean ok( final C location, final int move, final int w )
  {
    return ok( location, move, c( move, w ), w );
  }
  
  static boolean ok( final C location, final int move, final C intendedMove, final int w )
  {
    final int tar = v( location, w ) + move;
    
    final C CTar = new C( tar % w, tar / w );
    
    return CTar.sub( location ).equals( intendedMove );
  }
  
  
  static Map<Integer,Unit> unitsG( final Unit[] field, Filter<Unit> filter )
  {
    Map<Integer,Unit> r = new HashMap();
    
    for( int i = 0 ; i < field.length ; i += 1 )
    {
      Unit unit = field[ i ];
      
      if( filter.f( unit ) )
      {
        r.put( i, unit );
      }
    }
    
    return r;
  }
  
  static Map<Integer,Unit> unitsG( final Unit[] field, final P allegiance )
  {
    return unitsG(
      field,
      new Filter<Unit>()
      {
        public boolean f( Unit unit )
        {
          return unit != null && unit.player == allegiance;
        }
      }
    );
  }
  
  static Map<Integer,Unit> kingsG( final Unit[] field, final P allegiance )
  {
    return unitsG(
      field,
      new Filter<Unit>()
      {
        public boolean f( Unit unit )
        {
          return unit != null && unit.type == T.King && unit.player == allegiance;
        }
      }
    );
  }
  
  static boolean underAttack( final FiEx fi, int tar, final P allegiance )
  {
    final Unit[] field = fi.field();
    
    Map<Integer,Unit> enemies = unitsG
    (
      field,
      new Filter<Unit>()
      {
        public boolean f( Unit unit )
        {
          return unit != null && unit.player != allegiance;
        }
      }
    );
    
    for( Map.Entry<Integer,Unit> enemy : enemies.entrySet() )
    {
      List<Unit.Move> moves = movesG( fi, enemy.getKey(), false );
      
      for( Unit.Move move : moves )
      {
        if( move.tar == tar && move.parameter != null && move.parameter.dangerous() )
        {
          return true;
        }
      }
    }
    
    return false;
  }
  
  static List<Unit.Move> movesG( final FiEx fi, int location )
  {
    return movesG( fi, location, true );
  }
  
  static List<Unit.Move> movesG( final FiEx fi, final int location, final boolean recurse )
  {
    
    final Unit[] field = fi.field();
    
    final int iMove = fi.move();
    
    final int size = field.length;
    
    final int w = (int)fi.size().x;
    
    final C CLocation = c( location, w );
    
    final Unit unit = field[ location ];
    
    List<Unit.Move>rr = new ArrayList();
    
    switch( unit.type )
    {
      case Pawn:
      {
        final int dir = unit.player == P.White ? - w : w;
        final C CDir = unit.player == P.White ? new C( 0, -1 ) : new C( 0, 1 );
        
        int tar = location + dir;
        
        if( bounds( tar, size ) && ok( CLocation, dir, CDir, w ) && field[ tar ] == null )
        {
          rr.add( unit.new Move( location, tar, Unit.Note.PawnMove ) );
          
          tar = tar + dir;
          if( unit.moves == 0 && bounds( tar, size ) && ok( CLocation, dir * 2, CDir.sca( 2 ), w ) && field[ tar ] == null )
          {
            Unit.Move move = unit.new Move
            ( 
              location,
              tar, 
              new B()
              {
                public void b( Unit[] field )
                {
                  unit.iMoveDoublePawnMove = iMove;
                }
              }, 
              Unit.Note.DoublePawnMove
            );
            rr.add( move );
          }
        }
        
        for( C CDi : new C[]{ CDir.add( new C( 1, 0 ) ), CDir.add( new C( - 1, 0 ) ), } )
        {
          final int di = v( CDi, w );
          
          tar = location + di;
          
          if( bounds( tar, size ) && ok( CLocation, di, CDi, w ) )
          {
            Unit u = field[ tar ];
            
            if( u != null && u.player != unit.player )
            {
              rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
            }
          }
        }
        
        for( final C CShouldbeon : new C[]{ CLocation.add( new C( 1, 0 ) ), CLocation.add( new C( - 1, 0 ) ), } )
        {
          final int shouldbeon = v( CShouldbeon, w );
          
          Unit victim;
          
          if( bounds( shouldbeon, size ) && ok( CLocation, shouldbeon - location, CShouldbeon.sub( CLocation ), w ) && ( victim = field[ shouldbeon ] ) != null && victim.player != unit.player && victim.type == T.Pawn && victim.iMoveDoublePawnMove == iMove - 1 )
          {
            rr.add(
              unit.new Move(
                location, 
                shouldbeon,
                new B()
                {
                  public void b( Unit[] field )
                  {
                    field[ shouldbeon ] = null;
                    field[ shouldbeon + dir ] = unit;
                  }
                },
                Unit.Note.EnPassant
              ) 
            );
          }
        }
        break;
      }
      
      case Knight:
      {
        C[] CMoves = new C[]{ new C( 2, 1 ), new C( 2, - 1 ), new C( - 2, 1 ), new C( - 2, - 1 ), new C( 1, 2 ), new C( - 1, 2 ), new C( 1, - 2 ), new C( - 1, - 2 ), };
        int tar;
        
        for( C CMove : CMoves )
        {
          final int move = v( CMove, w );
          
          tar = location + move;
          
          if( bounds( tar, size ) && ok( CLocation, move, CMove, w ) )
          {
            Unit u = field[ tar ];
            
            if( u == null )
            {
              rr.add( unit.new Move( location, tar ) );
            }
            else if( u.player != unit.player )
            {
              rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
            }
          }
        }
        break;
      }
      
      case Bishop:
      {
        C[] CDirs = new C[]{ new C( 1, 1 ), new C( 1, - 1 ), new C( - 1, 1 ), new C( - 1, - 1 ), };
        
        int tar, move;
        Unit u;
        
        for( C CDir : CDirs )
        {
          final int dir = v( CDir, w );
          
          int sca = 1;
          
          while( bounds( tar = location + ( move = dir * sca ), size ) && ok( CLocation, move, CDir.sca( sca ), w ) )
          {
            if( ( u = field[ tar ] ) == null)
            {
              rr.add( unit.new Move( location, tar ) );
            }
            else
            {
              if( u.player != unit.player )
              {
                rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
              }
              break;
            }
            
            sca += 1;
          }
        }
        break;
      }
      
      case Rook:
      {
        C[] CDirs = new C[] { new C( 1, 0 ), new C( - 1, 0 ), new C( 0, 1 ), new C( 0, - 1 ), };
        int tar, move;
        Unit u;
        
        for( C CDir : CDirs )
        {
          final int dir = v( CDir, w );
          
          int sca=1;
          
          while( bounds( tar = location + ( move = dir * sca ), size ) && ok( CLocation, move, CDir.sca( sca ), w ) )
          {
            if( ( u = field[ tar ] ) == null )
            {
              rr.add( unit.new Move( location, tar ) );
            }
            else
            {
              if( u.player != unit.player )
              {
                rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
              }
              break;
            }
            
            sca += 1;
          }
        }
        break;
      }
      
      case Queen:
      {
        C[] CDirs = new C[] { new C( 1, 1 ), new C( 1, - 1 ), new C( - 1, 1 ), new C( - 1, - 1 ), new C( 1, 0 ), new C( - 1, 0 ), new C( 0, 1 ), new C( 0, - 1 ), };
        int tar, move;
        Unit u;
        
        for( C CDir : CDirs )
        {
          final int dir = v( CDir, w );
          
          int sca = 1;
          
          while( bounds( tar = location + ( move = dir * sca ), size ) && ok( CLocation, move, CDir.sca( sca ), w ) )
          {
            if( ( u = field[ tar ] ) == null )
            {
              rr.add( unit.new Move( location, tar ) );
            }
            else
            {
              if( u.player != unit.player )
              {
                rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
              }
              break;
            }
            
            sca += 1;
          }
        }
        break;
      }
      
      case King:
      {
        C[] CMoves = new C[] { new C( 1, 1 ), new C( 1, - 1 ), new C( - 1, 1 ), new C( - 1, - 1 ), new C( 1, 0 ), new C( - 1, 0 ), new C( 0, 1 ), new C( 0, - 1 ), };
        int tar;
        
        for( C CMove : CMoves )
        {
          final int move = v( CMove, w );
          
          tar = location + move;
          
          if( bounds( tar, size ) && ok( CLocation, move, CMove, w ) )
          {
            Unit u = field[ tar ];
            
            if( u == null )
            {
              rr.add( unit.new Move( location, tar ) );
            }
            else if( u.player != unit.player )
            {
              rr.add( unit.new Move( location, tar, u.type == T.King ? Unit.Note.KingSlayer : Unit.Note.KillingBlow ) );
            }
          }
        }
        
        if( fi.castling() && recurse )
        {
          if( unit.moves == 0 && ! underAttack( fi, location, unit.player ) )
          {
            final int y = location / w * w;
            
            rookIter:
              for( final int pos : new int[]{ y, y + w - 1, } )
              {
                Unit u = field[ pos ];
                
                if( u != null && u.type == T.Rook && u.moves == 0 )
                {
                  final int dir = location > pos ? -1 : 1;
                  
                  for( int i = location + dir ; i != pos ; i += dir)
                  {
                    if( field[ i ] != null )
                    {
                      continue rookIter;
                    }
                  }
                  
                  if( ! underAttack( fi, location + dir, unit.player ) )
                  {
                    rr.add
                    (
                      unit.new Move
                      (
                        location, 
                        location + 2 * dir,
                        new B()
                        {
                          public void b( Unit[] field )
                          {
                            Unit rook = field[ pos ];
                            field[ pos ] = null;
                            field[ location + dir ] = rook;
                          }
                        },
                        Unit.Note.Castling
                      )
                    );
                  }
                  
                }
            }
          }
        }
        
        break;
      }
      
    }
    
    return rr;
    
  }
  
  static boolean legal( final FiEx fi, final Unit.Move move )
  {
    
    final C fisize = fi.size();
    
    final Unit[] fifield = fi.field();
    
    final int iMove = fi.move();
    
    final int size = fifield.length;
    
    final Unit[] field = new Unit[ size ];
    
    System.arraycopy( fifield, 0, field, 0, size );
    
    final Unit unit = field[ move.org ];
    
    final P allegiance = unit.player;
    
    move.execute( field );
    
    final Map<Integer,Unit> kings = kingsG( field, allegiance );
    
    final FiEx fiemu = new FiEx()
    {
      public int move(){ return iMove + 1; }
      public C size(){ return fisize; }
      public Unit[] field(){ return field; }
      public List<Unit.Move> movesG( int location ){ return CS.movesG( this, location ); }
      public boolean execute( Unit.Move move ){ return move.execute( field ); }
      public boolean castling(){ return fi.castling(); }
    };
    
    boolean r = true;
    
    for( int locKing : kings.keySet() )
    {
      if(
        underAttack(
          fiemu,
          locKing,
          unit.player
        )
      )
      {
        r = false;
        break;
      }
    }
    
    move.revert();
    
    return r;
  }
  
  static boolean mate( final FiEx fi, final int locKing )
  {
    final Unit[] field = fi.field();
    
    final Unit king = field[ locKing ];
    
    final P allegiance = king.player;
    
    final Map<Integer,Unit> mine = unitsG
    (
      field,
      new Filter<Unit>()
      {
        public boolean f( Unit unit )
        {
          return unit != null && unit.player == allegiance;
        }
      }
    );
    
    final List<Unit.Move> moves = new ArrayList();
    
    for( int loc : mine.keySet() )
    {
      moves.addAll( movesG( fi, loc ) );
    }
    
    for( Unit.Move move : moves )
    {
      if( legal( fi, move ) )
      {
        return false;
      }
    }
    
    return true;
  }
  
}
