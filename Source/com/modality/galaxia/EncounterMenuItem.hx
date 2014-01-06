package com.modality.galaxia;

import com.modality.aug.Base;

class EncounterMenuItem extends TextBase
{
  public function addEncounter(_enc:Encounter):Void { } 
  public function handlesEncounter(_enc:Encounter):Bool { return false; }
  public function updateGraphic():Void { }
  public function hasEncounter(_enc:Encounter):Bool { return false; }
}
