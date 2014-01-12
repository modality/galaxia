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

  public var value(default, set):Int;
  public var cap(default, set):Int;
  public var setting(default, set):Int;

  public var slots:Array<Base>;
  public var fills:Array<Base>;
  public var energy:Array<Base>;
  public var drains:Array<Base>;

  public var panel_gfx:String;
  public var bloom_gfx:String;
  public var energy_gfx:String;
  public var fill_gfx:String;

  public var pool:Bool;

  public function new(_title:String, _desc:String, total:Int, _panel_gfx:String, _bloom_gfx:String, _energy_gfx:String, _fill_gfx:String, _pool:Bool = false)
  {
    super();
    slots = new Array<Base>();
    fills = new Array<Base>();
    energy = new Array<Base>();
    drains = new Array<Base>();

    panel_gfx = _panel_gfx;
    bloom_gfx = _bloom_gfx;
    energy_gfx = _energy_gfx;
    fill_gfx = _fill_gfx;

    this.graphic = new Image(panel_gfx);
    this.layer = Constants.MENU_LAYER;

    bloom = new Base();
    bloom.graphic = new Image(bloom_gfx);
    bloom.layer = Constants.BLOOM_LAYER;

    title = new TextBase(_title);
    title.text.color = 0x000000;
    title.text.font = Assets.FONT_BOLD;
    title.layer = Constants.BLOOM_LAYER;

    desc = new TextBase(_desc);
    desc.text.size = Constants.FONT_SIZE_XS;
    desc.text.font = Assets.FONT_BOLD;
    desc.layer = Constants.MENU_LAYER;

    plusBtn = new Base();
    plusBtn.graphic = new Image(Assets.NRG_PLUS);
    plusBtn.layer = Constants.BLOOM_LAYER;

    minusBtn = new Base();
    minusBtn.graphic = new Image(Assets.NRG_MINUS);
    minusBtn.layer = Constants.BLOOM_LAYER;

    pool = _pool;
    set_cap(total);
  }

  public override function added()
  {
    scene.add(bloom);
    scene.add(title);
    scene.add(desc);
    scene.add(plusBtn);
    scene.add(minusBtn);

    for(ent in energy) scene.add(ent);
    if(!pool) {
      for(ent in slots) scene.add(ent);
      for(ent in fills) scene.add(ent);
      for(ent in drains) scene.add(ent);
    }
    updateGraphic();
  }

  public function set_value(val:Int):Int
  {
    if(val > cap) return value;
    if(value != val) {
      value = val;
      updateGraphic();
    }
    return value;
  }

  public function set_setting(val:Int):Int
  {
    if(val > cap) return setting;
    if(setting != val) {
      setting = val;
      updateGraphic();
    }
    return setting;
  }

  public function set_cap(val:Int):Int
  {
    if(cap == val) return cap;
    cap = val;

    while(energy.length < val) {
      var ent:Base;

      ent = new Base();
      ent.graphic = new Image(energy_gfx);
      ent.layer = Constants.ENERGY_LAYER;
      energy.push(ent);

      if(!pool) {
        ent = new Base();
        ent.graphic = new Image(Assets.NRG_SLOT);
        ent.layer = Constants.SLOT_LAYER;
        slots.push(ent);
        
        ent = new Base();
        ent.graphic = new Image(fill_gfx);
        ent.layer = Constants.ENERGY_LAYER;
        fills.push(ent);

        ent = new Base();
        ent.graphic = new Image(Assets.NRG_DRAIN);
        ent.layer = Constants.DRAIN_LAYER;
        drains.push(ent);
      }
    }

    return cap;
  }

  public function updateGraphic():Void
  {
    title.x = x + 4;
    title.y = y + 1;

    bloom.x = x - 6;
    bloom.y = y - 6;

    desc.x = x;
    desc.y = y + 40;

    minusBtn.x = x + 80;
    minusBtn.y = y + 4;

    plusBtn.x = x + 100;
    plusBtn.y = y + 4;

    var dots_x = x + 4;
    var dots_y = y + 28;

    for(i in 0...energy.length) {
      energy[i].x = dots_x + (i*12);
      energy[i].y = dots_y;

      if(!pool) {
        fills[i].x = dots_x + (i*12);
        fills[i].y = dots_y;

        slots[i].x = dots_x + (i*12);
        slots[i].y = dots_y;

        drains[i].x = dots_x + (i*12);
        drains[i].y = dots_y;
      }
    }

    for(i in 0...cap) {
      energy[i].alpha = 0;
      if(!pool) {
        drains[i].alpha = 0;
        fills[i].alpha = 0;
      }

      if(i < setting) {
        if(i < value) {
          energy[i].alpha = 1;
        } else if(i >= value) {
          if(!pool) fills[i].alpha = 1;
        }
      } else if(i >= setting) {
        if(i < value) {
          energy[i].alpha = 1;
          if(!pool) drains[i].alpha = 1;
        }
      }
    }
  }
}
