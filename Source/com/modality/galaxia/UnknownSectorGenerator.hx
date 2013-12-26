package com.modality.galaxia;

import com.modality.aug.AugRandom;

class UnknownSectorGenerator extends SectorGenerator
{
  public override function baseSquare():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 65,
      SpaceType.Star => 25,
      SpaceType.Planet => 10
    ]);
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 5,
      SpaceHappening.Item => 35,
      SpaceHappening.Hostile => 60
    ]);
  }

  public override function fillSpace(space:Space, what:SpaceHappening):Void
  {
  }
}


