package com.modality.aug;

import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.utils.ByteArray;

enum EllipseMode {
  Radius;
  Center;
  Corner;
  Corners;
}

enum ColorMode {
  RGB;
  HSB;
}

enum BlendMode {
  Multiply;
  Lightest;
  Overlay;
}

class Sketch {
  public var width:Int;
  public var height:Int;
  public var bitmap:BitmapData;
  public var pixels:Array<Int>;

  private var _ellipseMode:EllipseMode;
  private var _colorMode:ColorMode;
  private var _colorModeScale:Float = 255;
  private var _fill:Bool = false;
  private var _fillColor:Int = 0xFFFFFF;
  private var _fillAlpha:Float = 1;
  private var _smoothing:Bool = false;
  private var _stroke:Bool = false;
  private var _strokeColor:Int = 0x000000;
  private var _strokeWeight:Float = 0;
  private var _sprite:Sprite;
  private var _spriteChanged:Bool = false;
  private var _matrixStack:Array<Matrix>;
  private var _noiseSeed:Int;
  private var _noiseProfile:Map<Int,PerlinNoise>;

  public function new()
  {
    _noiseSeed = floor(random(1000));
    _ellipseMode = EllipseMode.Center;
    _colorMode = ColorMode.RGB;
    _sprite = new Sprite();
    _matrixStack = new Array<Matrix>();
    size(100, 100);
    setup();
  }

  public function output():BitmapData
  {
    draw();
    _rasterize();
    return bitmap;
  }

  public function setup():Void { }
  public function draw():Void { }

  public function background(_color:Int, _alpha:Int = 1):Void
  {
    _spriteChanged = true;
    _sprite.graphics.clear();
    _sprite.graphics.beginFill(_color, _alpha);
    _sprite.graphics.drawRect(0, 0, width, height);
    _sprite.graphics.endFill();
  }

  public function blend(_src:BitmapData, _mode:BlendMode)
  {
    var blendMode:flash.display.BlendMode = switch(_mode) {
      case Multiply: flash.display.BlendMode.MULTIPLY;
      case Lightest: flash.display.BlendMode.LIGHTEN;
      case Overlay: flash.display.BlendMode.OVERLAY;
    }
    _rasterize();
    bitmap.draw(_src, null, null, blendMode);
  }

  public function blue(_c:Int):Int
  {
    return _c & 255;
  }

  public function brightness(_c:Int):Float
  {
    return Color.rgb2hsv(Color.toRGB(_c)).v * _colorModeScale;
  }

  public function color(_r:Float, ?_g:Float, ?_b:Float):Int
  {
    if(_colorMode == ColorMode.RGB) {
      var _red:Int = floor(_r * 255 / _colorModeScale);
      if(_g != null && _b != null) {
        var _green:Int = floor(_g * 255 / _colorModeScale);
        var _blue:Int = floor(_b * 255 / _colorModeScale);
        return (_red << 16) | (_green << 8) | _blue;
      } else {
        return (_red << 16) | (_red << 8) | _red;
      }
    } else {
      return Color.hsv2int(
        (_r*360/_colorModeScale),
        (_g/_colorModeScale),
        (_b/_colorModeScale)
      );
    }
  }

  public function colorMode(_mode:ColorMode, _scale:Float)
  {
    _colorMode = _mode;
    _colorModeScale = _scale;
  }

  public function cos(_a:Float):Float
  {
    return Math.cos(_a);
  }

  public function createGraphics(_width:Int, _height:Int):Sketch
  {
    var _sketch = new Sketch();
    _sketch.size(_width, _height);
    return _sketch;
  }

