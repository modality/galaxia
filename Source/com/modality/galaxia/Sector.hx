package com.modality.galaxia;

import flash.events.Event;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Ease;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.VarTween;

import com.modality.aug.AugRandom;
import com.modality.aug.Grid;
import com.modality.aug.Base;

class Sector extends Scene
{
  public var grid:Grid<Space>;
  public var sectorType:SectorType;
  public var name:String;
  public var gameMenu:GameMenu;
  public var anyExplored:Bool;
  public var nebulaMapped:Bool;
  public var nebulaEnt:Base;

  public function new(_st:SectorType)
  {
    super();
    sectorType = _st;
    anyExplored = false;
    nebulaMapped = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();

    add(gameMenu);

    var ent:TextBase = new TextBase(name);
    ent.text.size = Constants.FONT_SIZE_LG;
    ent.x = Constants.GRID_X;
    ent.y = 10;
    add(ent);

    var spaces:Array<Space> = Generator.generateSectorSpaces(sectorType);
    grid = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H, function(i:Int, j:Int):Space {
      var space:Space = spaces.shift();
      space.grid = grid;
      space.x = Constants.GRID_X+(i*Constants.BLOCK_W);
      space.y = Constants.GRID_Y+(j*Constants.BLOCK_H);
      space.updateGraphic();
      add(space);
      return space;
    });

    var voids:Array<Space> = grid.filter(function(s:Space, i:Int, j:Int):Bool {
      return s.spaceType == SpaceType.Voidness;
    });

    var stationSpace:Space = voids.splice(AugRandom.range(0, voids.length), 1)[0];
    stationSpace.spaceType = SpaceType.SpaceStation;
    stationSpace.explored = true;
    anyExplored = true;
    stationSpace.updateGraphic();
  }

  public override function begin():Void
  {
    if(nebulaEnt == null) {
      var nebula:NebulaSketch = new NebulaSketch();
      nebulaEnt = new Base();
      nebulaEnt.graphic = new Image(nebula.output());
      nebulaEnt.x = Constants.GRID_X;
      nebulaEnt.y = Constants.GRID_Y;
      nebulaEnt.layer = Constants.NEBULA_LAYER;
      add(nebulaEnt);
      grid.each(function(s:Space, i:Int, j:Int):Void {
        s.onNebula = nebula.grid[i][j];
      });
    }
  }

  public override function update():Void
  {
    super.update();
    if(Input.mouseReleased) {
      var button:Base;

      button = cast(collidePoint("galaxyMapBtn", Input.mouseX, Input.mouseY), Base);
      if(button != null) {
        Game.instance.goToMenu();
        return;
      }

      button = cast(collidePoint("regenShieldBtn", Input.mouseX, Input.mouseY), Base);
      if(button != null) {
        Game.instance.restoreShields();
        return;
      }

      var ent:Space = cast(collidePoint("space", Input.mouseX, Input.mouseY), Space);

      if(ent != null && canExplore(ent)) {
        ent.explore();
        anyExplored = true;
        if(ent.onNebula) {
          checkNebula();
          if(nebulaMapped) {
            Game.instance.exploreSector();
            showSectorExplored();
          }
        }
        if(ent.encounter != null && ent.encounter.encounterType == EncounterType.Pirate) {
          checkLocked();
        }
      } else if(ent != null && ent.explored && ent.encounter != null) {
        switch(ent.encounter.encounterType) {
          case Pirate:
            Game.instance.attackPirate(cast(ent.encounter, Pirate));
            checkLocked();
            return;
          default:
        }
      }
    } else if (Input.pressed(Key.ESCAPE)) {
      Game.instance.goToMenu();
    } else if (Input.pressed(Key.F)) {
      grid.each(function(s:Space, i:Int, j:Int):Void {
        s.explore();
      });
    }
  }

  public function checkLocked():Void
  {
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(u in i-1...i+2) {
          for(v in j-1...j+2) {
            var nayb = grid.get(u, v);
            if(nayb != null && nayb.explored && nayb.encounter != null && nayb.encounter.encounterType == EncounterType.Pirate) {
              s.locked = true;
            }
          }
        }
        s.updateGraphic();
      }
    });
  }

  public function checkNebula():Void
  {
    var _nebulaMapped:Bool = true;
    var nebsLeft:Int = 0;

    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.onNebula && !s.explored) {
        _nebulaMapped = false;
        nebsLeft++;
      }
    });

    nebulaMapped = _nebulaMapped;
  }

  public function showSectorExplored():Void
  {
    var ent:Base = new Base();
    ent.x = Constants.GRID_X;
    ent.y = Constants.GRID_Y + 200;
    ent.graphic = new Image(Assets.SECTOR_MAPPED);
    cast(ent.graphic, Image).alpha = 0;
    ent.layer = Constants.EFFECTS_LAYER;
    add(ent);

    var vt = new VarTween(function(o:Dynamic):Void {
      var ot = new VarTween(function(o:Dynamic):Void {
        remove(ent);
      }, TweenType.OneShot);
      ot.tween(cast(ent.graphic,Image), "alpha", 0, 30, Ease.quadIn);
      ent.addTween(ot, true);
    }, TweenType.OneShot);

    vt.tween(cast(ent.graphic, Image), "alpha", 1, 10);
    ent.addTween(vt, true);
  }

  public function removeEncounter(_enc:Encounter):Void
  {
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.encounter == _enc) {
        s.encounter = null;
      }
    });
  }

  public function canExplore(space:Space):Bool
  {
    if(space.explored) return false;
    if(space.locked) return false;
    if(!anyExplored) return true;

    var s:Space;
    s = grid.get(space.x_index-1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index+1, space.y_index);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index-1);
    if(s != null && s.explored) return true;
    s = grid.get(space.x_index, space.y_index+1);
    if(s != null && s.explored) return true;

    return false;
  }
}
