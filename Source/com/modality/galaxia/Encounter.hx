package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class Encounter extends Base
{
  public var encounterType:EncounterType;
  public var description:String;

  public function new(_et:EncounterType, _name:String, _desc:String) {
    super();
    layer = Constants.ENCOUNTER_LAYER;
    encounterType = _et;
    name = _name;
    description = _desc;
  }

  public function updateGraphic():Void
  {
    switch(encounterType) {
      case Librarian:
        this.graphic = new Image(Assets.LIBRARIAN_ICON);
      case Astronomer:
        this.graphic = new Image(Assets.ASTRONOMER_ICON);
      case Terraformer:
        this.graphic = new Image(Assets.TERRAFORMER_ICON);
      case Scientist:
        this.graphic = new Image(Assets.SCIENTIST_ICON);
      case Trader:
        this.graphic = new Image(Assets.TRADER_ICON);
      case Pirate:
        this.graphic = new Image(Assets.PIRATE_ICON);
    }
  }
}
