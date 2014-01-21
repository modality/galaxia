package com.modality.galaxia;

import flash.display.BitmapData;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.utils.Ease;

import com.modality.aug.AStar;
import com.modality.aug.Node;
import com.modality.aug.Base;

class Pirate extends Base
{
  public var turnUncovered:Int;
  public var moved:Bool;
  public var attack:Int;
  public var health:Int;
  public var maxHealth:Int;

  public var emitter:Emitter;
  public var emitter_entity:Entity;

  public var sector:Sector;
  public var space:Space;

  public function new(_atk:Int, _hp:Int, _sector:Sector, _space:Space)
  {
    super();
    attack = _atk;
    health = _hp;
    maxHealth = _hp;
    sector = _sector;
    space = _space;
    turnUncovered = Game.instance.turnNumber;
    type = "pirate";
    layer = Constants.ENCOUNTER_LAYER;
    graphic = new Image(Assets.PIRATE_ICON);

    x = space.x;
    y = space.y;

    var bmd:BitmapData = new BitmapData(5, 5, false, 0xFFFFFF);
    emitter = new Emitter(bmd, 5, 5);
    emitter.newType("damage", [0]);
    emitter.setAlpha("damage", 1, 0.5);
    emitter.setColor("damage", 0xFFFF00, 0xCC0000);
    emitter.setMotion("damage", 0, 20, 5, 360, 10, 5);
    
    emitter.newType("smoke", [0]);
    emitter.setAlpha("smoke", 1, 0.8);
    emitter.setColor("smoke", 0xFFFFFF, 0x666666);
    emitter.setMotion("smoke", 0, 10, 7, 360, 5, 7);
    sector.add(this);
  }

  public function takeDamage(howMuch:Int):Void
  {
    var s:Sector = cast(HXP.scene, Sector);
    health -= howMuch;
    if(health <= 0) {
      Game.instance.log("You destroyed the pirate!");
      Game.instance.addItem(Generator.pirateReward());
      dead = true;
      destroy();
    } else {
      damage();
    }
  }

  public override function added():Void
  {
    super.added();
    emitter_entity = HXP.scene.addGraphic(emitter);
    emitter_entity.layer = 0;
    scene.add(emitter_entity);
  }

  public override function removed():Void
  {
    scene.remove(emitter_entity);
    super.removed();
  }

  public function damage():Void
  {
    for(i in 0...10) {
      emitter.emit("smoke", x+18, y+18);
      emitter.emit("damage", x+18, y+18);
    }
  }

  public function destroy():Void
  {
    damage();
    var vt = new VarTween(null, TweenType.OneShot);
    vt.tween(cast(this.graphic, Image), "alpha", 0, 7, Ease.sineInOut);
    addTween(vt, true);
    addTween(new Alarm(9,  function(o:Dynamic):Void {
      space.objects.remove(this);
      sector.remove(this);
    }, TweenType.OneShot),true);
  }

  public function move():Bool
  {
    var e:AStar = new AStar();
    e.generateMap(sector.grid.width, sector.grid.height);
    e.eachNode(function(n:Node):Void {
      if(n.x == Game.player.space.x_index && n.y == Game.player.space.y_index) {
        n.setTypeByText("END_NODE");
      } else if(n.x == space.x_index && n.y == space.y_index) {
        n.setTypeByText("START_NODE");
      } else if(!sector.grid.get(n.x, n.y).explored || sector.grid.get(n.x, n.y).hasObject("pirate")) {
        n.setTypeByText("BREAK_NODE");
      }
    });
    var nodes:Array<Node> = e.getPath();
    if(nodes.length > 0) {
      var target:Node = nodes.shift();
      var mvt:MultiVarTween = new MultiVarTween(null, TweenType.OneShot);
      mvt.tween(this, {
        "x": target.x * Constants.BLOCK_W + Constants.GRID_X,
        "y": target.y * Constants.BLOCK_H + Constants.GRID_Y
      }, 2);
      addTween(mvt, true);
      space.objects.remove(this);
      space = sector.grid.get(target.x, target.y);
      space.objects.push(this);
    } else {
      return false;
    }
    return true;
  }
}
