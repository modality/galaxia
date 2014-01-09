package com.modality.galaxia;

import com.haxepunk.HXP;

import com.modality.aug.AStar;
import com.modality.aug.Node;
import com.modality.aug.Grid;

class Game
{
  public static var instance:Game;
  public static var player:Ship;

  public var turnNumber:Int;
  public var sm:SectorMenu;
  public var inCombat:Bool;
  public var currentSpace:Space;
  public var inventory:Array<Item>;
  public var ship:Ship;

  public function new()
  {
    Game.instance = this;
    Generator.init();

    turnNumber = 0;
    inCombat = false;

    inventory = new Array<Item>();
    ship = new Ship();

    Game.player = ship;
  }

  public function setSectorMenu(_sm:SectorMenu):Void
  {
    sm = _sm; 
  }

  public function goToMenu():Void
  {
    /*
    piratesHeal();
    HXP.scene = sm;
    useFuel(2);
    updateMenu();
    */
  }

  public function goToSector(name:String):Void
  {
    /*
    var sectorType:String = name.split("_")[0];
    var sectorNum:Int = Std.parseInt(name.split("_")[1]);

    switch(sectorType) {
      case "unknown":
        HXP.scene = unknownSectors[sectorNum-1];
      case "outer":
        HXP.scene = outerSectors[sectorNum-1];
      case "inner":
        HXP.scene = innerSectors[sectorNum-1];
      case "core":
        HXP.scene = coreSectors[sectorNum-1];
    }
    updateMenu();
    */
  }


  public function addItem(_item:Item):Void
  {
    if(_item.name == "Fuel") {
      ship.fuel += _item.amount;
    } else {
      var foundItem:Bool = false;
      for(item in inventory) {
        if(item.name == _item.name) {
          foundItem = true;
          item.amount += _item.amount;
          return;
        }
      }
      if(!foundItem) {
        var item:Item = new Item(_item.name, _item.amount);
        inventory.push(item);
      }
    }
  }

  public function moveTo(space:Space)
  {
    var grid:Grid<Space> = space.grid;

    if(!inCombat && canExplore(space)) {
      space.explore();
      var e:AStar = new AStar();
      e.generateMap(grid.width, grid.height);
      e.eachNode(function(n:Node):Void {
        if(n.x == currentSpace.x_index && n.y == currentSpace.y_index) {
          n.setTypeByText("START_NODE");
        } else if(n.x == space.x_index && n.y == space.y_index) {
          n.setTypeByText("END_NODE");
        } else if(!grid.get(n.x, n.y).explored) {
          n.setTypeByText("BREAK_NODE");
        }
      });

      var nodes:Array<Node> = e.getPath();
      
      if(space.encounter != null && space.encounter.encounterType == EncounterType.Pirate) {
        //inCombat = true;
        nodes.pop();
      }
      if(nodes.length > 0) {
        currentSpace = grid.get(nodes[nodes.length-1].x, nodes[nodes.length-1].y);
        ship.moveOnPath(nodes);
      }
      
      /*
      e.setStartNode(e.getNode(currentSpace.x_index, currentSpace.y_index));
      e.setEndNode(e.getNode(space.x_index, space.y_index));
      */
      /*

        if(ent.encounter != null && ent.encounter.encounterType == EncounterType.Pirate) {
          checkLocked();
        }
        Game.instance.currentSpace = ent;
        Game.instance.updateShipPosition();
      } else if(ent != null && ent.explored && ent.encounter != null) {
        switch(ent.encounter.encounterType) {
          case Pirate:
            Game.instance.attackPirate(cast(ent.encounter, Pirate));
            checkLocked();
            return;
          default:
        }
      }*/
    }

  }

  public function checkLocked(grid:Grid<Space>):Void
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

  public function canExplore(space:Space):Bool
  {
    if(space.explored) return false;
    if(space.locked) return false;
    var s:Space;
    var grid:Grid<Space> = space.grid;

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

  public function pulse():Void
  {
    if(HXP.scene != sm) {
      piratesAttack();
      //cast(HXP.scene, Sector).checkLocked();
    }
    updateMenu();
    turnNumber++;
  }

  public function explored():Void
  {
    if(HXP.scene != sm) {
      //useFuel(1);
    }
    pulse();
  }

  public function updateMenu():Void
  {
    if(HXP.scene == sm) {
      sm.gameMenu.updateGraphic();
    } else {
      cast(HXP.scene, Sector).gameMenu.updateGraphic();
    }
  }

  public function piratesAttack():Void
  {
    /*
    var sector:Sector = cast(HXP.scene, Sector);
    sector.grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.explored) {
        if(s.encounter != null && s.encounter.encounterType == EncounterType.Pirate) {
          var p:Pirate = cast(s.encounter, Pirate);
          if(p.health > 0 && p.turnUncovered < turnNumber) {
            takeDamage(p.attack);
          }
        }
      }
    });
    */
  }

  public function piratesHeal():Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
    sector.grid.each(function(s:Space, i:Int, j:Int):Void {
      if(s.explored) {
        if(s.encounter != null && s.encounter.encounterType == EncounterType.Pirate) {
          var p:Pirate = cast(s.encounter, Pirate);
          p.health = p.maxHealth;
        }
      }
    });
  }

  public function attackPirate(pirate:Pirate):Void
  {
    pirate.takeDamage(ship.attack);
    // retaliation
    if(pirate.health > 0 && pirate.turnUncovered < turnNumber) {
      ship.takeDamage(pirate.attack);
    }
    pulse();
  }

  public function updateShipPosition():Void
  {
    if(currentSpace != null) {
      ship.x = currentSpace.x;
      ship.y = currentSpace.y;
    }
  }
}
