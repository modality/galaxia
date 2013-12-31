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

  public static var sector_1:Array<String> = ["Aglaonike", "Alhazen", "Fazari", "Khwarizmi", "Biruni", "Khujandi", "Ptolemy", "Gautama", "Bhaskara", "Madhava", "Aryabhata", "Kepler", "Cassini", "Nebra", "Barnard", "Nabonassar", "Messier", "Verrier", "Chandrasekhar", "Sagan", "Hypatia"];
  public static var sector_2:Array<String> = ["Reach", "Verge", "Cluster", "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"];

  public static var commonGood:Item;
  public static var uncommonGood:Item;
  public static var rareGood:Item;

  public static var sectorNames:Array<String>;

  public static function init():Void
  {
    sectorNames = new Array<String>();
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

  public static function pirateReward():Item
  {
    return AugRandom.weightedChoice([
      new Item(commonGood.name, 10) => 30,
      new Item(uncommonGood.name, 5) => 30,
      new Item("Fuel", 5) => 20,
      new Item("Fuel", 10) => 10
    ]);
  }

  public static function generateSectorName():String
  {
    var generatedName:Bool = false;
    var name:String = "";

    while(generatedName == false) {
      name = sector_1[Std.random(sector_1.length)] + " " + sector_2[Std.random(sector_2.length)];
      generatedName = true;
      for(sn in sectorNames) {
        if(name == sn) {
          generatedName = false;
        }
      }
      if(generatedName) sectorNames.push(name);
    }

    return name;
  }

  public static function generateSectorSpaces(sectorType:SectorType):Array<Space>
  {
    return SectorGenerator.createSectorSpaces(sectorType);
  }

  public static function generateEncounter(_et:EncounterType):Encounter
  {
    switch(_et) {
      case Librarian:
        return new Encounter(_et, "Librarian", "You meet a Librarian, poring over ancient texts detailing artifacts");
      case Trader:
        return new Encounter(_et, "Trader", "You meet a Trader, hawking his wares.");
      case Astronomer:
        return new Encounter(_et, "Astronomer", "You meet an Astronomer, busily mapping the stars.");
      case Terraformer:
        return new Encounter(_et, "Terraformer", "You meet a Terraformer, planning the architecture of a new world.");
      case Scientist:
        return new Encounter(_et, "Scientist", "You meet a Scientist, researching alien compounds.");
      default:
        return null;
    }
  }
}
