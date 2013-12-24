package com.modality.galaxia;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

import com.modality.aug.Base;

class SectorMenu extends Scene
{
  public var game:Game;

  public function new(_game:Game)
  {
    super();
    game = _game;
    game.setSectorMenu(this);
  }

  public override function begin():Void
  {
    var ent:Entity = new Entity(0, 0);
    ent.graphic = new Image(Assets.SECTOR_SELECT);
    add(ent);

    createSectorIcon(325, 136, "unknown_1");
    createSectorIcon(437, 174, "unknown_2");
    createSectorIcon(532, 240, "unknown_3");
    createSectorIcon(600, 332, "unknown_4");
    createSectorIcon(635, 443, "unknown_5");
    createSectorIcon(314, 187, "outer_1");
    createSectorIcon(411, 217, "outer_2");
    createSectorIcon(493, 278, "outer_3");
    createSectorIcon(549, 356, "outer_4");
    createSectorIcon(581, 453, "outer_5");
    createSectorIcon(304, 254, "inner_1");
    createSectorIcon(381, 279, "inner_2");
    createSectorIcon(444, 323, "inner_3");
    createSectorIcon(492, 388, "inner_4");
    createSectorIcon(514, 463, "inner_5");
    createSectorIcon(290, 340, "core_1");
    createSectorIcon(341, 353, "core_2");
    createSectorIcon(385, 383, "core_3");
    createSectorIcon(414, 422, "core_4");
    createSectorIcon(431, 478, "core_5");
  }

  public override function update():Void
  {
    super.update();

    if(Input.mouseReleased) {
      var ent:Base = cast(collidePoint("sector", Input.mouseX, Input.mouseY), Base);

      if(ent != null) {
        game.goToSector(ent.name);
      }
    }
  }

  public function createSectorIcon(icon_x:Int, icon_y:Int, name:String):Void
  {
    var ent:Base = new Base(icon_x, icon_y);
    ent.graphic = new Image(Assets.SECTOR_ICON);
    ent.type = "sector";
    ent.name = name;
    ent.setHitboxTo(ent.graphic);
    add(ent);
  }
}
