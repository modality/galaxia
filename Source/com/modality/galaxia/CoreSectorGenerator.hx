package com.modality.galaxia;

import com.modality.aug.AugRandom;

class CoreSectorGenerator extends SectorGenerator
{
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
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 5,
      SpaceHappening.Item => 15,
      SpaceHappening.Friendly => 40,
      SpaceHappening.Quest => 40
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
        Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Librarian => 50,
          EncounterType.Trader => 50
        ]));
      case Hostile:
        space.encounter = new Encounter(EncounterType.Pirate, "Pirate", "Your ship is beset by pirates!");
      case Quest:
        Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Astronomer => 40,
          EncounterType.Terraformer => 30,
          EncounterType.Scientist => 30
        ]));
    }
  }
}
