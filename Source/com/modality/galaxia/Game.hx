package com.modality.galaxia;

import com.haxepunk.HXP;

class Game
{
  //public static var instance:Game;

  public var sm:SectorMenu;
  public var unknownSectors:Array<Sector>;
  public var outerSectors:Array<Sector>;
  public var innerSectors:Array<Sector>;
  public var coreSectors:Array<Sector>;

  public function new()
  {
    unknownSectors = new Array<Sector>();
    outerSectors = new Array<Sector>();
    innerSectors = new Array<Sector>();
    coreSectors = new Array<Sector>();

    for(i in 0...5) {
      unknownSectors.push(new Sector("unknown", this));
      outerSectors.push(new Sector("outer", this));
      innerSectors.push(new Sector("inner", this));
      coreSectors.push(new Sector("core", this));
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

}
