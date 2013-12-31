package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Block;

class Space extends Block
{
  public var spaceType:SpaceType;
  public var explored:Bool = false;
  public var encounter:Encounter;
  public var item:Item;
  public var description:String;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = Constants.UNEXPLORED_LAYER;
    spaceType = SpaceType.Voidness;
  }

  public override function added():Void
  {
    if(encounter != null) {
      encounter.x = this.x + 10;
      encounter.y = this.y + 10;
      scene.add(encounter);
    }
  }

  public function explore():Void
  {
    if(!explored) {
      explored = true;
      layer = Constants.EXPLORED_LAYER;
      updateGraphic();
      if(encounter != null) {
        encounter.updateGraphic();
        Game.instance.addEncounter(encounter);
        if(encounter.encounterType == EncounterType.Pirate) {
          cast(encounter, Pirate).turnUncovered = Game.instance.turnNumber;
        }
      }
      if(item != null) {
        Game.instance.addItem(item);
        item = null;
      }
      Game.instance.explored();
    }
  }

  public function updateGraphic():Void
  {
    if(type == "space") {
      if(explored) {
        switch(spaceType) {
          case Voidness:
            graphic = new Image(Assets.VOID_ICON);
          case Star:
            graphic = new Image(Assets.STAR_ICON);
          case Planet:
            graphic = new Image(Assets.PLANET_ICON);
        }
      } else {
        graphic = new Image(Assets.UNEXPLORED_ICON);
      }
    } else if (type == "sector") {
      if(explored) {
        var ss:SectorSketch = new SectorSketch();
        graphic = new Image(ss.output());
      } else {
        graphic = new Image(Assets.SECTOR_OFF_ICON);
      }
    }

    setHitboxTo(graphic);
  }
}
