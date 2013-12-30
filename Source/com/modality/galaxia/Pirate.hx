package com.modality.galaxia;

import flash.display.BitmapData;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Emitter;
import com.modality.aug.Base;

class Pirate extends Encounter
{
  public var turnUncovered:Int;
  public var attack:Int;
  public var health:Int;
  public var maxHealth:Int;
  public var emitter:Base;

  public function new(_atk:Int, _hp:Int)
  {
    super(EncounterType.Pirate, "Pirate", "Your ship is beset by pirates!");
    attack = _atk;
    health = _hp;
    maxHealth = _hp;

    var bmd:BitmapData = new BitmapData(5, 5, false, 0xFF0000);

    emitter = new Base();
    var e:Emitter = new Emitter(bmd, 40, 40);
    e.newType("explode", [0]);
    e.setMotion("explode", 0, 10, 4, 360, 25, 2);
    emitter.graphic = e;
    emitter.layer = 0;
  }
  
  public function takeDamage(howMuch:Int):Void
  {
    var s:Sector = cast(HXP.scene, Sector);
    health -= howMuch;
    if(health <= 0) {
      s.gameMenu.removeEncounter(this);
      s.remove(this);
    } else {
      var emi:EncounterMenuItem = s.gameMenu.getEncounter(this);
      if(emi != null) {
        emi.updateGraphic();
      }
    }
  }

  public override function added():Void
  {
    super.added();
    emitter.x = x;
    emitter.y = y;
    scene.add(emitter);
  }

  public override function removed():Void
  {
    super.removed();
    scene.remove(emitter);
  }

  public function explode():Void
  {
    trace("ASPLODE");
    cast(emitter.graphic, Emitter).emit("explode", 0, 0);
  }
}
