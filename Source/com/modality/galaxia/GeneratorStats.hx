package com.modality.galaxia;

class GeneratorStats
{
  public var core_traders:Stat;
  public var core_astronomers:Stat;
  public var core_librarians:Stat;
  public var core_terraformers:Stat;
  public var core_scientists:Stat;
  public var core_pirates:Stat;

  public var inner_traders:Stat;
  public var inner_astronomers:Stat;
  public var inner_librarians:Stat;
  public var inner_terraformers:Stat;
  public var inner_scientists:Stat;
  public var inner_pirates:Stat;

  public var outer_traders:Stat;
  public var outer_astronomers:Stat;
  public var outer_librarians:Stat;
  public var outer_terraformers:Stat;
  public var outer_scientists:Stat;
  public var outer_pirates:Stat;

  public var unknown_traders:Stat;
  public var unknown_astronomers:Stat;
  public var unknown_librarians:Stat;
  public var unknown_terraformers:Stat;
  public var unknown_scientists:Stat;
  public var unknown_pirates:Stat;

  public var allStats:Array<Stat>;

  public function new()
  {

    core_traders = new Stat("core traders");
    core_astronomers = new Stat("core astronomers");
    core_librarians = new Stat("core librarians");
    core_terraformers = new Stat("core terraformers");
    core_scientists = new Stat("core scientists");
    core_pirates = new Stat("core pirates");

    inner_traders = new Stat("inner traders");
    inner_astronomers = new Stat("inner astronomers");
    inner_librarians = new Stat("inner librarians");
    inner_terraformers = new Stat("inner terraformers");
    inner_scientists = new Stat("inner scientists");
    inner_pirates = new Stat("inner pirates");

    outer_traders = new Stat("outer traders");
    outer_astronomers = new Stat("outer astronomers");
    outer_librarians = new Stat("outer librarians");
    outer_terraformers = new Stat("outer pirates");
    outer_scientists = new Stat("outer scientists");
    outer_pirates = new Stat("outer pirates");

    unknown_traders = new Stat("unknown traders");
    unknown_astronomers = new Stat("unknown astronomers");
    unknown_librarians = new Stat("unknown librarians");
    unknown_terraformers = new Stat("unknown terraformers");
    unknown_scientists = new Stat("unknown scientists");
    unknown_pirates = new Stat("unknown pirates");

    allStats = new Array<Stat>();
    allStats.push(core_traders);
    allStats.push(core_astronomers);
    allStats.push(core_librarians);
    allStats.push(core_terraformers);
    allStats.push(core_scientists);
    allStats.push(core_pirates);
    allStats.push(inner_traders);
    allStats.push(inner_astronomers);
    allStats.push(inner_librarians);
    allStats.push(inner_terraformers);
    allStats.push(inner_scientists);
    allStats.push(inner_pirates);
    allStats.push(outer_traders);
    allStats.push(outer_astronomers);
    allStats.push(outer_librarians);
    allStats.push(outer_terraformers);
    allStats.push(outer_scientists);
    allStats.push(outer_pirates);
    allStats.push(unknown_traders);
    allStats.push(unknown_astronomers);
    allStats.push(unknown_librarians);
    allStats.push(unknown_terraformers);
    allStats.push(unknown_scientists);
    allStats.push(unknown_pirates);

    for(runcount in 0...1000) {
      var core:Array<Space> = Generator.generateSectorSpaces(SectorType.Core); 
      var inner:Array<Space> = Generator.generateSectorSpaces(SectorType.InnerRim); 
      var outer:Array<Space> = Generator.generateSectorSpaces(SectorType.OuterRim); 
      var unknown:Array<Space> = Generator.generateSectorSpaces(SectorType.Unknown); 

      core_traders.addNumber(countEncounters(EncounterType.Trader, core));
      core_astronomers.addNumber(countEncounters(EncounterType.Astronomer, core));
      core_librarians.addNumber(countEncounters(EncounterType.Librarian, core));
      core_terraformers.addNumber(countEncounters(EncounterType.Terraformer, core));
      core_scientists.addNumber(countEncounters(EncounterType.Scientist, core));
      core_pirates.addNumber(countEncounters(EncounterType.Pirate, core));

      inner_traders.addNumber(countEncounters(EncounterType.Trader, inner));
      inner_astronomers.addNumber(countEncounters(EncounterType.Astronomer, inner));
      inner_librarians.addNumber(countEncounters(EncounterType.Librarian, inner));
      inner_terraformers.addNumber(countEncounters(EncounterType.Terraformer, inner));
      inner_scientists.addNumber(countEncounters(EncounterType.Scientist, inner));
      inner_pirates.addNumber(countEncounters(EncounterType.Pirate, inner));

      outer_traders.addNumber(countEncounters(EncounterType.Trader, outer));
      outer_astronomers.addNumber(countEncounters(EncounterType.Astronomer, outer));
      outer_librarians.addNumber(countEncounters(EncounterType.Librarian, outer));
      outer_terraformers.addNumber(countEncounters(EncounterType.Terraformer, outer));
      outer_scientists.addNumber(countEncounters(EncounterType.Scientist, outer));
      outer_pirates.addNumber(countEncounters(EncounterType.Pirate, outer));

      unknown_traders.addNumber(countEncounters(EncounterType.Trader, unknown));
      unknown_astronomers.addNumber(countEncounters(EncounterType.Astronomer, unknown));
      unknown_librarians.addNumber(countEncounters(EncounterType.Librarian, unknown));
      unknown_terraformers.addNumber(countEncounters(EncounterType.Terraformer, unknown));
      unknown_scientists.addNumber(countEncounters(EncounterType.Scientist, unknown));
      unknown_pirates.addNumber(countEncounters(EncounterType.Pirate, unknown));
    }

    trace("name,mean,median,mode,lowest,highest");
    for(stat in allStats) {
      stat.presort();
      trace(stat.name+","+stat.mean()+","+stat.median()+","+stat.mode()+","+stat.rangeLow()+","+stat.rangeHigh());
    }
  }

  public function countEncounters(_et:EncounterType, _s:Array<Space>):Int
  {
    var count:Int = 0;
    for(space in _s) {
      if(space.encounter != null && space.encounter.encounterType == _et) {
        count++;
      }
    }
    return count;
  }
  
}
