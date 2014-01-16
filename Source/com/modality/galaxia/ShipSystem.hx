package com.modality.galaxia;

class ShipSystem
{
  public var energy:Int;
  public var cap:Int;
  public var setting:Int;
  public var title:String;
  public var desc:String;

  public function new(_title:String, _energy:Int, _cap:Int, _setting:Int)
  {
    title = _title;
    energy = _energy;
    cap = _cap;
    setting = _setting;
    desc = "";
  }
}
