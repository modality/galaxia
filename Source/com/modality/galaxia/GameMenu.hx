package com.modality.galaxia;

import flash.display.BitmapData;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class GameMenu extends Base
{
  public var shields:TextBase;
  public var hull:TextBase;
  public var fuel:TextBase;
  public var economy:TextBase;
  public var science:TextBase;
  public var money:TextBase;
  public var galaxyMapBtn:TextBase;
  public var regenShieldBtn:TextBase;
  public var galaxyMap:Bool;

  // ENGINEERING PANEL
  public var menuPanel:Base;

  public function new(_galaxyMap:Bool = false)
  {
    super(0, 0);
    galaxyMap = _galaxyMap;
    type = "game_menu";
    //this.graphic = new Image(Assets.GAME_MENU);
  }

  public override function added()
  {
    var ent:TextBase;

    ent = new TextBase("SCANNER");
    ent.text.size = Constants.FONT_SIZE_MD;
    ent.text.font = Assets.FONT_ITALIC;
    ent.x = 0;
    ent.y = 0;
    scene.add(ent);

    ent = new TextBase("LOG");
    ent.text.size = Constants.FONT_SIZE_MD;
    ent.text.font = Assets.FONT_ITALIC;
    ent.x = 0;
    ent.y = 512;
    scene.add(ent);

    shields = new TextBase("shields");
    shields.x = x+12;
    shields.y = y+150;
    shields.text.color = Constants.COLOR_ACTIVE_1;
    scene.add(shields);

    hull = new TextBase("hull");
    hull.x = x+12;
    hull.y = y+180;
    hull.text.color = Constants.COLOR_ACCENT_2;
    scene.add(hull);

    fuel = new TextBase("fuel");
    fuel.x = x+12;
    fuel.y = y+210;
    fuel.text.color = Constants.COLOR_ACCENT_3;
    scene.add(fuel);

    economy = new TextBase("economy");
    economy.x = x+12;
    economy.y = y+40;
    scene.add(economy);

    science = new TextBase("science");
    science.x = x+12;
    science.y = y+60;
    scene.add(science);

    money = new TextBase("money");
    money.x = x+12;
    money.y = y+80;
    scene.add(money);

    var powers_y = 240;
    for(power in Game.player.powers) {
      power.x = 0;
      power.y = powers_y;
      powers_y += 100;
      scene.add(power);
    }

    updateGraphic();
  }

  public function updateGraphic():Void
  {
    shields.text.text = "Shields: "+Game.player.shields+"/"+Game.player.maxShields;
    hull.text.text = "Hull: "+Game.player.hull+"/"+Game.player.maxHull;
    fuel.text.text = "Fuel: "+Game.player.fuel;
    economy.text.text = "Economy: "+Game.economy.economy+"/"+Game.economy.nextEconomyCycle;
    science.text.text = "Science: "+Game.economy.science;
    money.text.text = "Money: "+Game.economy.money;
  }
}
