package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class PirateMenuItem extends EncounterMenuItem
{
  public var pirate:Pirate;
  public var icon:Base;
  public var text:Base;

  public function new(_p:Pirate)
  {
    super();
    pirate = _p;
    type = "pirate_menu_item";

    var _text:Text = new Text("");
    _text.size = Constants.FONT_SIZE_SM;
    _text.color = 0xFFFFFF;
    text = new Base();
    text.graphic = _text;

    icon = new Base();
    icon.graphic = _p.graphic;
    updateGraphic();
  }

  public override function added():Void
  {
    icon.x = this.x;
    icon.y = this.y;
    scene.add(icon);

    text.x = this.x + 50;
    text.y = this.y;
    scene.add(text);

    setHitboxTo(icon.graphic);
  }

  public override function removed():Void
  {
    scene.remove(icon);
    scene.remove(text);
  }

  public override function updateGraphic():Void
  {
    cast(text.graphic, Text).text = "Pirate\n Attack: "+pirate.attack+" / Health: "+pirate.health;

    icon.x = this.x;
    icon.y = this.y;

    text.x = this.x + 50;
    text.y = this.y;
  }

  public override function hasEncounter(_enc:Encounter):Bool {
    return _enc == pirate;
  }
}
