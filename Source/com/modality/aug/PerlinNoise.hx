package com.modality.aug;

import flash.display.BitmapData;

class PerlinNoise
{
  public var seed:Float;
  public var octaves:Int;
  public var falloff:Float;
  private var perm:Array<Int>;

  public function new(_seed:Float)
  {
    seed = _seed;
    octaves = 4;
    falloff = 0.5;

    perm = new Array<Int>();
    for(i in 0...256) { perm.push(i); }
    for(i in 0...256) {
      var j:Int = Std.random(256);
      var t:Int = perm[j];
      perm[j] = perm[i]; perm[i] = t;
    }
    for(i in 0...256) { perm.push(perm[i]); }
  }

  public function noise1d(x:Float):Float
  {
    var X = Math.floor(x)&255;
    x -= Math.floor(x);
    var fx = (3-2*x)*x*x;
    return lerp(fx, grad1d(perm[X], x), grad1d(perm[X+1], x-1));
  }

  public function noise2d(x:Float, y:Float):Float
  {
    var X = Math.floor(x)&255, Y = Math.floor(y)&255;
    x -= Math.floor(x); y -= Math.floor(y);
    var fx = (3-2*x)*x*x, fy = (3-2*y)*y*y;
    var p0 = perm[X]+Y, p1 = perm[X + 1] + Y;
    return lerp(fy,
      lerp(fx, grad2d(perm[p0], x, y), grad2d(perm[p1], x-1, y)),
      lerp(fx, grad2d(perm[p0 + 1], x, y-1), grad2d(perm[p1 + 1], x-1, y-1)));
  }

  public function noise3d(x:Float, y:Float, z:Float):Float
  {
    var X = Math.floor(x)&255, Y = Math.floor(y)&255, Z = Math.floor(z)&255;
    x -= Math.floor(x); y -= Math.floor(y); z -= Math.floor(z);
    var fx = (3-2*x)*x*x, fy = (3-2*y)*y*y, fz = (3-2*z)*z*z;
    var p0 = perm[X]+Y, p00 = perm[p0] + Z, p01 = perm[p0 + 1] + Z,
        p1 = perm[X + 1] + Y, p10 = perm[p1] + Z, p11 = perm[p1 + 1] + Z;
    return lerp(fz,
      lerp(fy, lerp(fx, grad3d(perm[p00], x, y, z), grad3d(perm[p10], x-1, y, z)),
                lerp(fx, grad3d(perm[p01], x, y-1, z), grad3d(perm[p11], x-1, y-1,z))),
      lerp(fy, lerp(fx, grad3d(perm[p00 + 1], x, y, z-1), grad3d(perm[p10 + 1], x-1, y, z-1)),
                lerp(fx, grad3d(perm[p01 + 1], x, y-1, z-1), grad3d(perm[p11 + 1], x-1, y-1,z-1))));
  }

  public function lerp(t:Float, a:Float, b:Float):Float
  {
    return a + t * (b - a);
  }

  public function grad3d(i:Int, x:Float, y:Float, z:Float):Float {
    var h = i & 15; // convert into 12 gradient directions
    var u = h<8 ? x : y,
        v = h<4 ? y : h==12||h==14 ? x : z;
    return ((h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
  }

  public function grad2d(i:Int, x:Float, y:Float) {
    var v = (i & 1) == 0 ? x : y;
    return (i&2) == 0 ? -v : v;
  }

  public function grad1d(i:Int, x:Float) {
    return (i&1) == 0 ? -x : x;
  }
}
