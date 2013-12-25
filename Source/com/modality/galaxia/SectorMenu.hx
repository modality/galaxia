package com.modality.galaxia;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

import com.modality.aug.Base;
import com.modality.aug.Grid;

class SectorMenu extends Scene
{
  public var game:Game;
  public var gameMenu:GameMenu;
  public var grid:Grid<Space>;

  public function new(_game:Game)
  {
    super();
    game = _game;
    game.setSectorMenu(this);

    gameMenu = new GameMenu();
    add(gameMenu);

    var ent:Base = new Base(20, 10);
    var text:Text = new Text("Explore a sector:");
    text.size = 24;
    ent.graphic = text;
    add(ent);

    grid = new Grid<Space>(20, 50, this);
    grid.init(function(i:Int, j:Int):Space {
      var block:Space = new Space(20+(i*Grid.BLOCK_W), 50+(j*Grid.BLOCK_H));
      block.type = "sector";
      block.name = switch(j) {
        case 0: "unknown";
        case 1: "outer";
        case 2: "inner";
        case 3: "core";
        case 4: "deep";
        default: "deep";
      }
      block.name = block.name + "_" + (i+1);
      block.changeState("unexplored_sector");
      add(block);
      return block;
    });
    /*
    createSectorIcon(195, 136, "unknown_1");
    createSectorIcon(307, 174, "unknown_2");
    createSectorIcon(402, 240, "unknown_3");
    createSectorIcon(470, 332, "unknown_4");
    createSectorIcon(505, 443, "unknown_5");
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
    */
  }

  public override function update():Void
  {
    super.update();

    if(Input.mouseReleased) {
      var ent:Space = cast(collidePoint("sector", Input.mouseX, Input.mouseY), Space);

      if(ent != null && ent.name.split("_")[0] != "deep") {
        ent.explore();
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
