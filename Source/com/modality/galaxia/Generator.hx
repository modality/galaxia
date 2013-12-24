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

  public static function generateItem():String
  {
    return good_1[Std.random(good_1.length)] + " " + good_2[Std.random(good_2.length)];
  }

  public static function getBaseSquare(sectorType:String):String
  {
    switch(sectorType) {
      case "deep":
        return AugRandom.weightedChoice(["star" => 55, "planet" => 45]);
      case "core":
        return AugRandom.weightedChoice(["void" => 20, "star" => 40, "planet" => 40]);
      case "inner":
        return AugRandom.weightedChoice(["void" => 30, "star" => 35, "planet" => 35]);
      case "outer":
        return AugRandom.weightedChoice(["void" => 45, "star" => 30, "planet" => 25]);
      case "unknown":
        return AugRandom.weightedChoice(["void" => 65, "star" => 25, "planet" => 10]);
    }
    return "void";
  }

}
