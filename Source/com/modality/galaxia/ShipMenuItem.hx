package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class ShipMenuItem extends Base
{
  public function new()
  {
    super();
    updateGraphic();
  }

  public function updateGraphic():Void
  {
    switch(Game.instance.shields) {
      case 0:
        this.graphic = new Image(Assets.SHIP_SHIELD_0);
      case 1:
        this.graphic = new Image(Assets.SHIP_SHIELD_1);
      case 2:
        this.graphic = new Image(Assets.SHIP_SHIELD_2);
      case 3:
        this.graphic = new Image(Assets.SHIP_SHIELD_3);
      default:
    }
  }
}
