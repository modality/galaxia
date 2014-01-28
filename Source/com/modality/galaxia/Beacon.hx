package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class Beacon extends Base
{
  public static var count:Int = 0;

  public var line:Bool;
  public var vert:Bool;
  public var horz:Bool;
  public var activated:Bool;
  public var walked:Bool;
  public var space:Space;
  public var id:Int;
  public var probe:Base;

  public function new(_line:Bool, _space:Space)
  {
    super();

    Beacon.count = Beacon.count + 1;
    id = Beacon.count;

    line = _line;
    activated = false;
    space = _space;
    type = "beacon";
    layer = Constants.BEACON_LAYER;
    probe = new Base(); 
    probe.layer = Constants.BEACON_LAYER;
  }

  public override function added():Void
  {
    probe.x = x;
    probe.y = y;
    scene.add(probe);
  }

  public override function removed():Void
  {
    scene.remove(probe);
  }

  public function updateGraphic():Void
  {
    if(line) {
      if(vert && horz) {
        graphic = new Image(Assets.BEACON_CROSS_4);
      } else if(vert) {
        graphic = new Image(Assets.BEACON_VERT_2);
      } else if(horz) {
        graphic = new Image(Assets.BEACON_HORZ_2);
      } else {
        graphic = new Image(Assets.BEACON);
      }
      return;
    }

    var up:Bool, left:Bool, right:Bool, down:Bool;
    var nayb:Space;
    
    nayb = space.grid.get(space.x_index, space.y_index - 1);
    up = nayb != null && nayb.hasObject("beacon") && cast(nayb.getObject("beacon"), Beacon).activated;

    nayb = space.grid.get(space.x_index - 1, space.y_index);
    left = nayb != null && nayb.hasObject("beacon") && cast(nayb.getObject("beacon"), Beacon).activated;

    nayb = space.grid.get(space.x_index + 1, space.y_index);
    right = nayb != null && nayb.hasObject("beacon") && cast(nayb.getObject("beacon"), Beacon).activated;

    nayb = space.grid.get(space.x_index, space.y_index + 1);
    down = nayb != null && nayb.hasObject("beacon") && cast(nayb.getObject("beacon"), Beacon).activated;

    var getAsset = function(up:Bool, down:Bool, left:Bool, right:Bool):String {
      if(up && down && left && right) return Assets.BEACON_CROSS_4;
      if(up && down && left) return Assets.BEACON_RIGHT_3;
      if(up && down && right) return Assets.BEACON_LEFT_3;
      if(down && left && right) return Assets.BEACON_UP_3;
      if(up && left && right) return Assets.BEACON_DOWN_3;
      if(up && down) return Assets.BEACON_VERT_2;
      if(left && right) return Assets.BEACON_HORZ_2;
      if(up) return Assets.BEACON_UP_1;
      if(down) return Assets.BEACON_DOWN_1;
      if(left) return Assets.BEACON_LEFT_1;
      if(right) return Assets.BEACON_RIGHT_1;
      return Assets.BEACON;
    }

    if(activated) {
      if(getAsset(up, down, left, right) != null) {
        graphic = new Image(getAsset(up, down, left, right));
      }
    } else {
      graphic = new Image(Assets.BEACON);
    }

    if(!line) {
      probe.graphic = new Image(Assets.PROBE);
    }
  }
}
