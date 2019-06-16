static boolean setupDoneOnce;


static int w, h;


void wh()
{
  w = width;
  h = height;
}


static void filla(PGraphics g, int rgba){
  g.fill((rgba>>24)&0xff,(rgba>>16)&0xff,(rgba>>8)&0xff,(rgba>>0)&0xff);
}
static void fill(PGraphics g, int rgb)
{
  g.fill((rgb>>16)&0xff,(rgb>>8)&0xff,(rgb>>0)&0xff);
}
static void strokea(PGraphics g, int rgba){
  g.stroke((rgba>>24)&0xff,(rgba>>16)&0xff,(rgba>>8)&0xff,(rgba>>0)&0xff);
}
static void stroke(PGraphics g, int rgb)
{
  g.stroke((rgb>>16)&0xff,(rgb>>8)&0xff,(rgb>>0)&0xff);
}


static float rnd ( float v )
{
  return (float)Math.random() * v;
}

static final int ALPHASET( int rgba, int alpha )
{
  return ( rgba & 0xffffff00 ) + alpha;
}

static final int ALPHASCALE( int rgba, int alpha )
{
  
  return ( rgba & 0xffffff00 ) + ( rgba & 0xff ) * alpha / 0xff;
}

static final int RGBA( int rgb )
{
  return ( rgb << 8 ) + 0xff;
}

static final int RGBRED = 0xff0000;
static final int RGBGREEN = 0x00ff00;
static final int RGBBLUE = 0x0000ff;
static final int RGBWHITE = 0xffffff;
static final int RGBBLACK = 0;
static final int RGBYELLOW = 0xffff00;
