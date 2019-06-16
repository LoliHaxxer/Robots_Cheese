static interface Information<INFO>
{
  INFO get();
}

<A,B> List<A> g( Map<B,A> map, B... p )
{
  List r = new ArrayList();
  
  for( B pp : p )
  {
    r.add( map.get( pp ) );
  }
  
  return r;
}



<A> List<A> filter( List<A> to, Filter<A> filter )
{
  List r = new ArrayList();
  for( A a : to )
  {
    if( filter.f( a ) )
    {
      r.add( a );
    }
  }
  return r;
}


static interface Filter<A>
{
  boolean f( A a );
}


static boolean bounds( int v, int upper )
{
  return v >= 0 && v < upper;
}
