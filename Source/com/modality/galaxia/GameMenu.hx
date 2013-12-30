package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class GameMenu extends Base
{
  public var shipDisplay:ShipMenuItem;
  public var fuelGauge:Base;
  public var returnToSector:Base;
  public var items:Array<InventoryMenuItem>;
  public var encounters:Array<EncounterMenuItem>;

  public function new()
  {
    super(550, 10);
    type = "game_menu";
    items = new Array<InventoryMenuItem>();
    encounters = new Array<EncounterMenuItem>();
  }

  public override function added()
  {
    var ent:Base;
    var text:Text;

    text = new Text("GALAXIA");
    text.size = Constants.FONT_SIZE_LG;
    this.graphic = text;

    shipDisplay = new ShipMenuItem();
    shipDisplay.x = x;
    shipDisplay.y = y+40;
    scene.add(shipDisplay);

    fuelGauge = new Base(x, y+120);
    text = new Text("Fuel: "+Game.instance.fuel);
    text.size = Constants.FONT_SIZE_SM;
    text.color = Constants.COLOR_FUEL;
    fuelGauge.graphic = text;
    scene.add(fuelGauge);

    ent = new Base(x, y+160);
    text = new Text("Inventory");
    text.size = Constants.FONT_SIZE_SM;
    text.color = 0xFFFFFF;
    ent.graphic = text;
    scene.add(ent);

    for(item in Game.instance.inventory) {
      addItem(item);
    }
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
    for(emi in encounters) {
      if(emi.hasEncounter(_enc)) {
        scene.remove(emi);
      }
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

  public function addItem(_item:Item):Void
  {
    var imi:InventoryMenuItem = new InventoryMenuItem(_item);
    items.push(imi);
    scene.add(imi);
    layoutMenu();
  }

  public function updateGraphic():Void
  {
    cast(fuelGauge.graphic, Text).text = "Fuel: "+Game.instance.fuel;
    shipDisplay.updateGraphic();
    for(gmi in items) {
      gmi.updateGraphic();
    }
    for(emi in encounters) {
      emi.updateGraphic();
    }
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
