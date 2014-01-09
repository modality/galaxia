package com.modality.galaxia;

import flash.display.BitmapData;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.tweens.motion.LinearPath;
import com.haxepunk.utils.Ease;

import com.modality.aug.Base;

class Pirate extends Encounter
{
  public var turnUncovered:Int;
  public var attack:Float;
  public var health:Float;
  public var maxHealth:Int;
  public var emitter:Emitter;
  public var emitter_entity:Entity;

  public function new(_atk:Int, _hp:Int)
  {
    super(EncounterType.Pirate, "Pirate", "Your ship is beset by pirates!");
    attack = _atk;
    health = _hp;
    maxHealth = _hp;

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
  }
  
  public function takeDamage(howMuch:Float):Void
  {
    var s:Sector = cast(HXP.scene, Sector);
    health -= howMuch;
    if(health <= 0) {
      s.removeEncounter(this);
      Game.instance.addItem(Generator.pirateReward());
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
      scene.remove(this);
    }, TweenType.OneShot),true);
  }
}