  public function createImage(_width:Int, _height:Int):BitmapData
  {
    return new BitmapData(_width, _height, false);
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

  public function fill(_color:Int, ?_alpha:Float):Void
  {
    _fill = true;
    _fillColor = _color;
    if(_alpha != null) {
      _fillAlpha = _alpha / _colorModeScale;
    } else {
      _fillAlpha = 1;
    }
  }

  public function floor(_a:Float):Int
  {
    return Math.floor(_a);
  }

  public function get(_x:Int, _y:Int):Int
  {
    _rasterize();
    return bitmap.getPixel(_x, _y);
  }

  public function green(_c:Int):Int
  {
    return (_c >> 8) & 255;
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

    _spriteChanged = true;
    _sprite.graphics.lineStyle();
    _sprite.graphics.beginBitmapFill(_img, _mat, false, _smoothing);
    _sprite.graphics.drawRect(_a, _b, _w, _h);
    _sprite.graphics.endFill();
  }

  public function lerp(_a:Float, _b:Float, _t:Float):Float
  {
    return _a + (_t * (_b - _a));
  }

  public function lerpColor(_c1:Int, _c2:Int, _t:Float):Int
  {
    if(_t > 1) _t = 1;
    if(_t < 0) _t = 0;
    
    return floor(lerp(red(_c1), red(_c2), _t)) << 16 |
           floor(lerp(green(_c1), green(_c2), _t)) << 8 |
           floor(lerp(blue(_c1), blue(_c2), _t));
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

  public function loadPixels():Void
  {
    _rasterize();
    var ba:ByteArray = bitmap.getPixels(new Rectangle(0, 0, width, height));
    pixels = new Array<Int>();
    ba.position = 0;
    for(i in 0...width*height) {
      pixels.push(ba.readUnsignedInt());
    }
  }

  public function noFill():Void
  {
    _fill = false;
    _fillColor = 0xFFFFFF;
    _fillAlpha = 1;
  }

  public function noise(_x:Float, ?_y:Float, ?_z:Float):Float
  {
    if(_noiseProfile == null) {
      _noiseProfile = new Map<Int,PerlinNoise>();
    }

    if(!_noiseProfile.exists(_noiseSeed)) {
      _noiseProfile[_noiseSeed] = new PerlinNoise(_noiseSeed);
    }

    var effect:Float = 1, k:Float = 1, sum:Float = 0;
    for(i in 0..._noiseProfile[_noiseSeed].octaves) {
      effect *= _noiseProfile[_noiseSeed].falloff;
      if(_z != null) {
        sum += effect * (1 + _noiseProfile[_noiseSeed].noise3d(k*_x, k*_y, k*_z))/2;
      } else if(_y != null) {
        sum += effect * (1 + _noiseProfile[_noiseSeed].noise2d(k*_x, k*_y))/2;
      } else {
        sum += effect * (1 + _noiseProfile[_noiseSeed].noise1d(k*_x))/2;
      }
      k *= 2;
    }
    return sum;
  }

  public function noiseSeed(_seed:Int):Void
  {
    _noiseSeed = _seed;
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
    _spriteChanged = true;
    _sprite.transform.matrix = _matrixStack.pop();
  }

  public function pushMatrix():Void
  {
    _matrixStack.push(_sprite.transform.matrix.clone());
  }

  public function random(_a:Float, ?_b:Float):Float
  {
    if(_b != null) {
      return (Math.random() * _b) + _a;
    }
    return Math.random() * _a;
  }

  public function rect(_x:Int, _y:Int, _w:Int, _h:Int):Void
  {
    _startShape();
    _sprite.graphics.drawRect(_x, _y, _w, _h);
    _endShape();
  }

  public function red(_c:Int):Int
  {
    return (_c >> 16) & 255;
  }

  public function set(_x:Int, _y:Int, _color:Int):Void
  {
    _rasterize();
    return bitmap.setPixel(_x, _y, _color);
  }

  public function sin(_a:Float):Float
  {
    return Math.sin(_a);
  }

  public function size(_width:Int, _height:Int):Void
  {
    width = _width; height = _height;
    bitmap = new BitmapData(width, height);
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
    _spriteChanged = true;
    _sprite.transform.matrix.translate(_x, _y);
  }

  public function updatePixels():Void
  {
    var ba:ByteArray = new ByteArray(); 
    for(i in 0...pixels.length) {
      ba.writeUnsignedInt(pixels[i] | 0xFF000000);
    }
    ba.position = 0;
    bitmap.setPixels(new Rectangle(0, 0, width, height), ba);
  }

  private function _startShape():Void
  {
    _spriteChanged = true;
    if(_fill) _sprite.graphics.beginFill(_fillColor, _fillAlpha);
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

  private function _rasterize():Void
  {
    if(_spriteChanged) {
      _spriteChanged = false;
      bitmap.draw(_sprite);
      _sprite.graphics.clear();
    }
  }
}
