package com.modality.galaxia;

import com.haxepunk.HXP;

class Game
{
  public var sm:SectorMenu;
  public var unknownSectors:Array<Sector>;
  public var outerSectors:Array<Sector>;
  public var innerSectors:Array<Sector>;
  public var coreSectors:Array<Sector>;

  public var fuel:Int;
  public var inventory:Array<Item>;

  public function new()
  {
    Generator.initItems();

    unknownSectors = new Array<Sector>();
    outerSectors = new Array<Sector>();
    innerSectors = new Array<Sector>();
    coreSectors = new Array<Sector>();

    fuel = 10;
    inventory = new Array<Item>();

    for(i in 0...5) {
      unknownSectors.push(new Sector(SectorType.Unknown, this));
      outerSectors.push(new Sector(SectorType.OuterRim, this));
      innerSectors.push(new Sector(SectorType.InnerRim, this));
      coreSectors.push(new Sector(SectorType.Core, this));
    }

    addItem(Generator.generateItem(), 37);
    addItem(Generator.generateItem(), 12);
    addItem(Generator.generateItem(), 4);
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

  public function addItem(name:String, amount:Int):Void
  {
    for(item in inventory) {
      if(item.name == name) {
        item.amount += amount;
        item.updateGraphic();
        return;
      }
    }
    inventory.push(new Item(name, amount));
  }

}
