package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class PirateMenuItem extends EncounterMenuItem
{
  public var pirate:Pirate;
  public var icon:Base;

  public function new(_p:Pirate)
  {
    super("");
    pirate = _p;
    type = "encounter";

    icon = new Base();
    icon.graphic = _p.graphic;
    updateGraphic();
  }

  public override function added():Void
  {
    icon.x = this.x;
    icon.y = this.y;
    scene.add(icon);

    text.x = 50;
  }

  public override function removed():Void
  {
    scene.remove(icon);
  }

  public override function updateGraphic():Void
  {
    text.text = "Pirate\nAttack: "+pirate.attack+" / Health: "+pirate.health;

    icon.x = this.x;
    icon.y = this.y;

    text.x = 50;
  }

  public override function hasEncounter(_enc:Encounter):Bool {
    return _enc == pirate;
  }
}
