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

  // ENGINEERING PANEL
  public var weaponsDisplay:EnergyDisplay;
  public var shieldsDisplay:EnergyDisplay;
  public var enginesDisplay:EnergyDisplay;
  public var sensorsDisplay:EnergyDisplay;
  public var reactorDisplay:EnergyDisplay;

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

    buildEngineeringPanel();

    ent = new TextBase("LOG");
    ent.text.size = Constants.FONT_SIZE_MD;
    ent.text.font = Assets.FONT_ITALIC;
    ent.x = 0;
    ent.y = 512;
    scene.add(ent);

    /*
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
    */

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
    weaponsDisplay.cap = Game.player.weaponEnergyCap;
    weaponsDisplay.value = Game.player.weaponEnergy;
    weaponsDisplay.setting = Game.player.weaponEnergySetting;
    
    enginesDisplay.cap = Game.player.engineEnergyCap;
    enginesDisplay.value = Game.player.engineEnergy;
    enginesDisplay.setting = Game.player.engineEnergySetting;

    shieldsDisplay.cap = Game.player.shieldEnergyCap;
    shieldsDisplay.value = Game.player.shieldEnergy;
    shieldsDisplay.setting = Game.player.shieldEnergySetting;

    reactorDisplay.cap = Game.player.totalEnergy;
    reactorDisplay.value = Game.player.freeEnergy;
    reactorDisplay.setting = Game.player.freeEnergy;

    /*
    shields.text.text = "Shields: "+Game.player.shields+"/"+Game.player.maxShields;
    hull.text.text = "Hull: "+Game.player.hull+"/"+Game.player.maxHull;
    fuel.text.text = "Fuel: "+Game.player.fuel;
    */
  }

  public function buildEngineeringPanel():Void
  {
    var eng_y = 256;
    var ent:Base;
    var txt:TextBase;

    txt = new TextBase("ENGINEERING");
    txt.text.size = Constants.FONT_SIZE_MD;
    txt.text.font = Assets.FONT_ITALIC;
    txt.x = 8;
    txt.y = eng_y;
    txt.layer = Constants.BLOOM_LAYER;
    scene.add(txt);

    weaponsDisplay = new EnergyDisplay("WEAPONS", "Damage: 1.2", 2, Assets.PANEL_RED, Assets.BLOOM_RED, Assets.NRG_RED, Assets.NRG_RED_FILL);
    weaponsDisplay.x = 8;
    weaponsDisplay.y = eng_y + 32;
    scene.add(weaponsDisplay);

    shieldsDisplay = new EnergyDisplay("SHIELDS", "Regen: 1.2", 2, Assets.PANEL_BLUE, Assets.BLOOM_BLUE, Assets.NRG_BLUE, Assets.NRG_BLUE_FILL);
    shieldsDisplay.x = 128;
    shieldsDisplay.y = eng_y + 32;
    scene.add(shieldsDisplay);

    enginesDisplay = new EnergyDisplay("ENGINES", "Fuel Use: 0.9\nDmg. Evade: 0.1", 2, Assets.PANEL_GREEN, Assets.BLOOM_GREEN, Assets.NRG_GREEN, Assets.NRG_GREEN_FILL);
    enginesDisplay.x = weaponsDisplay.x;
    enginesDisplay.y = weaponsDisplay.y + 80;
    scene.add(enginesDisplay);

    sensorsDisplay = new EnergyDisplay("SENSORS", "Accuracy: 3\nJamming Pct.:50%", 2, Assets.PANEL_PURPLE, Assets.BLOOM_PURPLE, Assets.NRG_PURPLE, Assets.NRG_PURPLE_FILL);
    sensorsDisplay.x = shieldsDisplay.x;
    sensorsDisplay.y = shieldsDisplay.y + 80;
    scene.add(sensorsDisplay);

    reactorDisplay = new EnergyDisplay("REACTOR", "Transfer Rate: 1", 2, Assets.PANEL_YELLOW, Assets.BLOOM_YELLOW, Assets.NRG_YELLOW, Assets.NRG_YELLOW_FILL, true);
    reactorDisplay.x = enginesDisplay.x;
    reactorDisplay.y = enginesDisplay.y+80;
    scene.add(reactorDisplay);
  }
}
