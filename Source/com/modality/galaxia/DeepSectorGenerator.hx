package com.modality.galaxia;

import com.modality.aug.AugRandom;

class DeepSectorGenerator extends SectorGenerator
{
  public override function baseSquare():SpaceType
  {
    return AugRandom.weightedChoice([
      SpaceType.Star => 55,
      SpaceType.Planet => 45
    ]);
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    return SpaceHappening.Nothing;
  }

  public override function fillSpace(space:Space, what:SpaceHappening):Void
  {
  }
}


