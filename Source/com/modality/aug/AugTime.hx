package com.modality.aug;

import com.haxepunk.HXP;

class AugTime
{
  public static inline function setFPS(fps:Int):Void
  {
	  HXP.frameRate = 30;
	  HXP.rate = 30;
  }

  public static inline function millis(frames:Int):Int
  {
    return Math.floor(frames / HXP.frameRate * 1000);
  }
}
