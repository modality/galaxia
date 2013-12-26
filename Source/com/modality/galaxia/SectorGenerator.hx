package com.modality.galaxia;

class SectorGenerator
{
  public function new() { }

  public static function createSectorSpaces(sectorType:SectorType):Array<Space> {
    var sg:SectorGenerator;
    var spaces:Array<Space> = new Array<Space>();

    switch(sectorType) {
      case DeepCore:
        sg = new DeepSectorGenerator();
      case Core:
        sg = new CoreSectorGenerator();
      case InnerRim:
        sg = new InnerSectorGenerator();
      case OuterRim:
        sg = new OuterSectorGenerator();
      case Unknown:
        sg = new UnknownSectorGenerator();
    }

    do {
      for(i in 0...(Constants.GRID_W * Constants.GRID_H)) {
        spaces.push(sg.createSpace());
      }
    } while(!sg.validSector(spaces));

    return spaces;
  }

  public function createSpace():Space {
    var space:Space = new Space();
    space.spaceType = baseSquare();
    fillSpace(space, spaceHappening(space.spaceType));
    return space;
  }
  public function validSector(spaces:Array<Space>):Bool {
    return true;
  }

  public function baseSquare():SpaceType { return null; }
  public function spaceHappening(spaceType:SpaceType):SpaceHappening { return null; }
  public function fillSpace(space:Space, what:SpaceHappening):Void { }
}
