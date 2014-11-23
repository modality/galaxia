package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;

import com.modality.aug.Base;
import com.modality.aug.AStar;
import com.modality.aug.Node;
import com.modality.aug.Grid;

class Game
{
  public static var instance:Game;
  public static var player:Ship;
  public static var economy:SpaceEconomy;
  public static var log_gfx:Text;

  public var turnNumber:Int;
  public var sm:SectorMenu;
  public var inCombat:Bool;
  public var inventory:Array<Item>;
  public var ship:Ship;
  public var _economy:SpaceEconomy;
  public var _log:Text;

  public var currentPower:Power;
  public var targets:Array<Space>;

  public function new()
  {
    Game.instance = this;
    Generator.init();

    turnNumber = 0;
    inCombat = false;

    inventory = [];
    targets = [];

    _log = new Text("Welcome to GALAXIA!", 0, 0, 300, 224, {
      font: Assets.FONT,
      color: 0xFFFFFF,
      size: Constants.FONT_SIZE_XS,
      wordWrap: true,
    });

    ship = new Ship();
    _economy = new SpaceEconomy();

    Game.player = ship;
    Game.log_gfx = _log;
    Game.economy = _economy;
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
      log("You found "+_item.amount+" fuel.");
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
      log("You found "+_item.amount+" "+_item.name+".");
    }
  }

  public function moveTo(space:Space):Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
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
        economy.addEconomy(space.economyValue);
        economy.addScience(space.scienceValue);
        ship.step(true);
        turnTaken = true;
        if(space.encounter != null && space.encounter.encounterType == EncounterType.Pirate) {
          log("Your ship is beset by pirates!");
          inCombat = true;
          nodes.pop();
        }
        sector.updateRoutes();
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
        economy.addEconomy(space.economyValue);
        economy.addScience(space.scienceValue);
        ship.step(true);
        if(space.encounter != null && space.encounter.encounterType == EncounterType.Pirate) {
          log("Your ship is beset by pirates!");
          inCombat = true;
        } else {
          ship.setSpace(space);
          ship.moveOnPath(nodes.slice(0, 1));
        }
        sector.updateRoutes();
      } else {
        if(space.hasObject("pirate")) {
          var pirates = space.getObjects("pirate");
          for(pirate in pirates) {
            log("You attack the pirate for "+ship.attack+" damage.");
            cast(pirate, Pirate).takeDamage(ship.attack);
          }
          ship.step(false);
        } else {
          ship.setSpace(space);
          ship.moveOnPath(nodes.slice(0, 1));
          ship.step(true);
        }
      }
    }

    if(turnTaken) pulse();
  }

  public function selectPower(power:Power):Void
  {
    if(!power.ready) return;
    if(power.cost > ship.fuel) return;

    currentPower = power;
    targets = [];

    if(power.targetSelf && !power.targetOther) {
      executePower();
    }

    if(power.targetOther) {
      pickTargets(power);
    }
  }

  public function pickTargets(power:Power):Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
    currentPower = power;
    targets = [];
    sector.showTargets(ship.space, currentPower);
    if(power.targetCount == 1) {
      log("Select a target...");
    } else {
      log("Select "+power.targetCount+" targets...");
    }
  }

  public function addTarget(space:Space):Void
  {
    targets.push(space);
    if(targets.length >= currentPower.targetCount) {
      executePower();
    }
  }

  public function cancelPower():Void
  {
    var sector:Sector = cast(HXP.scene, Sector);
    sector.clearTargets();
    currentPower = null;
    targets = [];
  }
  
  public function executePower():Void
  {
    if(currentPower == null) return;

    var sector:Sector = cast(HXP.scene, Sector);
    sector.clearTargets();

    currentPower.use(ship, targets);
    ship.fuel -= currentPower.cost;

    log("You used "+currentPower.title+"!");

    if(!currentPower.immediate) {
      pulse();
    } else {
      updateMenu();
    }

    currentPower = null;
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
    for(power in ship.powers) {
      power.step();
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
    for(power in ship.powers) {
      power.updateGraphic();
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
          log("Your ship takes "+pirate.attack+" damage.");
        } else {
          if(pirate.move()) {
            return;
          } else {
            // do something else!
          }
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

  public function log(text:String):Void
  {
    _log.text = _log.text + "\n" + text;
    if(_log.height > 224) {
      _log.text = _log.text.split("\n").slice(-15).join("\n");
    }
  }
}
