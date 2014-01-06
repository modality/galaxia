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
  public var items:Array<InventoryMenuItem>;
  public var encounters:Array<EncounterMenuItem>;
  public var galaxyMap:Bool;

  public function new(_galaxyMap:Bool = false)
  {
    super(0, 0);
    galaxyMap = _galaxyMap;
    type = "game_menu";
    items = new Array<InventoryMenuItem>();
    encounters = new Array<EncounterMenuItem>();
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

    ent = new TextBase("Inventory");
    ent.x = x;
    ent.y = y+160;
    scene.add(ent);

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

  public function addEncounter(_enc:Encounter):Void
  {
    if(_enc.encounterType != EncounterType.Pirate) {
      for(emi in encounters) {
        if(emi.handlesEncounter(_enc)) {
          emi.addEncounter(_enc);
          layoutMenu();
          return;
        }
      }
    }

    var emi:EncounterMenuItem;

    switch(_enc.encounterType) {
      case Pirate:
        emi = new PirateMenuItem(cast(_enc, Pirate));
      case Librarian, Trader:
        emi = new TradeMenuItem(_enc);
      case Scientist, Terraformer, Astronomer:
        emi = new QuestMenuItem(_enc);
    }

    encounters.push(emi);
    scene.add(emi);
    layoutMenu();
  }

  public function removeEncounter(_enc:Encounter):Void
  {
    var emiToRemove:EncounterMenuItem = null;
    for(emi in encounters) {
      if(emi.hasEncounter(_enc)) {
        scene.remove(emi);
        emiToRemove = emi;
      }
    }
    if(emiToRemove != null) {
      encounters.remove(emiToRemove);
    }
    layoutMenu();
  }

  public function getEncounter(_enc:Encounter):EncounterMenuItem
  {
    for(emi in encounters) {
      if(emi.hasEncounter(_enc)) {
        return emi; 
      }
    }
    return null;
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
    for(imi in items) {
      scene.remove(imi);
    }
    items = new Array<InventoryMenuItem>();
    for(item in Game.instance.inventory) {
      if(item == null) {
        trace("null item!");
      } else {
        var imi:InventoryMenuItem = new InventoryMenuItem(item);
        items.push(imi);
        scene.add(imi);
      }
    }
    for(emi in encounters) {
      emi.updateGraphic();
    }
    layoutMenu();
  }

  public function layoutMenu():Void
  {
    var inventory_y:Int = 180;

    for(imi in items) {
      imi.x = this.x;
      imi.y = this.y + inventory_y;
      inventory_y += 20;
    }

    inventory_y += 20;

    for(emi in encounters) {
      emi.x = this.x;
      emi.y = this.y + inventory_y;
      emi.updateGraphic();
      inventory_y += 50;
    }
  }
}
