package com.modality.galaxia;

//using EncounterType;

import com.modality.aug.Base;

class Encounter extends Base
{
  public var encounterType:EncounterType;
  public var description:String;

  public function new(_et:EncounterType, _desc:String) {
    super();
    encounterType = _et;
    description = _desc;
  }
}
