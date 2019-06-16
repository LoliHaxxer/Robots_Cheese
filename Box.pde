static class Box implements UIE
{
  
  static class Field implements Information<Field>
  {
    String[] s;
    
    Integer colorTextBack;
    
    Integer colorText;
    
    PFont font;
    
    Field(  )
    {
      colorText = RGBA( RGBBLACK );
    }
    
    Field get()
    {
      return this;
    }
    
    void draw( PGraphics g, float zoom, float ltx, float lty, float arx, float ary )
    {
      if( colorTextBack != null )
      {
        filla( g, colorTextBack );
      }
      
      g.rect( ltx, lty, arx, ary );
    }
    
  }
  
  Cam cam;
  
  C lt, ar;
  float seg;
  int lines;
  
  float ts;
  
  int at;
  Map<Integer,Information<Field>> fields;
  
  Map<Integer, Runnable> clickTriggers = new HashMap();
  
  PFont fontText;
  
  int colorText = 0x000000ff;
  
  int colorTextBack = 0x00000000;
  
  int colorBack = 0xffffffff;
  
  
  Box( Cam cam, C lt, C ar )
  {
    this.cam = cam;
    
    this.lt = lt;
    this.ar = ar;
    
    this.fields = new HashMap();
  }
  
  static Box BoxLinesSeg( Cam cam, C lt, C ar, int lines, float seg )
  {
    Box box = new Box( cam, lt, ar );
    
    box.lines = lines;
    box.seg = seg;
    
    box.compute();
    
    return box;
  }
  
  // seg as percentage
  
  static Box BoxSap( Cam cam, C lt, C ar, int lines, float sap )
  {
    return BoxLinesSeg( cam, lt, ar, lines, ar.y / lines * sap );
  }
  
  static Box BoxSegTs( Cam cam, C lt, C ar, float seg, float ts)
  {
    Box box = new Box( cam, lt, ar );
    
    box.seg = seg;
    
    box.tsS( ts );
    
    return box;
  }
  
  void add( String s )
  {
    add( at ++, s );
  }
  
  void add( String s, Runnable r )
  {
    add( at, s );
    add( at ++, r );
  }
  
  void add( String[] s, Runnable r )
  {
    add( at, s );
    add( at ++, r );
  }
  
  void add( Information info )
  {
    add( at ++, info );
  }
  
  void add( Information info, Runnable r )
  {
    add( at, info );
    add( at ++, r );
  }
  
  void add( Field field )
  {
    fields.put( at ++ , field );
  }
  
  void add( int i, String... s )
  {    
    if( i >= lines )
    {
      linesS( i + 1 );
    }
    
    if( fields.get( i ) == null )
    {
      fields.put( i, new Field() );
    }
    
    Field field = fields.get( i ).get();
    
    field.s = s;
    
    if( ( colorTextBack & 0xff ) != 0 )
    {
      field.colorTextBack = colorTextBack;
    }
    
    field.colorText = colorText;
    
    field.font = fontText;
    
  }
  
  void add( int i, Information info )
  {
    if( i >= lines )
    {
      linesS( i + 1 );
    }
    
    fields.put( i, info );
  }
  
  void add( int i, Field field )
  {
    fields.put( i, field );
  }
  
  void add( int i, Runnable run )
  {
    clickTriggers.put( i, run );
  }
  
  void clear()
  {
    fields.clear();
    clickTriggers.clear();
    
    this.at = 0;
  }
  
  //void setup()
  //{
  //  for( Map.Entry<Integer,Runnable> run : runs.entrySet() )
  //  {
  //    clickTriggers.put( run.getValue(), shapeOfLine( run.getKey() ) );
  //  }
  //}
  
  ////NPE
  //void stop()
  //{
  //  for( Map.Entry<Integer,Runnable> run : runs.entrySet() )
  //  {
  //    clickTriggers.remove( run.getValue() );
  //  }
  //}
  
  void draw( PGraphics g )
  {
    
    g.noStroke();
    filla( g, colorBack );
    
    g.rect( cam.loc.x + lt.x * cam.zoom, cam.loc.y + lt.y * cam.zoom, ar.x * cam.zoom, ar.y * cam.zoom );
    
    
    Map<Integer,Field> fields = new HashMap();
    
    for( Map.Entry<Integer,Information<Field>> field : this.fields.entrySet() )
    {
      fields.put( field.getKey(), field.getValue().get() );
    }
    
    for( Map.Entry<Integer,Field> field : fields.entrySet() )
    { 
      int line = field.getKey();
      
      colorTextBack( g, line, field.getValue() );
    }
    
    for( Map.Entry<Integer,Field> entryField : fields.entrySet() )
    {
      int line = entryField.getKey();
      
      Field field = entryField.getValue();
      
      if( field.s == null )
      {
        continue;
      }
      
      text( g, line, field.s, field.colorText, field.font );
    }
  }
  
  void colorTextBack( PGraphics g, int line, Field field )
  {
    float yLineStart = cam.loc.y + ( lt.y + ts * line + seg( line ) ) * cam.zoom;
    
    
    field.draw( g, cam.zoom, cam.loc.x + lt.x * cam.zoom, yLineStart, ar.x * cam.zoom, ts * cam.zoom );
    
  }
  
  void text( PGraphics g, int line, String[] strings, int colorText, PFont font )
  {
    if( font != null )
    {
      g.textFont( font );
    }
    
    final int linesIntern = strings.length;
    final float tsIntern = ts / linesIntern;
    
    g.textSize( tsIntern * cam.zoom );
    
    float yLineStart = cam.loc.y + ( lt.y + ts * line + seg( line ) ) * cam.zoom;
    
    
    filla( g, colorText );
    
    float xCenter = cam.loc.x + ( lt.x + ar.x * .5 ) * cam.zoom;
    
    for( int i = 0 ; i < linesIntern ; i += 1 )
    {
      String string = strings[ i ];
    
      float wText = g.textWidth( string );
    
      g.text( string, xCenter - wText / 2, yLineStart + tsIntern * ( i + 1 ) * cam.zoom );
    }
    
  }
  
  Shape shapeOfLine( int line )
  {
    return new Shape.Rectangle( new C( cam.loc.x + lt.x * cam.zoom, cam.loc.y + ( lt.y + ts * line + seg( line ) ) * cam.zoom ), new C( ar.x * cam.zoom, ts * cam.zoom ) );
  }
  
  float seg( int line )
  {
    return ( line + .5 ) * seg;
  }
  
  void linesS( int v )
  {
    this.lines = v;
    compute();
  }
  
  void segS( float v )
  {
    this.seg = v;
    compute();
  }
  
  void tsS( float v )
  {
    lines = (int)( ar.y / v - seg );
    this.ts = v;
  }
  
  void compute()
  {
    this.ts = ( ar.y - lines * seg ) / lines;
  }
  
  void mouseClicked( C mouse, int mouseButton )
  {
    for( Map.Entry<Integer, Runnable> e : clickTriggers.entrySet() )
    {
      Shape shape = shapeOfLine( e.getKey( ) );
      Runnable run = e.getValue();
      
      //println( mouse, Arrays.toString( ((Shape.Rectangle)shape).point ),mouse.collides(shape));
      
      if( mouse.collides( shape ) )
      {
        run.run();
        break;
      }
    }
  }
  
  void mouseDragged( C drag, C last, C mouse )
  {
    cam.loc = cam.loc.add( drag );
  }
  
  void mouseWheel( float count )
  {
    cam.zoom *= 1 - count * spdZoom;
  }
  
  void keyPressed()
  {}
  
  Shape shape()
  {
    return new Shape.Rectangle( cam.px( lt ), ar.sca( cam.zoom ) );
  }
  
  Cam cam()
  {
    return cam;
  }
  
}
