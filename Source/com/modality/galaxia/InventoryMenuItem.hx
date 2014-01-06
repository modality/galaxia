package com.modality.galaxia;

import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class InventoryMenuItem extends TextBase
{
  public var item:Item;

  public function new(_item:Item)
  {
    super(_item.name+" ("+_item.amount+")");
    item = _item;
    type = "inventoryMenuItem";
  }

  public function updateGraphic():Void
  {
    text.text = item.name+" ("+item.amount+")";
  }
}
