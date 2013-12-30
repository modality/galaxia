package com.modality.galaxia;

class Stat
{
  public var numbers:Array<Int>;
  public var name:String;

  public function new(_n:String)
  {
    numbers = new Array<Int>();
    name = _n;
  }

  public function presort():Void
  {
    numbers.sort(function(x:Int, y:Int):Int {
      return x-y;
    });
  }

  public function addNumber(_i:Int):Void
  {
    numbers.push(_i);
  }

  public function mean():Float
  {
    var m:Float = 0;
    for(n in numbers) {
      m += n;
    }
    return m / numbers.length;
  }

  public function median():Int
  {
    return numbers[Math.round(numbers.length/2)];
  }

  public function mode():Int
  {
    var m:Map<Int,Int> = new Map<Int,Int>();
    for(n in numbers) {
      if(m.exists(n)) {
        m.set(n, m.get(n)+1);
      } else {
        m.set(n, 1);
      }
    }

    var highCount:Int = 0;
    var highKey:Int = -1;
    for(k in m.keys()) {
      if(m.get(k) > highCount) {
        highCount = m.get(k);
        highKey = k;
      }
    }

    return highKey;
  }

  public function rangeLow():Int
  {
    return numbers[0];
  }

  public function rangeHigh():Int
  {
    return numbers[numbers.length-1];
  }
}
