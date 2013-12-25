package com.modality.galaxia;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import com.modality.aug.Grid;
import com.modality.aug.Base;

class Sector extends Scene
{
  public var grid:Grid<Space>;
  public var level:String;
  public var name:String;
  public var game:Game;
  public var gameMenu:GameMenu;
  public var anyExplored:Bool;

  public function new(_level:String, _game:Game)
  {
    super();
    level = _level;
    game = _game;
    anyExplored = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();

    add(gameMenu);

    var ent:Base = new Base();
    var text:Text = new Text(name, 20, 10);
    text.size = 24;
    ent.graphic = text;
    add(ent);

    grid = new Grid<Space>(20, 50, this);
    grid.init(function(i:Int, j:Int):Space {
      var block:Space = new Space(20+(i*Grid.BLOCK_W), 50+(j*Grid.BLOCK_H));
      block.changeState(Generator.getBaseSquare(_level));
      add(block);
      return block;
    });
  }

  public override function update():Void
  {
    if(Input.mouseReleased) {
      var ent:Space = cast(collidePoint("space", Input.mouseX, Input.mouseY), Space);

      if(ent != null && canExplore(ent)) {
        ent.explore();
        anyExplored = true;
      }
    } else if (Input.pressed(Key.ESCAPE)) {
      game.goToMenu();
    }
  }

  public function canExplore(space:Space):Bool
  {
    if(!anyExplored) return true;

    var s:Space;
    s = grid.getBlock(space.x_index-1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.getBlock(space.x_index+1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.getBlock(space.x_index, space.y_index-1);
    if(s != null && s.explored) return true;
    s = grid.getBlock(space.x_index, space.y_index+1);
    if(s != null && s.explored) return true;

    return false;
  }
}
