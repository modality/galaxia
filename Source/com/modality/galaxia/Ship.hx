package com.modality.galaxia;

import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.MultiVarTween;

import com.modality.aug.Base;
import com.modality.aug.Node;

class Ship extends Base
{
  public var movePath:Array<Node>;
  public var movingOnPath:Bool;

  public var attack(get,null):Int;
  public var fuel:Int;
  public var shields:Int;
  public var maxShields:Int;
  public var hull:Int;
  public var maxHull:Int;

  public var space:Space;

  public function new()
  {
    super();
    type = "player";

    fuel = 20;
    maxShields = 3;
    shields = maxShields;

    maxHull = 3;
    hull = maxHull;
    
    movingOnPath = false;
    graphic = new Image(Assets.SPACESHIP);
    layer = Constants.ENCOUNTER_LAYER;
  }

  public override function added():Void
  {
    if(space != null) {
      x = space.x;
      y = space.y;
    }
  }

  public function takeDamage(howMuch:Int):Void
  {
    if(howMuch > shields) {
      hull -= (howMuch - shields);
      shields = 0;
    } else {
      shields -= howMuch;
    }
  }

  public function step(doFuel:Bool):Void
  {
    if(doFuel) {
      fuel -= 1;
      if(fuel <= 0) fuel = 0;
    }
  }

  public function setSpace(_space:Space):Void
  {
    if(space != null) {
      space.objects.remove(this);
    }
    space = _space;
    space.objects.push(this);
  }

  public function moveOnPath(nodes:Array<Node>):Void
  {
    movePath = nodes;
    nextMove();
  }

  public function nextMove():Void
  {
    if(movePath.length == 0) return;

    var target:Node = movePath.shift();
    var mvt:MultiVarTween = new MultiVarTween(function(o:Dynamic):Void {
      nextMove();
    }, TweenType.OneShot);
    mvt.tween(this, {
      "x": target.x * Constants.BLOCK_W + Constants.GRID_X,
      "y": target.y * Constants.BLOCK_H + Constants.GRID_Y
    }, 2);
    addTween(mvt, true);
  }

  private function get_attack():Int
  {
    return 1;
  }
}
