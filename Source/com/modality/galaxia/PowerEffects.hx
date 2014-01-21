package com.modality.galaxia;

class PowerEffects
{
  public static function restoreShields(ship:Ship):Void
  {
    ship.shields += 5;
    if(ship.shields > ship.maxShields) {
      ship.shields = ship.maxShields;
    }
  }

  public static function dealDamage(space:Space):Void
  {
    for(object in space.objects) {
      if(object.type == "pirate") {
        cast(object, Pirate).takeDamage(1);
      } else if(object.type == "player") {
        cast(object, Ship).takeDamage(1);
      }
    }
  }
}
