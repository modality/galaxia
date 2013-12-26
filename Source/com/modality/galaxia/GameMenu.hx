package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class GameMenu extends Base
{

  public var fuelGauge:Base;
  public var items:Array<GameMenuItem>;
  public var inventory_y:Int;

  public function new()
  {
    super(550, 0);
    type = "game_menu";
    inventory_y = 0;
    items = new Array<GameMenuItem>();
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
    text = new Text("Fuel: "+Game.instance.fuel);
    text.size = Constants.FONT_SIZE_SM;
    text.color = Constants.COLOR_FUEL;
    fuelGauge.graphic = text;
    scene.add(fuelGauge);

    ent = new Base(x, y+80);
    text = new Text("Inventory");
    text.size = Constants.FONT_SIZE_SM;
    text.color = 0xFFFFFF;
    ent.graphic = text;
    scene.add(ent);

    for(item in Game.instance.inventory) {
      addItem(item);
    }
  }

  public function addItem(_item:Item):Void
  {
    var gmi:GameMenuItem = new GameMenuItem(_item);
    gmi.x = x;
    gmi.y = y+100+inventory_y;
    items.push(gmi);
    scene.add(gmi);
    inventory_y += 20;
  }

  public function updateGraphic():Void
  {
    for(gmi in items) {
      gmi.updateGraphic();
    }
  }
}
