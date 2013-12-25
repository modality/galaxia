package com.modality.galaxia;

import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class Item extends Base
{
  public var amount:Int;

  public function new(_name:String, _amount:Int) {
    super();
    name = _name;
    amount = _amount;
    updateGraphic();
  }

  public function updateGraphic():Void
  {
    var text:Text = new Text(name+" ("+amount+")");
    text.size = Constants.FONT_SIZE_SM;
    text.color = 0xFFFFFF;
    this.graphic = text;
  }
}
