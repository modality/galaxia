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
  public var galaxyMapBtn:TextBase;
  public var regenShieldBtn:TextBase;
  public var galaxyMap:Bool;

  public var menuPanel:Base;

  public function new(_galaxyMap:Bool = false)
  {
    super(0, 0);
    galaxyMap = _galaxyMap;
    type = "game_menu";
    this.graphic = new Image(Assets.GAME_MENU);
  }

  public override function added()
  {
    var ent:TextBase;

    shields = new TextBase("shields");
    shields.x = x+12;
    shields.y = y+370;
    shields.text.color = Constants.COLOR_ACTIVE_1;
    scene.add(shields);

    hull = new TextBase("hull");
    hull.x = x+12;
    hull.y = y+400;
    hull.text.color = Constants.COLOR_ACCENT_2;
    scene.add(hull);

    fuel = new TextBase("fuel");
    fuel.x = x+12;
    fuel.y = y+430;
    fuel.text.color = Constants.COLOR_ACCENT_3;
    scene.add(fuel);

    /*
    menuPanel = new Base();
    menuPanel.x = Constants.GRID_X;
    menuPanel.y = Constants.GRID_Y;
    menuPanel.graphic = new Image(Assets.MENU_PANEL);
    menuPanel.layer = Constants.OVERLAY_LAYER;
    scene.add(menuPanel);
    */

    updateGraphic();
  }


  public function updateGraphic():Void
  {
    shields.text.text = "Shields: "+Game.player.shields+"/"+Game.player.maxShields;
    hull.text.text = "Hull: "+Game.player.hull+"/"+Game.player.maxHull;
    fuel.text.text = "Fuel: "+Game.player.fuel;
  }

}
