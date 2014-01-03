package com.modality.galaxia;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import com.modality.aug.Sketch;
import com.modality.aug.Vector3;

class NebulaSketch extends Sketch {
  public var roto_offset:Float;
  public var center_dist:Float;
  public var img:BitmapData;
  public var neb1:Sketch;
  public var neb2:Sketch;
  var l_thresh:Int = 50;
  var grid:Array<Array<Bool>>;

  public override function setup():Void
  {
    size(500, 500);
    grid = new Array<Array<Bool>>();
    for(i in 0...5) {
      grid.push([false, false, false, false, false]);
    }
    generateNebula();
    generateGrid();
  }

  public function generateGrid():Void {
    for(i in 0...5) {
      for(j in 0...5) {
      }
    }
  }

  public function generateNebula():Void {
    neb1 = createGraphics(width, height);
    neb2 = createGraphics(width, height);
    roto_offset = random(Math.PI * 2);
    center_dist = 250;
    drawToBuffer(neb1);
    center_dist = 300;
    drawToBuffer(neb2);
    image(neb1.output(), 0, 0);
    blend(neb2.output(), BlendMode.Lightest);
    calcAverage();
  }

  public function calcAverage():Void {
    colorMode(RGB, 255);
    loadPixels();
    for(i in 0...5) {
      for(j in 0...5) {
        var vec:Vector3 = new Vector3(0, 0, 0);
        var pixelCount:Int = 0;
        for(u in 0...100) {
          for(v in 0...100) {
            var c:Int = pixels[(j*100+v)*width+(i*100+u)];
            vec.x += red(c);
            vec.y += green(c);
            vec.z += blue(c);
          }
        }
        vec.div(100.*100.);
        grid[i][j] = brightness(color(floor(vec.x), floor(vec.y), floor(vec.z))) >= l_thresh;
      }
    }
  }

  public function drawToBuffer(buf:Sketch):Void {
    colorMode(RGB, 255);
    buf.background(0);
    buf.noStroke();
    
    noiseWalk(buf);

    img = createImage(500, 500);
    img.perlinNoise(100, 100, 4, floor(random(1000)), false, false, 7, true);

    buf.blend(img, BlendMode.Multiply);

    colorMode(HSB, 100);

    var hue_1:Int = floor(random(100));
    var hue_2:Int = floor(random(70)+15)+hue_1;
    if(hue_2 > 100) hue_2 -= 100;
  
    var c1:Int = color(hue_1, 100, floor(random(10)+5));
    var c2:Int = color(hue_2, floor(random(10)+80), floor(random(10)+90));

    var redChan:Array<Int> = new Array<Int>(),
        greenChan:Array<Int> = new Array<Int>(),
        blueChan:Array<Int> = new Array<Int>(),
        alphaChan:Array<Int> = new Array<Int>();

    var c1_red:Int = red(c1),
        c1_green:Int = green(c1),
        c1_blue:Int = blue(c1),
        c2_red:Int = red(c2),
        c2_green:Int = green(c2),
        c2_blue:Int = blue(c2);

    for(i in 0...256) {
      redChan.push(floor(lerp(c1_red, c2_red, i/255)) << 16 | 0xFF000000);
      greenChan.push(floor(lerp(c1_green, c2_green, i/255)) << 8 | 0xFF000000);
      blueChan.push(floor(lerp(c1_blue, c2_blue, i/255)) | 0xFF000000);
      alphaChan.push(0xFF000000);
    }

    buf.bitmap.paletteMap(buf.output(), new Rectangle(0, 0, width, height), new Point(0, 0),
      redChan, greenChan, blueChan, alphaChan);

    buf.blend(buf.bitmap, BlendMode.Overlay);
    colorMode(RGB, 255);
    buf.fill(color(255), 10);
    buf.noStroke();
    for(s in 0...250) {
      var u:Int = floor(random(width));
      var v:Int = floor(random(height));
      
      if(brightness(buf.get(u, v)) < 50) {
        buf.fill(color(255));
        buf.ellipse(u, v, 2, 2);
      }
    }
  }

  public function noiseWalk(buf:Sketch):Void {
    background(0, 20);
    var xoff:Float = 0.0, xincrement:Float = 0.01, xseed:Int = floor(random(10000));
    var yoff:Float = 0.0, yincrement:Float = 0.01, yseed:Int = floor(random(10000));
    var zoff:Float = 0.0, zincrement:Float = 0.01, zseed:Int = floor(random(10000));

    for(nw in 0...1000) {
      noiseSeed(xseed);
      var n:Float = noise(xoff) * Math.PI * 2;
      noiseSeed(yseed);
      var m:Float = noise(yoff) * (center_dist * 1.4);
    
      buf.fill(color(255), 15);
      noiseSeed(zseed);
      buf.ellipse(250+cos(n+roto_offset)*m,250+sin(n+roto_offset)*m, 64+(noise(zoff)*20), 64+(noise(zoff)*20));

      xoff += xincrement;
      yoff += yincrement;
      zoff += zincrement;
    }
  }

}

