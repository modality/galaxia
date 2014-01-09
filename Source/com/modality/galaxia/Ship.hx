package com.modality.galaxia;

import com.haxepunk.Tween;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.MultiVarTween;

import com.modality.aug.Base;
import com.modality.aug.Node;

class Ship extends Base
{
  public var movePath:Array<Node>;
  public var movingOnPath:Bool;

  public var freeEnergy:Int;
  public var totalEnergy:Int;
  public var energyXferRate:Int;

  public var attack(get,null):Float;
  public var weaponEnergy:Int;
  public var weaponEnergyCap:Int;
  public var weaponEnergySetting:Int;

  public var fuel:Float;
  public var fuelUse(get, null):Float;
  public var damageEvasion(get, null):Float;
  public var engineEnergy:Int;
  public var engineEnergyCap:Int;
  public var engineEnergySetting:Int;

  public var shields:Float;
  public var maxShields:Int;
  public var shieldRegen(get, null):Float;
  public var shieldEnergy:Int;
  public var shieldEnergyCap:Int;
  public var shieldEnergySetting:Int;

  public var hull:Float;
  public var maxHull:Int;

  public function new()
  {
    super();
    freeEnergy = 1;
    totalEnergy = 4;
    energyXferRate = 1;

    weaponEnergy = 1;
    weaponEnergyCap = 2;
    weaponEnergySetting = weaponEnergy;

    fuel = 20;
    engineEnergy = 1;
    engineEnergyCap = 2;
    engineEnergySetting = engineEnergy;

    maxShields = 10;
    shields = maxShields;
    shieldEnergy = 1;
    shieldEnergyCap = 2;
    shieldEnergySetting = shieldEnergy;

    maxHull = 10;
    hull = maxHull;
    
    movingOnPath = false;
    graphic = new Image(Assets.SPACESHIP);
    layer = Constants.ENCOUNTER_LAYER;
  }

  public function takeDamage(howMuch:Float):Void
  {
    howMuch -= damageEvasion;
    if(howMuch > shields) {
      hull -= (howMuch - shields);
      shields = 0;
    } else {
      shields -= howMuch;
    }
  }

  public function stepCombat():Void
  {
    pushEnergy();
    pullEnergy();
    shields += shieldRegen;
    if(shields > maxShields) shields = maxShields;
  }

  public function stepExplore():Void
  {
    shields += shieldRegen;
    if(shields > maxShields) shields = maxShields;

    fuel -= fuelUse;
    if(fuel <= 0) fuel = 0;
  }

  public function pushEnergy():Void
  {
    if(freeEnergy > 0) {
      var shieldDelta:Int = shieldEnergySetting - shieldEnergy,
          engineDelta:Int = engineEnergySetting - engineEnergy,
          weaponDelta:Int = weaponEnergySetting - weaponEnergy;

      if(shieldDelta > 0 && shieldDelta > engineDelta && shieldDelta > weaponDelta) {
        var rate = Std.int(Math.min(Math.min(shieldDelta, energyXferRate), freeEnergy));
        shieldEnergy += rate;
        freeEnergy -= rate;
      } else if(engineDelta > 0 && engineDelta > weaponDelta) {
        var rate = Std.int(Math.min(Math.min(engineDelta, energyXferRate), freeEnergy));
        engineEnergy += rate;
        freeEnergy -= rate;
      } else if(weaponDelta > 0) {
        var rate = Std.int(Math.min(Math.min(weaponDelta, energyXferRate), freeEnergy));
        weaponEnergy += rate;
        freeEnergy -= rate;
      }
    }
  }

  public function pullEnergy():Void
  {
    var shieldDelta:Int = shieldEnergy - shieldEnergySetting,
        engineDelta:Int = engineEnergy - engineEnergySetting,
        weaponDelta:Int = weaponEnergy - weaponEnergySetting;
    
    if(shieldDelta > 0 && shieldDelta > engineDelta && shieldDelta > weaponDelta) {
      var rate = Std.int(Math.min(shieldDelta, energyXferRate));
      shieldEnergy -= rate;
      freeEnergy += rate;
    } else if(engineDelta > 0 && engineDelta > weaponDelta) {
      var rate = Std.int(Math.min(engineDelta, energyXferRate));
      engineEnergy -= rate;
      freeEnergy += rate;
    } else if(weaponDelta > 0) {
      var rate = Std.int(Math.min(weaponDelta, energyXferRate));
      weaponEnergy -= rate;
      freeEnergy += rate;
    }
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

  private function get_attack():Float
  {
    if(weaponEnergy == 0) return 0;
    return 1 + ((weaponEnergy - 1) * 0.2);
  }

  private function get_fuelUse():Float
  {
    return Math.max(0, 1 - (engineEnergy * 0.1));
  }

  private function get_damageEvasion():Float
  {
    return engineEnergy * 0.1;
  }

  private function get_shieldRegen():Float
  {
    return shieldEnergy * 0.2;
  }
}
