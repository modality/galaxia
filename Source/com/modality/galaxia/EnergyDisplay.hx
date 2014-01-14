package com.modality.galaxia;

import com.haxepunk.graphics.Image;
import com.modality.aug.Base;

class EnergyDisplay extends Base
{
  public var bloom:Base;
  public var title:TextBase;
  public var desc:TextBase;
  public var plusBtn:Base;
  public var minusBtn:Base;

  public var stat:ShipSystem;
  public var energy(get, set):Int;
  public var cap(get, set):Int;
  public var setting(get, set):Int;

  public var slots:Array<Base>;
  public var fills:Array<Base>;
  public var points:Array<Base>;
  public var drains:Array<Base>;

  public var panel_gfx:String;
  public var bloom_gfx:String;
  public var points_gfx:String;
  public var fill_gfx:String;

  public var pool:Bool;

  public function new(_title:String, _desc:String, _stat:ShipSystem, _panel_gfx:String, _bloom_gfx:String, _points_gfx:String, _fill_gfx:String, _pool:Bool = false)
  {
    super();
    stat = _stat;

    slots = new Array<Base>();
    fills = new Array<Base>();
    points = new Array<Base>();
    drains = new Array<Base>();

    panel_gfx = _panel_gfx;
    bloom_gfx = _bloom_gfx;
    points_gfx = _points_gfx;
    fill_gfx = _fill_gfx;
    pool = _pool;

    this.graphic = new Image(panel_gfx);
    this.layer = Constants.MENU_LAYER;

    bloom = new Base();
    bloom.graphic = new Image(bloom_gfx);
    bloom.layer = Constants.BLOOM_LAYER;

    title = new TextBase(_title.toUpperCase());
    title.text.color = 0x000000;
    title.text.font = Assets.FONT_BOLD;
    title.layer = Constants.BLOOM_LAYER;

    desc = new TextBase(_desc);
    desc.text.size = Constants.FONT_SIZE_XS;
    desc.text.font = Assets.FONT_BOLD;
    desc.layer = Constants.MENU_LAYER;

    if(!pool) {
      plusBtn = new Base();
      plusBtn.type = "btn_plus";
      plusBtn.name = _title.toLowerCase();
      plusBtn.graphic = new Image(Assets.NRG_PLUS);
      plusBtn.layer = Constants.BLOOM_LAYER;
      plusBtn.setHitboxTo(plusBtn.graphic);

      minusBtn = new Base();
      minusBtn.type = "btn_minus";
      minusBtn.name = _title.toLowerCase();
      minusBtn.graphic = new Image(Assets.NRG_MINUS);
      minusBtn.layer = Constants.BLOOM_LAYER;
      minusBtn.setHitboxTo(minusBtn.graphic);
    }

    set_cap(stat.cap);
  }

  public override function added()
  {
    scene.add(bloom);
    scene.add(title);
    scene.add(desc);
    if(!pool) {
      scene.add(plusBtn);
      scene.add(minusBtn);
    }

    for(ent in points) scene.add(ent);
    for(ent in drains) scene.add(ent);

    if(!pool) {
      for(ent in slots) scene.add(ent);
      for(ent in fills) scene.add(ent);
    }
    updateGraphic();
  }

  public function get_energy():Int
  {
    return stat.energy;
  }

  public function set_energy(val:Int):Int
  {
    if(val > stat.cap) return stat.energy;
    if(stat.energy != val) stat.energy = val;
    return stat.energy;
  }

  public function get_setting():Int
  {
    return stat.setting;
  }

  public function set_setting(val:Int):Int
  {
    if(val > cap) return stat.setting;
    if(stat.setting != val) stat.setting = val;
    return stat.setting;
  }

  public function get_cap():Int
  {
    return stat.cap;
  }

  public function set_cap(val:Int):Int
  {
    stat.cap = val;

    while(points.length < val) {
      var ent:Base;

      ent = new Base();
      ent.graphic = new Image(points_gfx);
      ent.layer = Constants.ENERGY_LAYER;
      points.push(ent);

      ent = new Base();
      ent.graphic = new Image(Assets.NRG_DRAIN);
      ent.layer = Constants.DRAIN_LAYER;
      drains.push(ent);

      if(!pool) {
        ent = new Base();
        ent.graphic = new Image(Assets.NRG_SLOT);
        ent.layer = Constants.SLOT_LAYER;
        slots.push(ent);
        
        ent = new Base();
        ent.graphic = new Image(fill_gfx);
        ent.layer = Constants.ENERGY_LAYER;
        fills.push(ent);
      }
    }

    return stat.cap;
  }

  public function updateGraphic():Void
  {
    title.x = x + 4;
    title.y = y + 1;

    bloom.x = x - 6;
    bloom.y = y - 6;

    desc.x = x;
    desc.y = y + 40;

    if(!pool) {
      minusBtn.x = x + 80;
      minusBtn.y = y + 4;

      plusBtn.x = x + 100;
      plusBtn.y = y + 4;
    }

    var dots_x = x + 4;
    var dots_y = y + 28;

    for(i in 0...points.length) {
      points[i].x = dots_x + (i*12);
      points[i].y = dots_y;

      drains[i].x = dots_x + (i*12);
      drains[i].y = dots_y;

      if(!pool) {
        fills[i].x = dots_x + (i*12);
        fills[i].y = dots_y;

        slots[i].x = dots_x + (i*12);
        slots[i].y = dots_y;
      }
    }

    for(i in 0...cap) {
      points[i].alpha = 0;
      drains[i].alpha = 0;
      if(!pool) {
        fills[i].alpha = 0;
      }
      if(i < setting) {
        if(i < energy) {
          points[i].alpha = 1;
        } else if(i >= energy) {
          if(!pool) {
            fills[i].alpha = 1;
          }
        }
      } else if(i >= setting) {
        if(i < energy) {
          points[i].alpha = 1;
          drains[i].alpha = 1;
        }
      }
    }
  }
}
