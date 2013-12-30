package com.modality.galaxia;

import com.modality.aug.AugRandom;

class CoreSectorGenerator extends SectorGenerator
{
  public override function validSector(spaces:Array<Space>):Bool {
    var trd:Int, tfm:Int, ast:Int, sci:Int, lib:Int, pir:Int, voids:Int;

    trd = 0; tfm = 0; ast = 0; sci = 0; lib = 0; pir = 0; voids = 0;

    for(space in spaces) {
      if(space.spaceType == SpaceType.Voidness) {
        voids++;
      }
      if(space.encounter != null) {
        switch(space.encounter.encounterType) {
          case Trader: trd++;
          case Terraformer: tfm++;
          case Astronomer: ast++;
          case Scientist: sci++;
          case Librarian: lib++;
          case Pirate: pir++;
        }
      }
    }

    if(voids < 3) return false;
    if(trd < 2 || trd > 6) return false;
    if(tfm < 1 || tfm > 5) return false;
    if(ast < 1 || ast > 5) return false;
    if(sci < 1 || sci > 5) return false;
    if(lib < 2 || lib > 6) return false;
    return true;
  }

  public override function baseSquare():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 20,
      SpaceType.Star => 40,
      SpaceType.Planet => 40
    ]);
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    if(spaceType == SpaceType.Voidness) return SpaceHappening.Nothing;
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 25,
      SpaceHappening.Item => 15,
      SpaceHappening.Friendly => 30,
      SpaceHappening.Quest => 30
    ]);
  }

  public override function fillSpace(space:Space, what:SpaceHappening):Void
  {
    switch(what) {
      case Nothing:
        return;
      case Item:
        var good:String = AugRandom.weightedChoice([
          Generator.commonGood.name => 50,
          Generator.uncommonGood.name => 50,
        ]);
        
        if(good == Generator.commonGood.name) {
          space.item = new Item(good, AugRandom.range(2, 5));
        } else {
          space.item = new Item(good, AugRandom.range(1, 3));
        }
      case Friendly:
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Librarian => 50,
          EncounterType.Trader => 50
        ]));
      case Hostile:
        space.encounter = new Encounter(EncounterType.Pirate, "Pirate", "Your ship is beset by pirates!");
      case Quest:
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Astronomer => 40,
          EncounterType.Terraformer => 30,
          EncounterType.Scientist => 30
        ]));
    }
  }
}
