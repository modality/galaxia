package com.modality.galaxia;

class Constants
{
  //s 5, 16, 24, 48 and 72 p
  public static var FONT_SIZE_LG:Int = 32;
  public static var FONT_SIZE_MD:Int = 24;
  public static var FONT_SIZE_SM:Int = 16;
  public static var FONT_SIZE_XS:Int = 12;

  public static var COLOR_FUEL:Int = 0xFFB300;
  public static var COLOR_ENEMY:Int = 0xFF4000;
  public static var COLOR_MENU:Int = 0x051A46;
  public static var COLOR_LINE:Int = 0x57A9E9;
  public static var COLOR_BG:Int = 0x02182D;

  public static var COLOR_ACCENT_1:Int = 0x602242;
  public static var COLOR_ACCENT_2:Int = 0x87283B;
  public static var COLOR_ACCENT_3:Int = 0xFCDC56;
  public static var COLOR_ACCENT_4:Int = 0xFFF9D2;

  public static var COLOR_ACTIVE_1:Int = 0x4FA7E3;
  public static var COLOR_ACTIVE_2:Int = 0x2C5D8D;

  public static var SCREEN_W:Int = 1024;
  public static var SCREEN_H:Int = 768;
  public static var GRID_X:Int = 320;
  public static var GRID_Y:Int = 64;
  public static var GRID_W:Int = 8;
  public static var GRID_H:Int = 8;
  public static var BLOCK_W:Int = 80;
  public static var BLOCK_H:Int = 80;

#if mobile
  public static var X_SCALE:Float = 0.5;
  public static var Y_SCALE:Float = 0.5;
#else
  public static var X_SCALE:Float = 1;
  public static var Y_SCALE:Float = 1;
#end

  public static var NEBULA_LAYER:Int = 7;
  public static var BEACON_LAYER:Int = 6;
  public static var UNEXPLORED_LAYER:Int = 5;
  public static var EXPLORED_LAYER:Int = 4;
  public static var ENCOUNTER_LAYER:Int = 3;
  public static var EFFECTS_LAYER:Int = 2;
  public static var OVERLAY_LAYER:Int = 1;

  public static var MENU_LAYER:Int = 5;
  public static var SLOT_LAYER:Int = 4;
  public static var ENERGY_LAYER:Int = 3;
  public static var DRAIN_LAYER:Int = 2;
  public static var BLOOM_LAYER:Int = 1;

}
