package com.modality.galaxia;

import flash.events.Event;
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
  public var tradeMenu:TradeMenu;
  public var anyExplored:Bool;

  public function new(_st:SectorType)
  {
    super();
    sectorType = _st;
    anyExplored = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();
    tradeMenu = new TradeMenu();

    add(gameMenu);

    var ent:Base = new Base();
    var text:Text = new Text(name, Constants.GRID_X, 10);
    text.size = Constants.FONT_SIZE_LG;
    ent.graphic = text;
    add(ent);

    grid = new Grid<Space>(Constants.GRID_X, Constants.GRID_Y, Constants.GRID_W, Constants.GRID_H);
    var spaces:Array<Space> = Generator.generateSectorSpaces(sectorType);
    grid.init(function(i:Int, j:Int):Space {
      var space:Space = spaces.shift();
      space.x = grid.x+(i*Constants.BLOCK_W);
      space.y = grid.y+(j*Constants.BLOCK_H);
      space.updateGraphic();
      add(space);
      return space;
    });
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
    grid.eachBlock(function(s:Space, i:Int, j:Int):Void {
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
