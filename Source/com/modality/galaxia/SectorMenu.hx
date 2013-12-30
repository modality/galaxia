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
  public var gameMenu:GameMenu;
  public var grid:Grid<Space>;

  public function new()
  {
    super();
    Game.instance.setSectorMenu(this);

    gameMenu = new GameMenu();
    add(gameMenu);

    var ent:Base = new Base(20, 10);
    var text:Text = new Text("Explore a sector:");
    text.size = Constants.FONT_SIZE_LG;
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
      block.updateGraphic();
      add(block);
      return block;
    });
  }

  public override function update():Void
  {
    if(Input.mouseReleased) {
      var ent:Space = cast(collidePoint("sector", Input.mouseX, Input.mouseY), Space);

      if(ent != null && ent.name.split("_")[0] != "deep") {
        ent.explore();
        Game.instance.goToSector(ent.name);
      }
    }
  }
}
