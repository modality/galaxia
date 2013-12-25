package com.modality.aug;

import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.display.Sprite;

enum EllipseMode {
  Radius;
  Center;
  Corner;
  Corners;
}

class Sketch {
  public var width:Int;
  public var height:Int;

  private var _ellipseMode:EllipseMode;
  private var _fill:Bool = false;
  private var _fillColor:Int = 0xFFFFFF;
  private var _smoothing:Bool = false;
  private var _stroke:Bool = false;
  private var _strokeColor:Int = 0x000000;
  private var _strokeWeight:Float = 0;
  private var _sprite:Sprite;
  private var _matrixStack:Array<Matrix>;

  public function new()
  {
    _sprite = new Sprite();
    _matrixStack = new Array<Matrix>();
    size(100, 100);
    setup();
  }

  public function output():BitmapData
  {
    draw();
    var bmd:BitmapData = new BitmapData(width, height);
    bmd.draw(_sprite);
    return bmd;
  }

  public function setup():Void { }
  public function draw():Void { }

  public function background(_color:Int):Void
  {
    _sprite.graphics.clear();
    _sprite.graphics.beginFill(_color);
    _sprite.graphics.drawRect(0, 0, width, height);
    _sprite.graphics.endFill();
  }

  public function color(_r:Int, ?_g:Int, ?_b:Int):Int
  {
    if(_g != null && _b != null) {
      return (_r << 16) | (_g << 8) | _b;
    } else {
      return (_r << 16) | (_r << 8) | _r;
    }
  }

  public function ellipse(_a:Float, _b:Float, _c:Float, _d:Float)
  {
    _startShape();
    switch(_ellipseMode) {
      case Radius:
        _sprite.graphics.drawEllipse(_a-_c, _b-_d, _c*2, _d*2);
      case Center:
        _sprite.graphics.drawEllipse(_a-(_c/2), _b-(_d/2), _c, _d);
      case Corner:
        _sprite.graphics.drawEllipse(_a, _b, _c, _d);
      case Corners:
        _sprite.graphics.drawEllipse(_a, _b, _c-_a, _d-_a);
    }
    _endShape();
  }

  public function ellipseMode(_mode:EllipseMode):Void
  {
    _ellipseMode = _mode;
  }

  public function fill(_color:Int):Void
  {
    _fill = true;
    _fillColor = _color;
  }

  public function image(_img:BitmapData, _a:Float, _b:Float, ?_c:Float, ?_d:Float)
  {
    var _w:Float, _h:Float;
    var _mat:Matrix = new Matrix();

    if(_c != null && _d != null) {
      _w = _c;
      _h = _d;
      _mat.scale(_c/_img.width, _d/_img.height);
    } else {
      _w = _img.width;
      _h = _img.height;
      _mat.identity();
    }

    _sprite.graphics.lineStyle();
    _sprite.graphics.beginBitmapFill(_img, _mat, false, _smoothing);
    _sprite.graphics.drawRect(_a, _b, _w, _h);
    _sprite.graphics.endFill();
  }

  public function line(_x1:Float, _y1:Float, _x2:Float, _y2:Float)
  {
    _startShape();
    _sprite.graphics.moveTo(_x1, _y1);
    _sprite.graphics.lineTo(_x2, _y2);
    _endShape();
  }

  public function loadImage(_img:String):BitmapData
  {
    return openfl.Assets.getBitmapData(_img);
  }

  public function noFill():Void
  {
    _fill = false;
    _fillColor = 0xFFFFFF;
  }

  public function noSmooth():Void
  {
    _smoothing = false;
  }

  public function noStroke():Void
  {
    _stroke = false;
    _strokeColor = 0x000000;
    _strokeWeight = 1;
  }

  public function popMatrix():Void
  {
    _sprite.transform.matrix = _matrixStack.pop();
  }

  public function pushMatrix():Void
  {
    _matrixStack.push(_sprite.transform.matrix.clone());
  }

  public function size(_width:Int, _height:Int):Void
  {
    width = _width; height = _height;
  }

  public function smooth():Void
  {
    _smoothing = true;
  }
  
  public function stroke(_color:Int):Void
  {
    _stroke = true;
    _strokeColor = _color;
  }

  public function strokeWeight(_weight:Float):Void
  {
    _strokeWeight = _weight;
  }

  public function translate(_x:Int, _y:Int):Void
  {
    _sprite.transform.matrix.translate(_x, _y);
  }

  private function _startShape():Void
  {
    if(_fill) _sprite.graphics.beginFill(_fillColor);
    if(_stroke) {
      _sprite.graphics.lineStyle(_strokeWeight, _strokeColor);
    } else {
      _sprite.graphics.lineStyle();
    }
  }

  private function _endShape():Void
  {
    if(_fill) _sprite.graphics.endFill();
  }
}
