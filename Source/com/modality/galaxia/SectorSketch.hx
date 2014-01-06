package com.modality.galaxia;

import flash.display.BitmapData;
import com.modality.aug.Sketch;

class SectorSketch extends Sketch {
  private var drawSize:Int;
  private var sectorBgOn:BitmapData;

  public override function setup():Void
  {
    size(Constants.BLOCK_W+2, Constants.BLOCK_H+2);
    drawSize = Constants.BLOCK_W-2;
    ellipseMode(EllipseMode.Radius);
    noSmooth();
    sectorBgOn = loadImage(Assets.SECTOR_ON_ICON);
  }

  public override function draw():Void
  {
    background(color(0));
    image(sectorBgOn, 0, 0);

    pushMatrix();
    translate(2, 2);
    drawCircles(randomRange(1, 4), 8, 16, 5, Constants.COLOR_ACCENT_1, true);
    drawCircles(randomRange(1, 3), 12, 28, 5, Constants.COLOR_ACCENT_2, false);
    drawLines(randomRange(1, 5), 5, Constants.COLOR_ACCENT_4);
    drawCircles(randomRange(1, 10), 2, 2, 5, Constants.COLOR_ACCENT_3, true);
    popMatrix();
  }

  private function drawCircles(howMany:Int, minSize:Int, maxSize:Int, padding:Int, col:Int, filled:Bool):Void
  {
    fill(col);
    stroke(col);
    strokeWeight(2);
    
    if(filled) {
      noStroke();
    } else {
      noFill();
    }

    for(n in 0...howMany) {
      var nebulaRadius:Int = randomRange(minSize, maxSize);
      ellipse(randomRange(nebulaRadius+padding, drawSize-nebulaRadius-padding),
              randomRange(nebulaRadius+padding, drawSize-nebulaRadius-padding),
              nebulaRadius, nebulaRadius);
    }
  }

  private function drawLines(howMany:Int, padding:Int, col:Int):Void
  {
    stroke(col);
    strokeWeight(2);
    noFill();
    
    for(n in 0...howMany) {
      line(randomRange(padding, drawSize-padding), randomRange(padding, drawSize-padding),
          randomRange(padding, drawSize-padding), randomRange(padding, drawSize-padding));
    }
  }

  private function randomRange(start:Int, end:Int):Int
  {
    return Std.random(end-start)+start; 
  }
}
