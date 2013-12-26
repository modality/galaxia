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
  }
}

