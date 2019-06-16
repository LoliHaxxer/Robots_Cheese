static class MainMenu implements UIE
{

  Box content;
  
  MainMenu()
  {
    this.content = Box.BoxLinesSeg( new Cam(), C.ZERO, new C( 500, 380 ), 8, 3 );
    
    this.content.colorBack = RGBA( RGBWHITE );
    
  }

  void draw( PGraphics g )
  {
    
    
    stroke( g, 0x000000 );
    g.strokeWeight( cam().zoom );
    g.noFill();
    shape().draw( g );
    
    content.clear();
    
    content.colorTextBack = RGBA( RGBWHITE );
    content.add( "Main Menu" );
    
    for( int i = 0 ; i < cField ; i += 1 )
    {
      final Fi fi = fields[ i ];
      
      final boolean engaged = UIEs.contains( fi );
      
      content.colorTextBack = ( fi.colour() >> 8 << 8 ) + ( engaged ? 0xff : 0x59 );
      
      final int k = i;
      content.add
      (
        fi.name(),
        new Runnable()
        {
        
              public void run()
          {
            if( engaged )
            {
              disengage( k );
            }
            else
            {
              engage( k );
            }
          }
        }
      );
    }
    
    g.textFont( textFont );
    
    content.draw( g );
  }
  
  void mouseClicked( C mouse, int mouseButton )
  {
    content.mouseClicked( mouse, mouseButton );
  }
  
  void mouseDragged( C drag, C last, C mouse )
  {
    content.mouseDragged( drag, last, mouse );
  }
  
  void mouseWheel( float count )
  {
    content.mouseWheel( count );
  }
  
  void keyPressed()
  {
    content.keyPressed();
  }
  
  Shape shape()
  {
    return content.shape();
  }
  
  Cam cam()
  {
    return content.cam();
  }

}
