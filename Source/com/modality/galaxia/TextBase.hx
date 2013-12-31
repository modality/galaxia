package com.modality.galaxia;

import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class TextBase extends Base
{
  public var text:Text;

  public function new(_str)
  {
    super();
    text = new Text(_str);
    this.graphic = text;
    updateHitbox();
  }
  
  public function updateHitbox()
  {
    setHitboxTo(text);
  }
}
