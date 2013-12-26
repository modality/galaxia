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
  public var sectorType:SectorType;
  public var name:String;
  public var gameMenu:GameMenu;
  public var anyExplored:Bool;

  public function new(_st:SectorType)
  {
    super();
    sectorType = _st;
    anyExplored = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();

    add(gameMenu);

    var ent:Base = new Base();
    var text:Text = new Text(name, 20, 10);
    text.size = Constants.FONT_SIZE_LG;
    ent.graphic = text;
    add(ent);

    grid = new Grid<Space>(20, 50, this);
    var spaces:Array<Space> = Generator.generateSectorSpaces(sectorType);
    grid.init(function(i:Int, j:Int):Space {
      var space:Space = spaces.shift();
      space.x = 20+(i*Grid.BLOCK_W);
      space.y = 50+(j*Grid.BLOCK_H);
      space.updateGraphic();
      add(space);
      return space;
    });
  }

  public override function update():Void
  {
    if(Input.mouseReleased) {
      var ent:Space = cast(collidePoint("space", Input.mouseX, Input.mouseY), Space);

      if(ent != null && canExplore(ent)) {
        ent.explore();
        anyExplored = true;
        Game.instance.pulse();
      }
    } else if (Input.pressed(Key.ESCAPE)) {
      Game.instance.goToMenu();
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
