package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class QuestMenuItem extends EncounterMenuItem
{
  public var encounterType:EncounterType;
  public var encounters:Array<Encounter>;
  public var icon:Base;
  public var text:Base;

  public function new(_enc:Encounter)
  {
    super();

    encounterType = _enc.encounterType;
    encounters = new Array<Encounter>();
    encounters.push(_enc);

    var _text:Text = new Text("");
    _text.size = Constants.FONT_SIZE_SM;
    _text.color = 0xFFFFFF;
    text = new Base();
    text.graphic = _text;

    icon = new Base();
    icon.graphic = _enc.graphic;
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
  }

  public override function removed():Void
  {
    scene.remove(icon);
    scene.remove(text);
  }

  public override function addEncounter(_enc:Encounter):Void
  {
    encounters.push(_enc);
    updateGraphic();
  }

  public override function handlesEncounter(_enc:Encounter):Bool
  {
    return _enc.encounterType == encounterType;
  }

  public override function updateGraphic():Void
  {
    if(encounters.length < 1) return;
    cast(text.graphic, Text).text = encounters[0].name+" Quests ("+encounters.length+")";

    icon.x = this.x;
    icon.y = this.y;

    text.x = this.x + 50;
    text.y = this.y;
  }
}
