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

import com.modality.aug.Grid;
import com.modality.aug.Base;

class Sector extends Scene
{
  public var grid:Grid<Space>;
  public var sectorType:SectorType;
  public var name:String;
  public var gameMenu:GameMenu;
  public var tradeMenu:TradeMenu;
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
    tradeMenu = new TradeMenu();

    add(gameMenu);

    var ent:TextBase = new TextBase(name);
    ent.text.size = Constants.FONT_SIZE_LG;
    ent.x = Constants.GRID_X;
    ent.y = 10;
    add(ent);

    var spaces:Array<Space> = Generator.generateSectorSpaces(sectorType);
    grid = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H, function(i:Int, j:Int):Space {
      var space:Space = spaces.shift();
      space.x = Constants.GRID_X+(i*Constants.BLOCK_W);
      space.y = Constants.GRID_Y+(j*Constants.BLOCK_H);
      space.updateGraphic();
      add(space);
      return space;
    });
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

      button = cast(collidePoint("tradeMenuCloseBtn", Input.mouseX, Input.mouseY), Base);
      if(button != null) {
        hideTradeMenu();
        return;
      }

      button = cast(collidePoint("inventorySellBtn", Input.mouseX, Input.mouseY), Base);
      if(button != null) {
        button.dispatchEvent(new Event("onClick"));
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
      } else if(ent != null && ent.explored && ent.encounter != null) {
        switch(ent.encounter.encounterType) {
          case Pirate:
            Game.instance.attackPirate(cast(ent.encounter, Pirate));
            return;
          case Trader:
            showTradeMenu();
            return;
          default:
        }
      }

      var emi:EncounterMenuItem = cast(collidePoint("encounter", Input.mouseX, Input.mouseY), EncounterMenuItem);
      if(emi != null) {
        if(Std.is(emi, PirateMenuItem)) {
          Game.instance.attackPirate(cast(emi, PirateMenuItem).pirate);
        } else if(Std.is(emi, TradeMenuItem)) {
          showTradeMenu();
        }
      }

    } else if (Input.pressed(Key.ESCAPE)) {
      Game.instance.goToMenu();
    }
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

  public function showTradeMenu():Void
  {
    add(tradeMenu);
  }

  public function hideTradeMenu():Void
  {
    remove(tradeMenu);
  }

  public function removeEncounter(_enc:Encounter):Void
  {
    grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.encounter == _enc) {
        s.encounter = null;
      }
    });
    gameMenu.removeEncounter(_enc);
  }

  public function canExplore(space:Space):Bool
  {
    if(space.explored) return false;
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
