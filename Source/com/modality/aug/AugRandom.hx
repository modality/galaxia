package com.modality.aug;

class AugRandom
{
  public static function weightedChoice(weights:Map<String,Int>):String
  {
    var totalWeight:Int = 0;

    for(weight in weights) {
      totalWeight += weight;
    }

    var choice:Int = Std.random(totalWeight);
    var currentWeight:Int = 0;

    for(choiceName in weights.keys()) {
      currentWeight += weights[choiceName];
      if(choice < currentWeight) {
        return choiceName;
      }
    }

    return null;
  }
}
