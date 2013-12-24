package com.modality.galaxia;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.modality.aug.Grid;
import com.modality.aug.Base;

class Sector extends Scene
{
  public var grid:Grid<Space>;
  public var level:String;
  public var game:Game;

  public function new(_level:String, _game:Game)
  {
    super();
    level = _level;
    game = _game;

    grid = new Grid<Space>(150, 50, this);
    grid.init(function(i:Int, j:Int):Space {
      var block:Space = new Space(150+(i*Grid.BLOCK_W), 50+(j*Grid.BLOCK_H));
      block.changeState(Generator.getBaseSquare(_level));
      add(block);
      return block;
    });
  }

  public override function update():Void
  {
    if(Input.mouseReleased) {
      var ent:Space = cast(collidePoint("space", Input.mouseX, Input.mouseY), Space);

      if(ent != null) {
        ent.explore();
      }
    } else if (Input.pressed(Key.ESCAPE)) {
      game.goToMenu();
    }
  }
}
