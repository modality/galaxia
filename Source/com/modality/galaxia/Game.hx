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

    if(!space.explored && !canExplore(space)) return;

    var e:AStar = new AStar();
    e.generateMap(grid.width, grid.height);
    e.eachNode(function(n:Node):Void {
      if(n.x == ship.space.x_index && n.y == ship.space.y_index) {
        n.setTypeByText("START_NODE");
      } else if(n.x == space.x_index && n.y == space.y_index) {
        n.setTypeByText("END_NODE");
      } else if(!grid.get(n.x, n.y).explored) {
        n.setTypeByText("BREAK_NODE");
      }
    });

    var nodes:Array<Node> = e.getPath();
    if(nodes.length == 0) return;

    var turnTaken:Bool = false;

    if(!inCombat) {
      if(canExplore(space)) {
        space.explore();
        ship.step(false, true);
        turnTaken = true;
      }
      if(space.encounter != null && space.encounter.encounterType == EncounterType.Pirate) {
        inCombat = true;
        nodes.pop();
      }
      if(nodes.length > 0) {
        ship.setSpace(grid.get(nodes[nodes.length-1].x, nodes[nodes.length-1].y));
        ship.moveOnPath(nodes);
      }
    } else {
      space = grid.get(nodes[0].x, nodes[0].y);
      turnTaken = true;
      if(canExplore(space)) {
        space.explore();
        ship.step(true, true);
        if(space.encounter != null && space.encounter.encounterType == EncounterType.Pirate) {
          inCombat = true;
        } else {
          ship.setSpace(space);
          ship.moveOnPath(nodes.slice(0, 1));
        }
      } else {
        if(space.hasObject("pirate")) {
          var pirates = space.getObjects("pirate");
          for(pirate in pirates) {
            cast(pirate, Pirate).takeDamage(ship.attack);
          }
          ship.step(true, false);
        } else {
          ship.setSpace(space);
          ship.moveOnPath(nodes.slice(0, 1));
          ship.step(true, true);
        }
      }
    }

    if(turnTaken) pulse();
  }

  public function modEnergy(system:String, amount:Int):Bool
  {
    switch(system) {
      case "weapons":
        return ship.setStat(ship.weaponStat, ship.weaponStat.setting + amount, !inCombat);
      case "shields":
        return ship.setStat(ship.shieldStat, ship.shieldStat.setting + amount, !inCombat);
      case "engines":
        return ship.setStat(ship.engineStat, ship.engineStat.setting + amount, !inCombat);
      default:
    }
    return false;
  }

  public function checkLocked():Void
  {
    var foundPirate = false;
    var sector:Sector = cast(HXP.scene, Sector);
    sector.grid.each(function(s:Space, i:Int, j:Int):Void {
      if(!s.explored) {
        s.locked = false;
        for(u in i-1...i+2) {
          for(v in j-1...j+2) {
            var nayb = sector.grid.get(u, v);
            if(nayb != null && nayb.hasObject("pirate")) {
              s.locked = true;
              foundPirate = true;
            }
          }
        }
        s.updateGraphic();
      }
    });
    inCombat = foundPirate;
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
      checkLocked();
    }
    updateMenu();
    turnNumber++;
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
    var sector:Sector = cast(HXP.scene, Sector);
    var pirates:Array<Pirate> = [];

    sector.getType("pirate", pirates);
    pirates.sort(function(a:Pirate, b:Pirate):Int {
      return a.space.manhattan(ship.space) - b.space.manhattan(ship.space);
    });

    for(pirate in pirates) {
      if(!pirate.dead) {
        if(pirate.space.manhattan(ship.space) == 1) {
          ship.takeDamage(pirate.attack);
        } else {
          pirate.move();
        }
      }
    }
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
}
