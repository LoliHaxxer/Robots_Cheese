


abstract static class Shape //implements DU
{
  
  static class Circle extends Shape{
    
    C center;
    float radius;
    
    Circle(C center, float radius){
      this.center = center;
      this.radius = radius;
    }
    
    boolean collides( Shape other )
    {
      if(other instanceof Circle){
        
        return collides( (Circle)other, this );
        
      }else{
        throw new RuntimeException();
      }
    }
    
    void draw( PGraphics g )
    {
      g.ellipse( center.x, center.y, radius, radius );
    }
    
    String toString(){
      return "center "+center+", radius "+radius;
    }
    
  }
  
  static class Line extends Shape 
  {
    
    C a, b;
    
    Line( C a, C b )
    {
      this.a = a;
      this.b = b;
    }
    
    boolean collides( Shape other )
    {
      if( other instanceof Line )
      {
        
        return collides( (Line)other, this );
        
      }
      else if( other instanceof Circle )
      {
        
        return collides( (Circle)other, this );
        
      }
      else
      {
        throw new RuntimeException();
      }
    }
    
    float len()
    {
      C ab = b.sub( a );
      
      return ab.len();
    }
    
    float rotation()
    {
      C ab = b.sub( a );
      
      return ab.rot();
    }
    
    String toString()
    {
      return "P1( "+a+" ), P2( "+b+" )";
    }
    
  }
    
  static class Rectangle extends Shape
  {
    
    C[] point = new C[4];
    
    Rectangle( C lt, C ar )
    {
      point[ 0 ] = lt;
      point[ 1 ] = new C( lt.x, lt.y + ar.y );
      point[ 2 ] = new C( lt.x + ar.x, lt.y + ar.y );
      point[ 3 ] = new C( lt.x + ar.x, lt.y );
    }
    
    void draw( PGraphics g )
    {
      g.rect( point[ 0 ].x, point[ 0 ].y, point[ 2 ].x - point[ 0 ].x, point[ 2 ].y - point[ 0 ].y );
    }
    
    
    boolean collides( Shape other )
    {
      if(other instanceof Circle){
        
        return collides( (Circle)other, this );
        
      }else{
        throw new RuntimeException();
      }
    }
    
    Line[] edges()
    {
      return new Line[]
      {
        new Line( point[ 0 ], point[ 1 ] ),
        new Line( point[ 1 ], point[ 2 ] ),
        new Line( point[ 2 ], point[ 3 ] ),
        new Line( point[ 3 ], point[ 0 ] ),
      };
    }
    
    String toString()
    {
      return Arrays.toString( point );
    }
  }
  
  
  abstract boolean collides( Shape other );
  
  void draw( PGraphics g )
  {}
  
  
  static boolean collides( C point, Circle circle )
  {
    float distance = point.sub( circle.center ).len();
    
    return distance <= circle.radius;
  }
  
  static boolean collides( C point, Line line )
  {
    float lenLine = line.len();
    float lenAPoint = line.a.sub( point ).len();
    float lenBPoint = line.b.sub( point ).len();
    float total = lenAPoint + lenBPoint;
    float buffer = .0001 * lenLine;
    
    if( total - buffer <= lenLine && total + buffer >= lenLine )
    {
      return true;
    }
    
    return false;
  }
  
  static boolean collides( C point, Rectangle rectangle )
  {
    C p1 = rectangle.point[ rectangle.point.length - 1 ];
    
    for( C p2 : rectangle.point )
    {
      float d = ( p2.x - p1.x ) * ( point.y - p1.y ) - ( point.x  - p1.x ) * ( p2.y - p1.y );
      
      if( d > 0 )
      {
        return false;
      }
      
      p1 = p2;
    }
    
    return true;
  }
  
  static boolean collides( Circle circle, Circle circle2 )
  {
    float distance = circle2.center.sub(circle.center).len();
        
    boolean colliding = distance <= circle2.radius + circle.radius;
    
    return colliding;
  }
  
