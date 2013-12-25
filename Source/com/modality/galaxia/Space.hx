package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Block;

class Space extends Block
{
  public static var UNEXPLORED_LAYER:Int = 2;
  public static var EXPLORED_LAYER:Int = 1;

  public var explored:Bool = false;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = UNEXPLORED_LAYER;
  }

  public override function changeState(_state_str:String):Void
  {
    super.changeState(_state_str);
    updateGraphic();
  }

  public function explore():Void
  {
    if(!explored) {
      explored = true;
      layer = EXPLORED_LAYER;
      updateGraphic();
    }
  }

  public function updateGraphic():Void
  {
    if(type == "space") {
      if(explored) {
        switch(state_str) {
          case "void":
            graphic = new Image(Assets.VOID_ICON);
          case "star":
            graphic = new Image(Assets.STAR_ICON);
          case "planet":
            graphic = new Image(Assets.PLANET_ICON);
        }
      } else {
        graphic = new Image(Assets.UNEXPLORED_ICON);
      }
    } else if (type == "sector") {
      if(explored) {
        var ss:SectorSketch = new SectorSketch();
        graphic = new Image(ss.output());
      } else {
        graphic = new Image(Assets.SECTOR_OFF_ICON);
      }
    }

    setHitboxTo(graphic);
  }
}
