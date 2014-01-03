package com.modality.aug;

class Vector3
{
  public var x:Float;
  public var y:Float;
  public var z:Float;

  public function new(_x:Float = 0, _y:Float = 0, _z:Float = 0)
  {
    x = _x;
    y = _y;
    z = _z;
  }

  public function div(_s:Float):Void
  {
    x = x/_s; y = y/_s; z = z/_s;
  }
}
