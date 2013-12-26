package com.modality.galaxia;

import com.haxepunk.HXP;

class Game
{
  public static var instance:Game;

  public var sm:SectorMenu;
  public var unknownSectors:Array<Sector>;
  public var outerSectors:Array<Sector>;
  public var innerSectors:Array<Sector>;
  public var coreSectors:Array<Sector>;

  public var fuel:Int;
  public var inventory:Array<Item>;

  public function new()
  {
    Game.instance = this;
    Generator.initItems();

    unknownSectors = new Array<Sector>();
    outerSectors = new Array<Sector>();
    innerSectors = new Array<Sector>();
    coreSectors = new Array<Sector>();

    fuel = 10;
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
    HXP.scene = sm;
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
  }

  public function addItem(_item:Item):Void
  {
    var menu:Array<GameMenu> = new Array<GameMenu>();
    HXP.scene.getType("game_menu", menu);

    for(item in inventory) {
      if(item.name == _item.name) {
        item.amount += _item.amount;
        menu[0].updateGraphic();
        return;
      }
    }

    var item:Item = new Item(_item.name, _item.amount);
    inventory.push(item);
    menu[0].addItem(item);
  }

  public function pulse():Void
  {

  }

}
