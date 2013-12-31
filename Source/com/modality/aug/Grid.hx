package com.modality.aug;

class Grid<T:(Block)>
{
  public var x:Int;
  public var y:Int;
  public var width:Int;
  public var height:Int;

  public var blocks:Array<Array<T>>;

  public function new(_x:Int, _y:Int, _width:Int, _height:Int)
  {
    x = _x;
    y = _y;
    width = _width;
    height = _height;
    blocks = [];
  }

  public function init(createFn:Int->Int->T):Void
  {
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

  public function getBlock(i:Int, j:Int):T
  {
    if(i < 0 || i >= width) return null;
    if(j < 0 || j >= height) return null;

    return blocks[j][i];
  }

  public function setBlock(i:Int, j:Int, _state_str:String):Void
  {
    if(i < 0 || i >= width) return;
    if(j < 0 || j >= height) return;
    getBlock(i, j).changeState(_state_str);
  }

  public function fillGrid(_state_str:String):Void
  {
    for(j in 0...height) {
      for(i in 0...width) {
        setBlock(i, j, _state_str);
      }
    }
  }

  public function eachBlock(fn:T->Int->Int->Void)
  {
    for(j in 0...height) {
      for(i in 0...width) {
        fn(getBlock(i, j), i, j);
      }
    }
  }
}
