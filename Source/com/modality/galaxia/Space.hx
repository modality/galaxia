package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Block;
import com.modality.aug.Grid;

class Space extends Block
{
  public var grid:Grid<Space>;
  public var spaceType:SpaceType;
  public var explored:Bool = false;
  public var onNebula:Bool = false;
  public var locked:Bool = false;
  public var encounter:Encounter;
  public var item:Item;
  public var description:String;

  public function new(_x:Int = 0, _y:Int = 0)
  {
    super(_x, _y);
    type = "space";
    layer = Constants.UNEXPLORED_LAYER;
    spaceType = SpaceType.Voidness;
    locked = false;
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
        if(encounter.encounterType == EncounterType.Pirate) {
          cast(encounter, Pirate).turnUncovered = Game.instance.turnNumber;
        }
      }
      if(item != null) {
        Game.instance.addItem(item);
        item = null;
      }
    }
  }

  public function updateGraphic():Void
  {
    if(type == "space") {
      if(explored) {
        switch(spaceType) {
          case Voidness:
            graphic = null;
          case Star:
            graphic = new Image(Assets.STAR_ICON);
          case Planet:
            graphic = new Image(Assets.PLANET_ICON);
          case SpaceStation:
            graphic = new Image(Assets.SPACE_BASE);
        }
      } else {
        if(!locked) {
          graphic = new Image(Assets.UNEXPLORED_ICON);
        } else {
          graphic = new Image(Assets.UNEXPLORED_LOCKED_ICON);
        }
      }
    } else if (type == "sector") {
      if(explored) {
        var ss:SectorSketch = new SectorSketch();
        graphic = new Image(ss.output());
      } else {
        graphic = new Image(Assets.SECTOR_OFF_ICON);
      }
    }

    setHitbox(Constants.BLOCK_W, Constants.BLOCK_H, 0, 0);
  }
}
