package com.modality.galaxia;

import com.haxepunk.HXP;

class Game
{
  public static var instance:Game;

  public var turnNumber:Int;
  public var sm:SectorMenu;
  public var unknownSectors:Array<Sector>;
  public var outerSectors:Array<Sector>;
  public var innerSectors:Array<Sector>;
  public var coreSectors:Array<Sector>;

  public var attack:Int;
  public var shields:Int;
  public var health:Int;
  public var sectorsMapped:Int;

  public var maxShields:Int;
  public var maxHealth:Int;

  public var fuel:Int;
  public var inventory:Array<Item>;

  public function new()
  {
    Game.instance = this;
    Generator.init();

    turnNumber = 0;
    sectorsMapped = 0;
    maxShields = Constants.STARTING_SHIELDS;
    maxHealth = Constants.STARTING_HEALTH;
    shields = maxShields;
    health = maxHealth;
    attack = 1;
    fuel = Constants.STARTING_FUEL;

    unknownSectors = new Array<Sector>();
    outerSectors = new Array<Sector>();
    innerSectors = new Array<Sector>();
    coreSectors = new Array<Sector>();

    inventory = new Array<Item>();

    for(i in 0...5) {
      unknownSectors.push(new Sector(SectorType.Unknown));
      outerSectors.push(new Sector(SectorType.OuterRim));
      innerSectors.push(new Sector(SectorType.InnerRim));
      coreSectors.push(new Sector(SectorType.Core));
    }
  }

  public function setSectorMenu(_sm:SectorMenu):Void
  {
    sm = _sm; 
  }

  public function goToMenu():Void
  {
    piratesHeal();
    HXP.scene = sm;
    useFuel(2);
    updateMenu();
  }

  public function goToSector(name:String):Void
  {
    var sectorType:String = name.split("_")[0];
    var sectorNum:Int = Std.parseInt(name.split("_")[1]);

    switch(sectorType) {
      case "unknown":
        HXP.scene = unknownSectors[sectorNum-1];
      case "outer":
        HXP.scene = outerSectors[sectorNum-1];
      case "inner":
        HXP.scene = innerSectors[sectorNum-1];
      case "core":
        HXP.scene = coreSectors[sectorNum-1];
    }
    updateMenu();
  }

  public function addEncounter(_enc:Encounter):Void
  {
    var menu:Array<GameMenu> = new Array<GameMenu>();
    HXP.scene.getType("game_menu", menu);

    menu[0].addEncounter(_enc);
  }

  public function addItem(_item:Item):Void
  {
    var menu:Array<GameMenu> = new Array<GameMenu>();
    HXP.scene.getType("game_menu", menu);

    if(_item.name == "Fuel") {
      fuel += _item.amount;
    } else {
      var foundItem:Bool = false;
      for(item in inventory) {
        if(item.name == _item.name) {
          foundItem = true;
          item.amount += _item.amount;
          return;
        }
      }
      if(!foundItem) {
        var item:Item = new Item(_item.name, _item.amount);
        inventory.push(item);
      }
    }
    menu[0].updateGraphic();
  }

  public function pulse():Void
  {
    if(HXP.scene != sm) {
      piratesAttack();
    }
    updateMenu();
    turnNumber++;
  }

  public function explored():Void
  {
    if(HXP.scene != sm) {
      useFuel(1);
    }
    pulse();
  }

  public function exploreSector():Void
  {
    sectorsMapped++;
  }

  public function updateMenu():Void
  {
    if(HXP.scene == sm) {
      sm.gameMenu.updateGraphic();
    } else {
      cast(HXP.scene, Sector).gameMenu.updateGraphic();
    }
  }

  public function piratesAttack():Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
    sector.grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.explored) {
        if(s.encounter != null && s.encounter.encounterType == EncounterType.Pirate) {
          var p:Pirate = cast(s.encounter, Pirate);
          if(p.health > 0 && p.turnUncovered < turnNumber) {
            takeDamage(p.attack);
          }
        }
      }
    });
  }

  public function piratesHeal():Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
    sector.grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.explored) {
        if(s.encounter != null && s.encounter.encounterType == EncounterType.Pirate) {
          var p:Pirate = cast(s.encounter, Pirate);
          p.health = maxHealth;
        }
      }
    });
  }

  public function sellItem(_item:Item):Void
  {
    var itemValue:Int = 0;
    if(_item.name == Generator.commonGood.name) {
      itemValue = _item.amount; 
    } else if(_item.name == Generator.uncommonGood.name) {
      itemValue = _item.amount * 2;
    } else if(_item.name == Generator.rareGood.name) {
      itemValue = _item.amount * 3;
    }

    fuel += itemValue;
    inventory.remove(_item);
    updateMenu();
  }

  public function useFuel(howMuch:Int):Void
  {
    fuel -= howMuch;

    if(fuel < 0) {
      fuel = 0;
      shields = 0;
    }
  }

  public function restoreShields():Void
  {
    useFuel(maxShields - shields);
    if(fuel > 0) {
      shields = maxShields;
    }
    updateMenu();
  }

  public function takeDamage(howMuch:Int):Void
  {
    var damageTaken:Int = 0;
    if(shields > 0) {
      if(howMuch >= shields) {
        damageTaken = shields;
        shields = 0;
      } else {
        shields -= howMuch;
        damageTaken = howMuch;
      }
    }

    if(damageTaken == howMuch) return;

    if((howMuch-damageTaken) >= health) {
      damageTaken += health;
      health = 0;
    } else {
      health -= (howMuch-damageTaken);
      damageTaken = howMuch;
    }
  }

  public function attackPirate(pirate:Pirate):Void
  {
    pirate.takeDamage(attack);
    pulse();
  }
}
