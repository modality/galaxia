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
        space.item = new Item(Generator.commonGood.name, AugRandom.range(1, 3));
      case Friendly:
        var et:EncounterType = AugRandom.weightedChoice([
          EncounterType.Librarian => 50,
          EncounterType.Trader => 50
        ]);
        switch(et) {
          case Librarian:
            space.encounter = new Encounter(et, "You meet a Librarian, poring over ancient texts detailing artifacts");
          case Trader:
            space.encounter = new Encounter(et, "You meet a Trader, hawking his wares.");
          default:
        }
      case Hostile:
        space.encounter = new Encounter(EncounterType.Pirate, "Your ship is beset by pirates!");
      case Quest:
        var et:EncounterType = AugRandom.weightedChoice([
          EncounterType.Astronomer => 40,
          EncounterType.Terraformer => 30,
          EncounterType.Scientist => 30
        ]);
        switch(et) {
          case Astronomer:
            space.encounter = new Encounter(et, "You meet an Astronomer, busily mapping the stars.");
          case Terraformer:
            space.encounter = new Encounter(et, "You meet a Terraformer, planning the architecture of a new world.");
          case Scientist:
            space.encounter = new Encounter(et, "You meet a Scientist, researching alien compounds.");
          default:
        }
    }
  }
}
