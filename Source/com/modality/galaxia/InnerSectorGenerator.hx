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
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 5,
      SpaceHappening.Item => 20,
      SpaceHappening.Friendly => 25,
      SpaceHappening.Quest => 25,
      SpaceHappening.Hostile => 25
    ]);
  }

  public override function fillSpace(space:Space, what:SpaceHappening):Void
  {
  }
}
