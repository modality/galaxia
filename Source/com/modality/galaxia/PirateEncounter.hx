package com.modality.galaxia;

class PirateEncounter extends Encounter
{
  public var attack:Int;
  public var health:Int;

  public function new(_atk:Int, _hp:Int)
  {
    super(EncounterType.Pirate, "Pirate", "Your ship is beset by pirates!");
    attack = _atk;
    health = _hp;
  }

  public override function activate():Void
  {
    var sector:Sector = cast(scene, Sector);
    var spaces:Array<Space> = sector.grid.filter(function(s:Space, i:Int, j:Int):Bool {
      return s.encounter == this;
    });
    var p:Pirate = new Pirate(attack, health, sector, spaces[0]);
    spaces[0].objects.push(p);
  }
}

