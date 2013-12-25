package com.modality.galaxia;

import com.modality.aug.AugRandom;

class Generator
{
  public static var sector_types:Array<String> = ["Deep Core", "Core", "Inner Rim", "Outer Rim", "Unknown"];

  public static var good_1:Array<String> = ["Amusing", "Assorted", "Battle", "Black", "Blue", "Charm", "Data", "Delightful", "Dream", "Eyeball", "Fire", "Flat", "Flux", "Fungus", "Gas", "God", "Grow", "Guardian", "Harmony", "Holo", "Important", "Jeweled", "Laser", "Lovely", "Mineral", "Nutrient", "Parasitic", "Passion", "Phase", "Planetary", "Psychic", "Red", "Screech", "Shimmer", "Singing", "Whining"];
  public static var good_2:Array<String> = ["Ales", "Babies", "Balls", "Baubles", "Beetles", "Bubbles", "Chews", "Cloth", "Cones", "Cookers", "Crystals", "Cubes", "Cylinders", "Devices", "Drones", "Eggs", "Enzymes", "Furs", "Gems", "Goos", "Grids", "Harps", "Inductors", "Isotopes", "Juices", "Jumpers", "Keys", "Masks", "Orbs", "Pearls", "Pets", "Pods", "Probes", "Pumps", "Pyramids", "Rings", "Rods", "Scanners", "Secrets", "Slugs", "Spices", "Stones", "Tasties", "Teleporters", "Things", "Transmitters", "Vids"];

  public static var artifact:Array<String> = ["Dodecahedron", "Ellipsoid", "Hypercube", "Tesseract"];

  public static var planet_common:Array<String> = ["Rocky Planet", "Crater Planet", "Hot Planet", "Arid Planet", "Asteroid Belt", "Gas Giant", "Ring Giant", "Ice Planet", "Lava Planet", "Dwarf Planet", "Sea Planet"];
  public static var planet_rare:Array<String> = ["Crystal Planet", "Jungle World", "Spice World", "Ruined World", "Designer World", "Casino World", "Vacation World", "Galactic Bistro"];

  public static var star_common:Array<String> = ["Brown Dwarf", "Red Dwarf", "White Dwarf", "Yellow Star", "Blue Giant", "Red Giant"];
  public static var star_rare:Array<String> = ["Quasar", "Pulsar", "Magnetar", "Planetary Nebula", "Diffuse Nebula", "Exploded Nebula", "Supernova"];

  public static var sector_1:Array<String> = ["Alhazen", "Fazari", "Khwarizmi", "Biruni", "Khujandi", "Ptolemy", "Gautama", "Bhaskara", "Madhava", "Aryabhata", "Kepler", "Cassini", "Nebra", "Barnard", "Nabonassar", "Messier", "Verrier", "Chandraskhar", "Sagan", "Hypatia"];
  public static var sector_2:Array<String> = ["Reach", "Verge", "Cluster", "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"];

  public static var commonGood:Item;
  public static var uncommonGood:Item;
  public static var rareGood:Item;

  public static function initItems():Void
  {
    commonGood = new Item(generateItem(), 1);

    do {
      uncommonGood = new Item(generateItem(), 1);
    } while(uncommonGood.name == commonGood.name);

    do {
      rareGood = new Item(generateItem(), 1);
    } while(rareGood.name == commonGood.name || rareGood.name == uncommonGood.name);
  }

  public static function generateItem():String
  {
    return good_1[Std.random(good_1.length)] + " " + good_2[Std.random(good_2.length)];
  }

  public static function generateSectorName():String
  {
    return sector_1[Std.random(sector_1.length)] + " " + sector_2[Std.random(sector_2.length)];
  }

  public static function getBaseSquare(sectorType:SectorType):SpaceType
  {
    switch(sectorType) {
      case DeepCore:
        return AugRandom.weightedChoice([
          SpaceType.Star => 55,
          SpaceType.Planet => 45
        ]);
      case Core:
        return AugRandom.weightedChoice([
          SpaceType.Voidness => 20,
          SpaceType.Star => 40,
          SpaceType.Planet => 40
        ]);
      case InnerRim:
        return AugRandom.weightedChoice([
          SpaceType.Voidness => 30,
          SpaceType.Star => 35,
          SpaceType.Planet => 35
        ]);
      case OuterRim:
        return AugRandom.weightedChoice([
          SpaceType.Voidness => 45,
          SpaceType.Star => 30,
          SpaceType.Planet => 25
        ]);
      case Unknown:
        return AugRandom.weightedChoice([
          SpaceType.Voidness => 65,
          SpaceType.Star => 25,
          SpaceType.Planet => 10
        ]);
    }
    return SpaceType.Voidness;
  }

  public static function spaceHappening(spaceType:SpaceType, sectorType:SectorType):SpaceHappening
  {
    switch(sectorType) {
      case DeepCore:
        return SpaceHappening.Nothing;
      case Core:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 15,
          SpaceHappening.Friendly => 40,
          SpaceHappening.Quest => 40
        ]);
      case InnerRim:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 20,
          SpaceHappening.Friendly => 25,
          SpaceHappening.Quest => 25,
          SpaceHappening.Hostile => 25
        ]);
      case OuterRim:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 25,
          SpaceHappening.Friendly => 15,
          SpaceHappening.Quest => 15,
          SpaceHappening.Hostile => 40
        ]);
      case Unknown:
        return AugRandom.weightedChoice([
          SpaceHappening.Nothing => 5,
          SpaceHappening.Item => 35,
          SpaceHappening.Hostile => 60
        ]);
    }
    return SpaceHappening.Nothing;
  }

  public static function createSpace(sectorType:SectorType):Space
  {
    var space:Space = new Space();
    space.spaceType = getBaseSquare(sectorType);
    fillCoreSpace(space, spaceHappening(space.spaceType, sectorType));
    return space;
  }

  public static function fillCoreSpace(space:Space, what:SpaceHappening):Void
  {
    switch(what) {
      case Nothing:
        return;
      case Item:
        space.item = new Item(commonGood.name, AugRandom.range(1, 3));
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

  public static function generateSectorSpaces(sectorType:SectorType):Array<Space>
  {
    var spaces:Array<Space> = new Array<Space>();

    do {
      for(i in 0...25) {
        spaces.push(createSpace(sectorType));
      }
    } while(!validSector(spaces));

    return spaces;
  }


  public static function validSector(spaces:Array<Space>):Bool
  {
    if(spaces.length < 25) return false;
    return true;
  }
}
