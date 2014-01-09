package com.modality.aug;

class Grid<T:(Block)>
{
  public var x:Int;
  public var y:Int;
  public var width:Int;
  public var height:Int;
  public var createFn:Int->Int->T;

  public var blocks:Array<Array<T>>;

  public function new(_x:Int, _y:Int, _width:Int, _height:Int, _createFn:Int->Int->T)
  {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    blocks = [];
    createFn = _createFn;
    for(j in 0...height) {
      var rowArray:Array<T> = []; 
      for(i in 0...width) {
        var block:T = createFn(i,j);
        block.setIndex(i, j);
        rowArray.push(block); 
      }
      blocks.push(rowArray);
    }
  }

  public function get(i:Int, j:Int):T
  {
    if(i < 0 || i >= width) return null;
    if(j < 0 || j >= height) return null;

    return blocks[j][i];
  }

  public function set(i:Int, j:Int, block:T):Void
  {
    if(i < 0 || i >= width) return;
    if(j < 0 || j >= height) return;

    blocks[j][i] = block;
  }

  public function getState(i:Int, j:Int):String
  {
    if(i < 0 || i >= width) return null;
    if(j < 0 || j >= height) return null;
    return get(i, j).state_str;
  }

  public function setState(i:Int, j:Int, _state_str:String):Void
  {
    if(i < 0 || i >= width) return;
    if(j < 0 || j >= height) return;
    get(i, j).changeState(_state_str);
  }

  public function fillGrid(_state_str:String):Void
  {
    for(j in 0...height) {
      for(i in 0...width) {
        setState(i, j, _state_str);
      }
    }
  }

  public function each(fn:T->Int->Int->Void):Void
  {
    for(j in 0...height) {
      for(i in 0...width) {
        fn(get(i, j), i, j);
      }
    }
  }

  public function map(fn:T->Int->Int->T):Grid<T>
  {
    var mapped:Grid<T> = new Grid(x, y, width, height, createFn);
    for(j in 0...height) {
      for(i in 0...width) {
        mapped.blocks[j][i] = fn(get(i,j), i, j);
      }
    }
    return mapped;
  }

  public function filter(fn:T->Int->Int->Bool):Array<T>
  {
    var match:Array<T> = [];
    for(j in 0...height) {
      for(i in 0...width) {
        if(fn(get(i, j), i, j)) {
          match.push(get(i, j));
        }
      }
    }
    return match;
  }

  public function neighbors(block:T):Array<T>
  {
    var match:Array<T> = [];

    match.push(get(block.x_index-1, block.y_index));
    match.push(get(block.x_index+1, block.y_index));
    match.push(get(block.x_index, block.y_index-1));
    match.push(get(block.x_index, block.y_index+1));

    return match.filter(function(x:T) { return x != null; });
  }
}
