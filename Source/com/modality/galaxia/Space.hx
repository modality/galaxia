package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Block;

class Space extends Block
{
  public var explored:Bool = false;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
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
      updateGraphic();
    }
  }

  public function updateGraphic():Void
  {
    if(explored) {
      switch(state_str) {
        case "void":
          graphic = new Image(Assets.SPACE_ICON);
        case "star":
          graphic = new Image(Assets.STAR_ICON);
        case "planet":
          graphic = new Image(Assets.PLANET_ICON);
      }
    } else {
      graphic = new Image(Assets.UNEXPLORED_ICON);
    }

    setHitboxTo(graphic);
  }
}
