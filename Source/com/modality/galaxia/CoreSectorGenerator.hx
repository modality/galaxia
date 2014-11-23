package com.modality.galaxia;

import com.modality.aug.AugRandom;

class CoreSectorGenerator extends SectorGenerator
{
  private var _spaces:Array<SpaceType>;

  public function new() {
    super();
    _spaces = new Array<SpaceType>();

    var numStars:Int = AugRandom.range(5, 8),
        numPlanets:Int = AugRandom.range(5, 8);

    for(i in 0...numStars) {
      _spaces.push(SpaceType.Star);
    }

    for(i in 0...numPlanets) {
      _spaces.push(SpaceType.Planet);
    }

    while(_spaces.length < (Constants.GRID_W * Constants.GRID_H)) {
      _spaces.push(SpaceType.Voidness);
    }
  }

  public override function validSector(spaces:Array<Space>):Bool {
    return true;
    var trd:Int, tfm:Int, ast:Int, sci:Int, lib:Int, pir:Int, voids:Int;

    trd = 0; tfm = 0; ast = 0; sci = 0; lib = 0; pir = 0; voids = 0;

    for(space in spaces) {
      if(space.spaceType == SpaceType.Voidness) {
        voids++;
      }
      if(space.encounter != null) {
        switch(space.encounter.encounterType) {
          case Trader: trd++;
          case Terraformer: tfm++;
          case Astronomer: ast++;
          case Scientist: sci++;
          case Librarian: lib++;
          case Pirate: pir++;
        }
      }
    }

    if(voids < 3) return false;
    if(trd < 2 || trd > 6) return false;
    if(tfm < 1 || tfm > 5) return false;
    if(ast < 1 || ast > 5) return false;
    if(sci < 1 || sci > 5) return false;
    if(lib < 2 || lib > 6) return false;
    return true;
  }

  public override function baseSquare():SpaceType
  {
    return _spaces.splice(AugRandom.range(0, _spaces.length), 1)[0];
    /*
    return AugRandom.weightedChoice([
      SpaceType.Voidness => 80,
      SpaceType.Star => 10,
      SpaceType.Planet => 10
    ]);
    */
  }

  public override function spaceHappening(spaceType:SpaceType):SpaceHappening
  {
    if(spaceType == SpaceType.Voidness) {
      return AugRandom.weightedChoice([
        SpaceHappening.Hostile => 20,
        SpaceHappening.Nothing => 80
      ]);
    }
    return AugRandom.weightedChoice([
      SpaceHappening.Nothing => 25,
      SpaceHappening.Item => 15,
      SpaceHappening.Friendly => 30,
      SpaceHappening.Quest => 30
    ]);
  }

  public override function fillSpace(space:Space, what:SpaceHappening):Void
  {
    switch(space.spaceType) {
      case SpaceType.Voidness:
        space.scienceValue = 1;
        space.economyValue = 1;
      case SpaceType.Star:
        space.scienceValue = 3;
        space.economyValue = 1;
      case SpaceType.Planet:
        space.scienceValue = 1;
        space.economyValue = 3;
      default:
    }

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
        /*
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Librarian => 50,
          EncounterType.Trader => 50
        ]));
        */
      case Hostile:
        space.encounter = new PirateEncounter(1, 2);
      case Quest:
        /*
        space.encounter = Generator.generateEncounter(AugRandom.weightedChoice([
          EncounterType.Astronomer => 40,
          EncounterType.Terraformer => 30,
          EncounterType.Scientist => 30
        ]));
        */
    }
  }
}
