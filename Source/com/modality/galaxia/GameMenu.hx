package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class GameMenu extends Base
{
  public var game:Game;

  public var fuelGauge:Base;

  public function new(_game:Game)
  {
    super(550, 0);
    type = "game_menu";
    game = _game;
  }

  public override function added()
  {
    var ent:Base;
    var text:Text;

    ent = new Base(x, y+10);
    text = new Text("GALAXIA");
    text.size = Constants.FONT_SIZE_LG;
    ent.graphic = text;
    scene.add(ent);

    fuelGauge = new Base(x, y+40);
    text = new Text("Fuel: "+game.fuel);
    text.size = Constants.FONT_SIZE_SM;
    text.color = Constants.COLOR_FUEL;
    fuelGauge.graphic = text;
    scene.add(fuelGauge);

    ent = new Base(x, y+60);
    text = new Text("Inventory");
    text.size = Constants.FONT_SIZE_SM;
    text.color = 0xFFFFFF;
    ent.graphic = text;
    scene.add(ent);

    var inventory_y:Int = 0;
    for(item in game.inventory) {
      ent = new Base(x, y+80+inventory_y);
      ent.graphic = item.graphic;
      scene.add(ent);
      inventory_y += 20;
    }
  }
}
