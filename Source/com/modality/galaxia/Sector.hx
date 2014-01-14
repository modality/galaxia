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
  public var nebulaMapped:Bool;
  public var nebulaEnt:Base;

  public function new(_st:SectorType)
  {
    super();
    sectorType = _st;
    nebulaMapped = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();

    add(gameMenu);

    var ent:TextBase = new TextBase("sector "+name.toUpperCase());
    ent.text.size = Constants.FONT_SIZE_LG;
    ent.text.font = Assets.FONT_ITALIC;
    //ent.text.scale = 0.6;
    ent.x = Constants.GRID_X;
    ent.y = 6;
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
    grid.each(function(space:Space, i:Int, j:Int) {
      space.grid = grid;
    });

    var voids:Array<Space> = grid.filter(function(s:Space, i:Int, j:Int):Bool {
      return s.spaceType == SpaceType.Voidness && i != 0 && i <= (Constants.GRID_W-1) && j != 0 && j != (Constants.GRID_H-1) && s.encounter == null;
    });

    var stationSpace:Space = voids.splice(AugRandom.range(0, voids.length), 1)[0];
    stationSpace.spaceType = SpaceType.SpaceStation;
    stationSpace.explored = true;
    stationSpace.updateGraphic();

    Game.instance.currentSpace = stationSpace;
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
    add(Game.instance.ship);
    Game.instance.updateShipPosition();
  }

  public override function update():Void
  {
    super.update();
    if(Input.mouseReleased) {
      var space:Space = cast(collidePoint("space", Input.mouseX, Input.mouseY), Space);
      if(space != null) {
        Game.instance.moveTo(space);
      }

      var btn:Base;
      btn = cast(collidePoint("btn_plus", Input.mouseX, Input.mouseY), Base);
      if(btn != null) {
        if(Game.instance.modEnergy(btn.name, 1)) {
          gameMenu.updateGraphic();
        }
      }

      btn = cast(collidePoint("btn_minus", Input.mouseX, Input.mouseY), Base);
      if(btn != null) {
        if(Game.instance.modEnergy(btn.name, -1)) {
          gameMenu.updateGraphic();
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

}
