package com.modality.galaxia;

import com.modality.aug.AugRandom;

class OuterSectorGenerator extends SectorGenerator
{
  public override function baseSquare():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 45,
      SpaceType.Star => 30,
      SpaceType.Planet => 25
    ]);
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 5,
      SpaceHappening.Item => 25,
      SpaceHappening.Friendly => 15,
      SpaceHappening.Quest => 15,
      SpaceHappening.Hostile => 40
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
        space.encounter = Generator.generateEncounter(EncounterType.Trader);
      case Quest:
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Terraformer => 50,
          EncounterType.Scientist => 50
        ]));
      case Hostile:
        //var pirate:Pirate = new Pirate(2, 5);
        //space.encounter = pirate;
    }
  }
}
