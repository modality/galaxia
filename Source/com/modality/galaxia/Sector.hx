package com.modality.galaxia;

import flash.events.Event;
import com.haxepunk.HXP;
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
  public var log:Base;
  public var beacons:Array<Beacon>;
  public var stationSpace:Space;

  public var targeting:Bool;
  public var targetSquares:Array<Base>;

  public function new(_st:SectorType)
  {
    super();
    sectorType = _st;
    nebulaMapped = false;
    name = Generator.generateSectorName();
    gameMenu = new GameMenu();
    targeting = false;
    targetSquares = [];
    beacons = [];

    add(gameMenu);

    var ent:TextBase = new TextBase("sector "+name.toUpperCase());
    ent.text.size = Constants.FONT_SIZE_LG;
    ent.text.font = Assets.FONT_ITALIC;
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

    stationSpace = voids.splice(AugRandom.range(0, voids.length), 1)[0];
    stationSpace.spaceType = SpaceType.SpaceStation;
    stationSpace.explored = true;
    stationSpace.updateGraphic();
    Game.player.setSpace(stationSpace);

    log = new Base();
    log.graphic = Game.log_gfx;
    log.x = 0;
    log.y = 544;
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
    add(Game.player);
    placeBeacon(Game.player.space);
    add(log);
  }

  public override function update():Void
  {
    super.update();
    if(Input.mouseReleased) {
      var mouse_x = Input.mouseX * Constants.X_SCALE;
      var mouse_y = Input.mouseY * Constants.Y_SCALE;

      if(targeting) {
        var target:Base = cast(collidePoint("target", mouse_x, mouse_y), Base);
        if(target != null) {
          var i:Int = Std.parseInt(target.name.split("_")[0]);
          var j:Int = Std.parseInt(target.name.split("_")[1]);
          Game.instance.addTarget(grid.get(i, j));
        } else {
          Game.instance.cancelPower();
        }
      } else {
        var space:Space = cast(collidePoint("space", mouse_x, mouse_y), Space);
        if(space != null) {
          Game.instance.moveTo(space);
        }
        var power:Power = cast(collidePoint("power", mouse_x, mouse_y), Power);
        if(power != null) {
          Game.instance.selectPower(power);
        }
      }
    } else if (Input.pressed(Key.ESCAPE)) {
      Game.instance.goToMenu();
    } else if (Input.pressed(Key.F)) {
      grid.each(function(s:Space, i:Int, j:Int):Void {
        s.explore();
      });
    } else if (Input.pressed(Key.B)) {
      placeBeacon(Game.player.space);
    }
  }

  public function showTargets(origin:Space, power:Power):Void
  {
    targeting = true;
    var spaces:Array<Space> = grid.filter(function(s:Space, i:Int, j:Int) {
      if(s == origin) return power.targetSelf;
      return s.manhattan(origin) <= power.range;
    });

    for(s in spaces) {
      var t:Base = new Base();
      t.x = s.x;
      t.y = s.y;
      t.graphic = new Image(Assets.TARGET_SQUARE);
      t.setHitboxTo(t.graphic);
      t.layer = Constants.OVERLAY_LAYER;
      t.type = "target";
      t.name = s.x_index+"_"+s.y_index;

      targetSquares.push(t);
      add(t);
    }
  }

  public function clearTargets():Void
  {
    for(ts in targetSquares) {
      remove(ts);
    }
    targetSquares = [];
    targeting = false;
  }

  public function placeBeacon(space:Space):Bool
  {
    var updateBeacons:Array<Beacon> = [];

    if(space.hasObject("beacon")) {
      var b:Beacon = cast(space.getObject("beacon"), Beacon);
      if(b.line) {
        b.line = false;
        b.name = "node";
        updateBeacons.push(b);
      } else {
        return false;
      }
    } else {
      var main_b:Beacon = new Beacon(false, space);
      main_b.name = "node";
      main_b.x = space.x;
      main_b.y = space.y;
      space.objects.push(main_b);
      add(main_b);
      beacons.push(main_b);
      updateBeacons.push(main_b);
    }

    var addBeacons = function(naybs:Array<Space>):Void {
      for(nayb in naybs) {
        if(!nayb.hasObject("beacon")) {
          var b:Beacon = new Beacon(true, nayb);
          b.name = "route";
          b.x = nayb.x;
          b.y = nayb.y;
          nayb.objects.push(b);
          add(b);
          beacons.push(b);
          updateBeacons.push(b);
        } else {
          var b:Beacon = cast(nayb.getObject("beacon"), Beacon);
          updateBeacons.push(b);
          if(!b.line) {
            break;
          }
        }
        if(nayb.spaceType == SpaceType.Planet || nayb.spaceType == SpaceType.Star) {
          break;
        }
      }
    }

    addBeacons(space.grid.walk(space, "left"));
    addBeacons(space.grid.walk(space, "right"));
    addBeacons(space.grid.walk(space, "up"));
    addBeacons(space.grid.walk(space, "down"));

    updateRoutes();

    return true;
  }

  public function updateRoutes():Void
  {
    var leftToWalk:Array<Space> = [stationSpace];
    var activePlanets:Array<Space> = [];

    for(beacon in beacons) {
      beacon.activated = false;
      beacon.walked = false;
      beacon.horz = false;
      beacon.vert = false;
    }

    var connectedSpaces = function(naybs:Array<Space>):Array<Space> {
      for(i in 0...naybs.length) {
        var nayb = naybs[i];
        if(nayb.spaceType == SpaceType.Star) {
          return [];
        }
        if(!nayb.explored) {
          return [];
        }
        if(nayb.spaceType == SpaceType.Planet || nayb.hasObject("beacon", "node")) {
          if(nayb.hasObject("beacon", "node") && cast(nayb.getObject("beacon", "node"), Beacon).walked) {
            return [];
          }
          if(nayb.spaceType == SpaceType.Planet) {
            activePlanets.remove(nayb);
            activePlanets.push(nayb);
          }
          return naybs.slice(0, i+1);
        }
      }
      return [];
    }

    var activateSpace = function(space:Space, horz:Bool):Void {
      if(space.hasObject("beacon")) {
        var beacon = cast(space.getObject("beacon"), Beacon);
        beacon.activated = true;
        if(horz) { beacon.horz = true; }
        if(!horz) { beacon.vert = true; }
        if(beacon.name == "node" && !beacon.walked) {
          leftToWalk.push(space);
        }
      }
    }

    var activateSpaceHorz = function(space:Space):Void {
      activateSpace(space, true);
    }

    var activateSpaceVert = function(space:Space):Void {
      activateSpace(space, false);
    }

    while(leftToWalk.length > 0) {
      var walkFrom = leftToWalk.shift();
      if(walkFrom.hasObject("beacon", "node")) {
        cast(walkFrom.getObject("beacon", "node"), Beacon).walked = true;
      }

      connectedSpaces(walkFrom.grid.walk(walkFrom, "left")).map(activateSpaceHorz);
      connectedSpaces(walkFrom.grid.walk(walkFrom, "right")).map(activateSpaceHorz);
      connectedSpaces(walkFrom.grid.walk(walkFrom, "up")).map(activateSpaceVert);
      connectedSpaces(walkFrom.grid.walk(walkFrom, "down")).map(activateSpaceVert);
    }

    for(beacon in beacons) {
      beacon.updateGraphic();
    }

    Game.economy.planets = activePlanets.length;
    Game.economy.goods = 2;
    Game.economy.sectors = 1;
    gameMenu.updateGraphic();
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
