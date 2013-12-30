package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class TradeMenuItem extends EncounterMenuItem
{
  public var encounters:Array<Encounter>;
  public var trader_icon:Base;
  public var librarian_icon:Base;
  public var text:Base;

  public function new(_enc:Encounter)
  {
    super();

    encounters = new Array<Encounter>();
    encounters.push(_enc);

    var _text:Text = new Text("Trade / Identify");
    _text.size = Constants.FONT_SIZE_SM;
    _text.color = 0xFFFFFF;
    text = new Base();
    text.graphic = _text;

    trader_icon = new Base();
    trader_icon.graphic = new Image(Assets.TRADER_ICON);

    librarian_icon = new Base();
    librarian_icon.graphic = new Image(Assets.LIBRARIAN_ICON);
  }

  public override function added():Void
  {
    trader_icon.x = this.x;
    trader_icon.y = this.y;
    scene.add(trader_icon);

    librarian_icon.x = this.x + 50;
    librarian_icon.y = this.y;
    scene.add(librarian_icon);

    text.x = this.x + 100;
    text.y = this.y;
    scene.add(text);
  }

  public override function removed():Void
  {
    scene.remove(trader_icon);
    scene.remove(librarian_icon);
    scene.remove(text);
  }

  public override function addEncounter(_enc:Encounter):Void
  {
    encounters.push(_enc);
  }

  public override function handlesEncounter(_enc:Encounter):Bool
  {
    switch(_enc.encounterType) {
      case Librarian, Trader:
        return true;
      default:
        return false;
    }
  }

  public override function updateGraphic():Void
  {
    trader_icon.x = this.x;
    trader_icon.y = this.y;

    librarian_icon.x = this.x + 50;
    librarian_icon.y = this.y;

    text.x = this.x + 100;
    text.y = this.y;
  }
}

