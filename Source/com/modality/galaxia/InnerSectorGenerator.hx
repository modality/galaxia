package com.modality.galaxia;

import com.modality.aug.AugRandom;

class InnerSectorGenerator extends SectorGenerator
{
  public override function validSector(spaces:Array<Space>):Bool {
    var trd:Int, tfm:Int, ast:Int, sci:Int, lib:Int, pir:Int;

    trd = 0; tfm = 0; ast = 0; sci = 0; lib = 0; pir = 0;

    for(space in spaces) {
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

    if(trd < 2 || trd > 5) return false;
    if(tfm < 1 || tfm > 4) return false;
    if(ast < 1 || ast > 4) return false;
    if(sci < 1 || sci > 4) return false;
    if(lib < 2 || lib > 5) return false;
    if(pir < 2 || pir > 8) return false;
    return true;
  }

  public override function baseSquare():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 30,
      SpaceType.Star => 35,
      SpaceType.Planet => 35
    ]);
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    if(spaceType == SpaceType.Voidness) return SpaceHappening.Nothing;
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 20,
      SpaceHappening.Item => 20,
      SpaceHappening.Friendly => 20,
      SpaceHappening.Quest => 15,
      SpaceHappening.Hostile => 25
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
          space.item = new Item(good, AugRandom.range(4, 10));
        } else {
          space.item = new Item(good, AugRandom.range(3, 6));
        }
      case Friendly:
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Librarian => 40,
          EncounterType.Trader => 60
        ]));
      case Quest:
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Astronomer => 20,
          EncounterType.Terraformer => 40,
          EncounterType.Scientist => 40
        ]));
      case Hostile:
        var pirate:Pirate = new Pirate(1, 3);
        space.encounter = pirate;
    }
  }
}
