package com.modality.galaxia;

import flash.display.BitmapData;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class GameMenu extends Base
{
  public var shipDisplay:ShipMenuItem;
  public var fuelGauge:TextBase;
  public var galaxyMapBtn:TextBase;
  public var regenShieldBtn:TextBase;
  public var galaxyMap:Bool;

  public function new(_galaxyMap:Bool = false)
  {
    super(0, 0);
    galaxyMap = _galaxyMap;
    type = "game_menu";
    this.graphic = new Image(new BitmapData(300, Constants.SCREEN_H, false, Constants.COLOR_MENU));
  }

  public override function added()
  {
    var ent:TextBase;

    ent = new TextBase("GALAXIA");
    ent.x = x+20;
    ent.y = y+10;
    ent.text.size = Constants.FONT_SIZE_LG;
    scene.add(ent);

    shipDisplay = new ShipMenuItem();
    shipDisplay.x = x;
    shipDisplay.y = y+40;
    scene.add(shipDisplay);

    fuelGauge = new TextBase("Fuel: "+Game.instance.fuel);
    fuelGauge.x = x;
    fuelGauge.y = y+120;
    fuelGauge.text.color = Constants.COLOR_FUEL;
    scene.add(fuelGauge);

    if(!galaxyMap) {
      galaxyMapBtn = new TextBase("Back to Galaxy\n(2 fuel)");
      galaxyMapBtn.x = x+120;
      galaxyMapBtn.y = y+40;
      galaxyMapBtn.text.color = 0xFF0000;
      galaxyMapBtn.type = "galaxyMapBtn";
      scene.add(galaxyMapBtn);
    }

    regenShieldBtn = new TextBase("Restore Shields\n(0 fuel)");
    regenShieldBtn.x = x+120;
    regenShieldBtn.y = y+80;
    regenShieldBtn.text.color = 0xCCCCCC;
    regenShieldBtn.type = "regenShieldBtn";
    scene.add(regenShieldBtn);

    updateGraphic();
  }


  public function updateGraphic():Void
  {
    fuelGauge.text.text = "Fuel: "+Game.instance.fuel;

    if(Game.instance.shields < Game.instance.maxShields) {
      var shieldFuel = Game.instance.maxShields - Game.instance.shields;
      regenShieldBtn.text.text = "Restore Shields\n("+shieldFuel+" fuel)";
      regenShieldBtn.text.color = 0x00FFFF;
    } else {
      regenShieldBtn.text.text = "Restore Shields\n(0 fuel)";
      regenShieldBtn.text.color = 0xCCCCCC;
    }

    shipDisplay.updateGraphic();
  }

}
