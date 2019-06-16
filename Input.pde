void keyPressed()
{
  
  switch( keyCode )
  {
    case 27:
      
      
      
    break;
    
    case 76:
      
      CS.locked = ! CS.locked;
      
    break;
  }
  
  if(key == 27)
  {
    key = 0;
  }
}



static C mouse;

void mouseClicked()
{
  mouse = new C( mouseX, mouseY );
  
  focus( mouse );
  
  for( UIE uie : UIEs )
  {
    
    if( mouse.collides( uie.shape() ) )
    {
      uie.mouseClicked( mouse, LEFT );
      return;
    }
    
  }
}


static C last;
static boolean checkStart;
static UIE dragged;
void mouseDragged()
{
  mouse = new C( mouseX, mouseY );
  
  
  if( last == null )
  {
    last = mouse;
    checkStart = true;
  }
  else
  {
    if( checkStart )
    {
      dragged = focus( mouse );
      checkStart = false;
    }
    if( dragged == null )
    {
      for( UIE uie : UIEs )
      {
        Cam cam = uie.cam();
        cam.loc = cam.loc.sub( mouse.sub( last ) );
      }
    }
    else
    {
      dragged.mouseDragged( mouse.sub( last ), last, last );
    }
    last = mouse;
  }
}
void mouseReleased()
{
  last = null;
}


void mouseWheel( float count )
{
  
  for( UIE uie : UIEs )
  {
    if( mouse.collides( uie.shape() ) )
    {
      uie.mouseWheel( count );
      return;
    }
  }
}
