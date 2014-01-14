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

  public var freeEnergy:Int;
  public var reservedEnergy:Int;
  public var totalEnergy:Int;
  public var energyXferRate:Int;

  public var attack(get,null):Float;
  public var weaponStat:ShipSystem;
  /*
  public var weaponEnergy:Int;
  public var weaponEnergyCap:Int;
  public var weaponEnergySetting:Int;
  */

  public var fuel:Float;
  public var fuelUse(get, null):Float;
  public var damageEvasion(get, null):Float;
  public var engineStat:ShipSystem;
  /*
  public var engineEnergy:Int;
  public var engineEnergyCap:Int;
  public var engineEnergySetting:Int;
  */

  public var shields:Float;
  public var maxShields:Int;
  public var shieldRegen(get, null):Float;
  public var shieldStat:ShipSystem;
  /*
  public var shieldEnergy:Int;
  public var shieldEnergyCap:Int;
  public var shieldEnergySetting:Int;
  */

  public var hull:Float;
  public var maxHull:Int;

  public function new()
  {
    super();

    freeEnergy = 1;
    reservedEnergy = 0;
    totalEnergy = 4;
    energyXferRate = 1;

    weaponStat = new ShipSystem(1, 2, 1);

    fuel = 20;
    engineStat = new ShipSystem(1, 2, 1);

    maxShields = 10;
    shields = maxShields;
    shieldStat = new ShipSystem(1, 2 ,1);

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
    shields = HXP.round(shields, 1);
  }

  public function setStat(stat:ShipSystem, setting:Int, immediate:Bool):Bool
  {

    if(setting > stat.cap) return false;
    if(setting < 0) return false;
    if(setting == stat.setting) return false;

    var delta = setting - stat.setting;
    if(delta > 0) {
      if(delta > freeEnergy) return false;
      freeEnergy -= delta;
      stat.setting = setting;
      if(immediate) {
        stat.energy = setting;
      } else {
        reservedEnergy += delta;
      }
      return true;
    } else if(delta < 0) {
      if(setting < 0) return false;
      freeEnergy -= delta;
      stat.setting = setting; 
      if(immediate) {
        stat.energy = setting;
      }
      return true;
    }
    return false;
  }

  public function step(doEnergy:Bool, doFuel:Bool):Void
  {
    if(doEnergy) {
      pushEnergy();
      pullEnergy();
    }

    shields += shieldRegen;
    if(shields > maxShields) shields = maxShields;
    shields = HXP.round(shields, 1);

    if(doFuel) {
      fuel -= fuelUse;
      if(fuel <= 0) fuel = 0;
    }
    fuel = HXP.round(fuel, 1);
  }

  public function pushEnergy():Void
  {
    if(freeEnergy > 0) {
      var shieldDelta:Int = shieldStat.setting - shieldStat.energy,
          engineDelta:Int = engineStat.setting - engineStat.energy,
          weaponDelta:Int = weaponStat.setting - weaponStat.energy;
      var rate:Int;

      if(shieldDelta > 0 && shieldDelta > engineDelta && shieldDelta > weaponDelta) {
        rate = Std.int(Math.min(Math.min(shieldDelta, energyXferRate), freeEnergy));
        shieldStat.energy += rate;
        freeEnergy -= rate;
      } else if(engineDelta > 0 && engineDelta > weaponDelta) {
        rate = Std.int(Math.min(Math.min(engineDelta, energyXferRate), freeEnergy));
        engineStat.energy += rate;
        freeEnergy -= rate;
      } else if(weaponDelta > 0) {
        rate = Std.int(Math.min(Math.min(weaponDelta, energyXferRate), freeEnergy));
        weaponStat.energy += rate;
        freeEnergy -= rate;
      }
    }
  }

  public function pullEnergy():Void
  {
    var shieldDelta:Int = shieldStat.energy - shieldStat.setting,
        engineDelta:Int = engineStat.energy - engineStat.setting,
        weaponDelta:Int = weaponStat.energy - weaponStat.setting;
    
    if(shieldDelta > 0 && shieldDelta > engineDelta && shieldDelta > weaponDelta) {
      var rate = Std.int(Math.min(shieldDelta, energyXferRate));
      shieldStat.energy -= rate;
      freeEnergy += rate;
    } else if(engineDelta > 0 && engineDelta > weaponDelta) {
      var rate = Std.int(Math.min(engineDelta, energyXferRate));
      engineStat.energy -= rate;
      freeEnergy += rate;
    } else if(weaponDelta > 0) {
      var rate = Std.int(Math.min(weaponDelta, energyXferRate));
      weaponStat.energy -= rate;
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
    if(weaponStat.energy == 0) return 0;
    return HXP.round(1 + ((weaponStat.energy - 1) * 0.2), 1);
  }

  private function get_fuelUse():Float
  {
    return HXP.round(Math.max(0, 1 - (engineStat.energy * 0.1)), 1);
  }

  private function get_damageEvasion():Float
  {
    return HXP.round(engineStat.energy * 0.1, 1);
  }

  private function get_shieldRegen():Float
  {
    return HXP.round(shieldStat.energy * 0.2, 1);
  }
}
