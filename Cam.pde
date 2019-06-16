static class Cam
{
  
  C loc;
  float zoom;
  
  Cam(  )
  {
    this( C.ZERO, 1 );
  }
  
  Cam( C loc, float zoom )
  {
    this.loc = loc;
    this.zoom = zoom;
  }
  
  C px( C loc )
  {
    return this.loc.add( loc.sca( this.zoom ) );
  }
  
  C loc( C px )
  {
    return px.sub( this.loc ).sca( 1f / this.zoom );
  }
  
}