  static boolean collides( Circle circle, Line line )
  {
    if( collides( line.a, circle ) || collides( line.b, circle ) )
    {
      return true;
    }
    
    final C c = circle.center;
    final C p1 = line.a, p2 = line.b;
    
    float lenLine = line.len();
    
    float dot = ( ( c.x - p1.x ) * ( p2.x - p1.x ) + ( c.y - p1.y ) * ( p2.y - p1.y )  ) / ( lenLine * lenLine );
    
    C pointOnLineClosest = new C( p1.x + dot * ( p2.x - p1.x ), p1.y + dot * ( p2.y - p1.y ) );
    
    if( ! collides( pointOnLineClosest, line ) )
    {
      return false;
    }
    
    return pointOnLineClosest.sub( c ).len() <= circle.radius;
  }
  
  static boolean collides( Circle circle, Rectangle rectangle )
  { 
    if( collides( circle.center, rectangle ) )
    {
      return true;
    }
    
    for( Line edge : rectangle.edges() )
    {
      if( collides( circle, edge ) )
      {
        return true;
      }
    }
    
    return false;
  }
  
  static boolean collides( Line line, Line line2 )
  {
    
    float denominator = ( ( line2.b.x - line2.a.x ) * ( line.b.y - line.a.y ) ) - ( ( line2.b.y - line2.a.y ) * ( line.b.x - line.a.x ) );
    float numerator1 = ((line2.a.y - line.a.y) * (line.b.x - line.a.x)) - ((line2.a.x - line.a.x) * (line.b.y - line.a.y));
    float numerator2 = ((line2.a.y - line.a.y) * (line2.b.x - line2.a.x)) - ((line2.a.x - line.a.x) * (line2.b.y - line2.a.y));
    
    
    if( denominator == 0 )
    {
      return numerator1 == 0 && numerator2 == 0;
    }
    
    float r1 = numerator1 / denominator;
    float r2 = numerator2 / denominator;
    
    //println(this,line);
    
    return r1 >= 0 && r1 <= 1 && r2 >= 0 && r2 <= 1;
  }
  
}


static class C extends Shape {
  
  static final C ZERO = new C( 0, 0 );
  static final C YP = new C( 0, 1 );
  static final C YN = new C( 0, - 1 );
  static final C XP = new C( 1, 0 );
  static final C XN = new C( - 1, 0 );
  
  float x,y;
  
  
  C(float x,float y){
    this.x=x;
    this.y=y;
  }
  
  C add(C c){return new C(x+c.x,y+c.y);}
  C sub(C c){return new C(x-c.x,y-c.y);}
  C mul(C c){return new C(x*c.x,y*c.y);}
  C div(C c){return new C(x/c.x,y/c.y);}
  C sca(float f){return new C(x*f,y*f);}
  float len(){return sqrt(x*x+y*y);}
  float rot(){
    return atan( x / y ) + ( y < 0 ? PI : 0 );
  }
  C unit(){ return sca( 1 / len() ); }
  static float dot(C a, C c){ return a.x*c.x+a.y*c.y; }
  static float dotunit(C a, C c){ return dot( a.unit(), c.unit() ); }
  
  static C rand(C lower, C upper){
    return new C(lower.x+rnd(upper.x-lower.x),lower.y+rnd(upper.y-lower.y));
  }
  
  Iterable<C> iter(){
    return iter(C.ZERO, this, 1);
  }
  boolean iterbounds(C lower, C upper){
    return x>=lower.x && y>=lower.y && x<upper.x && y<upper.y;
  }
  
  static Iterable<C> iter(final C lower, final C upper, final float step){
    return new Iterable<C>(){
      public Iterator<C>iterator(){
        return new Iterator<C>(){
          C at = lower;
          public boolean hasNext(){
            return at.iterbounds(lower, upper);
          }
          public C next(){
            C r = at;
            if(at.x + step >= upper.x) at = new C(lower.x, at.y + step);
            else at = new C(at.x + step, at.y);
            return r;
          }
        };
      }
    };
  }
  
  String toString(){
    return "x "+x+" | y "+y;
  }
  
  boolean collides( Shape other )
  {
    if( other instanceof Circle)
    {
      return collides( this, (Circle)other );
    }
    else if ( other instanceof Line )
    {
      return collides( this, (Line)other );
    }
    else if ( other instanceof Rectangle )
    {
      return collides( this, (Rectangle)other );
    }
    else{
      throw new RuntimeException();
    }
  }
  
  boolean equals( Object other )
  {
    if( ! ( other instanceof C ) )
    {
      return false;
    }
    
    C c = (C)other;
    
    return c.x == this.x && c.y == this.y;
  }
}
