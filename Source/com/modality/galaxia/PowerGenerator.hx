package com.modality.galaxia;

import com.haxepunk.graphics.Image;

class PowerGenerator
{
  public static function shieldBattery():Power
  {
    var sb:Power = new Power();

    sb.title = "Shield Battery";
    sb.desc = "Restore 5 shields.";
    sb.immediate = true;
    sb.cooldown = 3;
    sb.cost = 3;
    sb.targetSelf = true;
    sb.buffs.push(PowerEffects.restoreShields);
    sb.graphic = new Image(Assets.SHIELD_BATTERY);

    return sb;
  }

  public static function multiShot():Power
  {
    var ms:Power = new Power();
    
    ms.title = "Multi Shot";
    ms.desc = "Deal 1 damage to 2 targets.";
    ms.immediate = false;
    ms.targetOther = true;
    ms.cooldown = 1;
    ms.cost = 5;
    ms.range = 2;
    ms.targetCount = 2;
    ms.debuffs.push(PowerEffects.dealDamage);
    ms.graphic = new Image(Assets.MULTI_SHOT);

    return ms;
  }
}
