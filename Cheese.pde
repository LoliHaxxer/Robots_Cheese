import java.util.*;

import processing.event.TouchEvent.Pointer;


static PGraphics g;


static PFont chessFont, textFont;



  
void setup()
{
  
  
  g = getGraphics();
  
  if( setupDoneOnce )
  {
    return;
  }
  
  orientation(LANDSCAPE);
  size( 2200, 1100 );
  
  wh();
  
  textFont=createFont( "ProcessingSansPro-Regular.ttf", 1 );
  chessFont=createFont( "CASEFONT.TTF", 1 );
  
  
  UIEs.add( new MainMenu() );
  
  fi();
  
  setupDoneOnce = true;
}

void draw()
{
  
  g.noStroke();
  filla( g, 0xffffffff );
  g.rect( 0, 0, width, height );
  
  for( int i = UIEs.size() - 1 ; i >= 0 ; i -= 1 )
  {
    UIEs.get( i ).draw( g );
  }
  
}
