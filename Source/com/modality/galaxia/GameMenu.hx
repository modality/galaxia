package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.modality.aug.Base;

class GameMenu extends Base
{

  public function new()
  {
    super(550, 0);
    type = "game_menu";
  }

  public override function added()
  {
    var ent:Base = new Base(x, y+10);
    var text:Text = new Text("GALAXIA");
    text.size = 36;
    ent.graphic = text;

    scene.add(ent);
  }
}
