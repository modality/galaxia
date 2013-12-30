package com.modality.galaxia;

import com.modality.aug.AugRandom;

class InnerSectorGenerator extends SectorGenerator
{
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
    switch(spaceType) {
      case Voidness:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 50,
          SpaceHappening.Friendly => 25,
          SpaceHappening.Hostile => 25
        ]);
      case Planet:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 20,
          SpaceHappening.Friendly => 25,
          SpaceHappening.Quest => 25,
          SpaceHappening.Hostile => 25
        ]);
      case Star:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 30,
          SpaceHappening.Friendly => 25,
          SpaceHappening.Hostile => 25,
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
          space.item = new Item(good, AugRandom.range(4, 10));
        } else {
          space.item = new Item(good, AugRandom.range(3, 6));
        }
      case Friendly:
        if(space.spaceType == SpaceType.Planet) {
          space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
            EncounterType.Librarian => 40,
            EncounterType.Trader => 60
          ]));
        } else {
          space.encounter = Generator.generateEncounter(EncounterType.Trader);
        }
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
