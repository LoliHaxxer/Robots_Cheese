
static interface UIE
{
  
  void draw( PGraphics g );
  
  void mouseClicked( C mouse, int mouseButton );
  
  void mouseDragged( C drag, C last, C mouse );
  
  void mouseWheel( float count );
  
  void keyPressed();
  
  Cam cam();
  
  Shape shape();
  
}



static List<UIE> UIEs = new ArrayList();


static void draw( PGraphics g, List<UIE> UIEs )
{
  for( int i = UIEs.size() - 1 ; i >= 0 ; i -= 1 )
  {
    UIEs.get( i ).draw( g );
  }
}

static UIE top( C c )
{
  return top( c, UIEs );
}

static UIE top( C c, Collection<UIE> UIEs )
{
  for ( UIE UIE : UIEs )
  {
    if( c.collides( UIE.shape() ) )
    {
      return UIE;
    }
  }
  return null;
}


static UIE focus( C c )
{
  return focus( c, UIEs );
}

static UIE focus( C c, List<UIE> UIEs )
{
  UIE uie = top( c, UIEs );
  
  if( uie != null )
  {
    UIEs.remove( uie );
    UIEs.add( 0, uie );
  }
  
  return uie;
}
