package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class TradeMenu extends Base
{
  public var title_text:TextBase;
  public var close_btn:TextBase;
  public var items:Array<InventoryMenuItem>;

  public function new()
  {
    super();
    layer = Constants.EFFECTS_LAYER;
    items = new Array<InventoryMenuItem>();

    this.graphic = new Image(Assets.MENU_PANEL);
    x = 256;
    y = 192;

    title_text = new TextBase("Trade / Identify");
    title_text.layer = layer;
    title_text.x = x+10;
    title_text.y = y+10;

    close_btn = new TextBase("[x]");
    close_btn.type = "tradeMenuCloseBtn";
    close_btn.layer = layer;
    close_btn.text.color = 0xFF0000;
    close_btn.x = x+480;
    close_btn.y = y+10;
  }

  public override function added()
  {
    scene.add(title_text);
    scene.add(close_btn);
    updateGraphic();
  }

  public override function removed()
  {
    scene.remove(title_text);
    scene.remove(close_btn);
    for(imi in items) {
      scene.remove(imi);
    }
  }

  public function updateGraphic()
  {
    for(imi in items) {
      scene.remove(imi);
    }
    items = new Array<InventoryMenuItem>();
    for(item in Game.instance.inventory) {
      var imi:InventoryMenuItem = new InventoryMenuItem(item);
      imi.type = "inventorySellBtn";
      imi.layer = Constants.EFFECTS_LAYER;
      imi.addEventListener("onClick", function(e:Dynamic):Void {
        Game.instance.sellItem(imi.item);
        updateGraphic();
      });

      items.push(imi);
      scene.add(imi);
    }
    layoutMenu();
  }

  public function layoutMenu():Void
  {
    var inventory_y:Int = 50;

    for(imi in items) {
      imi.x = this.x+10;
      imi.y = this.y + inventory_y;
      inventory_y += 20;
    }
  }
}
