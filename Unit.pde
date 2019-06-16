static interface B
{
  public void b( Unit[] field );
}



static class Unit
{
    
  static enum Note
  {
    DefaultMove( false )
    {
      boolean dangerous()
      {
        return true;
      }
    },
    
    PawnMove( false )
    {
      boolean dangerous()
      {
        return false;
      }
    },
    
    DoublePawnMove( false )
    {
      boolean dangerous()
      {
        return false;
      }
    },
    
    Castling( false )
    {
      boolean dangerous()
      {
        return false;
      }
    },
    
    EnPassant( true )
    {
      boolean dangerous()
      {
        return false;
      }
    },
    
    KillingBlow( true )
    {
      boolean dangerous()
      {
        return true;
      }
    },
    
    KingSlayer( true )
    {
      boolean dangerous()
      {
        return true;
      }
    },
    
    ;
    
    final boolean slaying;
    
    private Note( final boolean slaying )
    {
      this.slaying = slaying;
    }
    
    abstract boolean dangerous();
    
  }
  
  class Move
  {
    
    int org;
    
    int tar;
    
    B more;
    
    final Note parameter;
    
    Unit slain;
    
    Move( int org, int tar )
    {
      this(
        org,
        tar,
        Note.DefaultMove
      );
    }
    
    Move( int org, int tar, Note parameter )
    {
      this( org, tar, null, parameter );
    }
    
    Move( int org, int tar, B more, Note parameter)
    {
      this.org = org;
      this.tar = tar;
      this.more = more;
      this.parameter = parameter;
      
    }
    
    boolean execute( final Unit[] field )
    {
      moves += 1;
      
      Unit unit = field[ org ];
    
      if ( unit != null )
      {
        if( parameter.slaying )
        {
          slain = field[ tar ];
        }
        
        field[ org ] = null;
        field[ tar ] = unit;
  
        if ( more != null )
        {
          more.b( field );
        }
  
        return true;
      }
  
      return false;
    }
    
    void revert()
    {
      moves -= 1;
      
      if( parameter == Note.DoublePawnMove )
      {
        iMoveDoublePawnMove = -1;
      }
      
      slain = null;
    }
    
    Unit unit()
    {
      return Unit.this;
    }
  }
  
  P player;
  
  T type;
  
  int moves;
  
  int iMoveDoublePawnMove = -1;
  
  Unit( P player, T type )
  {
    this.player = player;
    
    this.type = type;
  }
  
  static int[] count( List<Unit> units, Filter<Unit> filter )
  {
    int[] r = new int[ T.cT ];
    
    for( Unit unit : units )
    {
      if( filter.f( unit ) )
      {
        r[ unit.type.ordinal() ] += 1;
      }
    }
    
    return r;
  }

}

  static enum T{
    
    Pawn( 1, 8 ),
    
    Knight( 3, 2 ),
    
    Bishop( 3, 2 ),
    
    Rook( 5, 2 ),
    
    Queen( 9, 1 ),
    
    King( 13, 1 ),
    
    ;
    
    final int valuationStandard, count;
    
    private T( final int valuationStandard, final int count )
    {
      this.valuationStandard = valuationStandard;
      this.count = count;
    }
    
    static final T[] values = values();
    static final int cT = values.length;
    
  }
  
  static enum P
  {
    
    White( RGBA( RGBBLACK ), RGBA( RGBWHITE ) )
    {
      char unitChar( T type )
      {
        switch( type )
        {
          case Pawn:
            return 'p';
          
          case Knight:
            return 'n';
          
          case Bishop:
            return 'b';
          
          case Rook:
            return 'r';
          
          case Queen:
            return 'q';
          
          case King:
            return 'k';
        }
        throw new RuntimeException();
      }
      
    },
    
    Black( RGBA( RGBBLACK ), RGBA( RGBBLACK ) )
    {
      char unitChar( T type )
      {
        switch( type )
        {
          case Pawn:
            return 'o';
          
          case Knight:
            return 'm';
          
          case Bishop:
            return 'v';
          
          case Rook:
            return 't';
          
          case Queen:
            return 'w';
          
          case King:
            return 'l';
        }
        throw new RuntimeException();
      }
    },
    
    ;
    
    static final P[] values = values();
    static final int cP = values.length;
    
    //color for unit writing
    int c;
    
    //true colors xd
    int cTrue;
    
    private P( int c, int cTrue )
    {
      this.c = c;
      
      this.cTrue = cTrue;
    }
    
    abstract char unitChar( T type );
    
  }
