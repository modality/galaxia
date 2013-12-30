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
    switch(spaceType) {
      case Voidness:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 80,
          SpaceHappening.Friendly => 20
        ]);
      case Planet:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 15,
          SpaceHappening.Friendly => 40,
          SpaceHappening.Quest => 40
        ]);
      case Star:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 60,
          SpaceHappening.Friendly => 20,
          SpaceHappening.Item => 20
        ]);
    }
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
        if(space.spaceType == SpaceType.Planet) {
          space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
            EncounterType.Librarian => 50,
            EncounterType.Trader => 50
          ]));
        } else {
          space.encounter = Generator.generateEncounter(EncounterType.Trader);
        }
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
