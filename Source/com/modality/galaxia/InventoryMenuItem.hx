package com.modality.galaxia;

import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class InventoryMenuItem extends Base
{
  public var item:Item;
  public var text:Text;

  public function new(_item:Item)
  {
    super();
    item = _item;
    text = new Text(item.name+" ("+item.amount+")");
    text.size = Constants.FONT_SIZE_SM;
    text.color = 0xFFFFFF;
    this.graphic = text;
  }

  public function updateGraphic():Void
  {
    text.text = item.name+" ("+item.amount+")";
  }
}
