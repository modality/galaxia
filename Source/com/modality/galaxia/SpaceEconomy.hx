package com.modality.galaxia;

class SpaceEconomy
{
  public static var GOOD_BASE:Int = 4;
  public static var SECTOR_BASE:Int = 16;
  public static var PLANET_BASE:Int = 64;

  public var goods:Int;
  public var sectors:Int;
  public var planets:Int;

  public var money:Int;
  public var science:Int;
  public var economy:Int;
  public var economyLevel:Int;
  public var nextEconomyCycle:Int;

  public function new()
  {
    goods = 0;
    planets = 0;
    sectors = 0;

    money = 0;
    science = 0;
    economy = 0;
    economyLevel = 1;
    nextEconomyCycle = economyLevel * 10;
  }

  public function moneyPerCycle():Int
  {
    if(goods == 0) return 0;
    if(planets == 0) return 0;
    if(sectors == 0) return 0;

    var dimensions:Float = 2 + (Math.log(sectors)/Math.log(SpaceEconomy.SECTOR_BASE)) + (Math.log(planets)/Math.log(SpaceEconomy.PLANET_BASE));
    var radius:Float = 1 + (Math.log(goods)/Math.log(SpaceEconomy.GOOD_BASE));

    return Math.round(Math.pow(Math.PI, dimensions)*Math.pow(radius, dimensions)/dimensions);
  }

  public function addScience(howMuch:Int):Void
  {
    science += howMuch;
  }

  public function addEconomy(howMuch:Int):Void
  {
    economy += howMuch;

    while(economy >= nextEconomyCycle) {
      money += moneyPerCycle();
      economy -= nextEconomyCycle;
      economyLevel += 1;
      nextEconomyCycle = economyLevel * 10;
    }
  }
}
