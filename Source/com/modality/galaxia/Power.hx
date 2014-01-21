package com.modality.galaxia;

import com.modality.aug.Base;

class Power extends Base
{
  public var title:String;
  public var desc:String;

  public var ready:Bool;
  public var cooldownCount:Int;
  public var cooldown:Int;
  public var cost:Int;
  public var immediate:Bool;
  public var range:Int;
  public var targetSelf:Bool;
  public var targetOther:Bool;
  public var targetCount:Int;

  public var buffs:Array<Ship->Void>;
  public var debuffs:Array<Space->Void>;

  public var title_txt:TextBase;
  public var desc_txt:TextBase;
  public var type_txt:TextBase;
  public var cost_txt:TextBase;
  public var cool_txt:TextBase;

  public function new()
  {
    super();
    type = "power";
    ready = true;
    cooldownCount = 0;
    cooldown = 0;
    cost = 0;
    immediate = false;
    range = 0;
    targetSelf = false;
    targetOther = false;
    targetCount = 0;
    buffs = [];
    debuffs = [];

    title_txt = new TextBase("");
    type_txt = new TextBase("");
    desc_txt = new TextBase("");
    cost_txt = new TextBase("");
    cool_txt = new TextBase("");
  }

  public override function added():Void
  {
    updateGraphic();
    scene.add(title_txt);
    scene.add(desc_txt);
    scene.add(type_txt);
    scene.add(cost_txt);
    scene.add(cool_txt);
  }

  public override function removed():Void
  {
    scene.remove(title_txt);
    scene.remove(desc_txt);
    scene.remove(type_txt);
    scene.remove(cost_txt);
    scene.remove(cool_txt);
  }

  public function step():Void
  {
    if(cooldownCount > 0) {
      cooldownCount--;
    }

    if(cooldownCount == 0) {
      ready = true;
    }
    updateGraphic();
  }

  public function use(ship:Ship, targets:Array<Space>):Void
  {
    if(targetSelf) {
      for(buff in buffs) {
        buff(ship);
      }
    }

    if(targetOther) {
      for(debuff in debuffs) {
        for(target in targets) {
          debuff(target);
        }
      }
    }

    ready = false;
    if(immediate) {
      cooldownCount = cooldown;
    } else {
      cooldownCount = cooldown + 1;
    }
    updateGraphic();
  }

  public function updateGraphic():Void
  {
    setHitbox(300, 100, 0, 0);
    if(ready) {
      title_txt.text.text = title;
    } else {
      title_txt.text.text = title + " ("+cooldownCount+")";
    }
    title_txt.x = x + 70;
    title_txt.y = y;

    type_txt.x = x + 70;
    type_txt.y = y + 20;
    type_txt.text.size = Constants.FONT_SIZE_XS;

    if(immediate) {
      type_txt.text.text = "Immediate";
    } else {
      type_txt.text.text = "Standard Action";
    }

    desc_txt.text.text = desc;
    desc_txt.x = x + 70;
    desc_txt.y = y + 45;
    desc_txt.text.size = Constants.FONT_SIZE_XS;

    cost_txt.text.text = "Cost: "+cost;
    cost_txt.text.size = Constants.FONT_SIZE_XS;
    cost_txt.x = x + 70;
    cost_txt.y = y + 70;

    cool_txt.text.text = "Cooldown: "+cooldown;
    cool_txt.text.size = Constants.FONT_SIZE_XS;
    cool_txt.x = 140;
    cool_txt.y = y + 70;

    if(ready && cost <= Game.player.fuel) {
      title_txt.text.color = 0xFFFFFF;
      desc_txt.text.color = 0xFFFFFF;
      type_txt.text.color = 0x29FF3C;
      cost_txt.text.color = 0xFFB649;
      cool_txt.text.color = 0xC534FF;
    } else {
      title_txt.text.color = 0xAAAAAA;
      desc_txt.text.color = 0xAAAAAA;
      type_txt.text.color = 0xAAAAAA;
      cost_txt.text.color = 0xAAAAAA;
      cool_txt.text.color = 0xAAAAAA;
    }
  }
}
