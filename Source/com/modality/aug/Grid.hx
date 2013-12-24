package com.modality.aug;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

class Grid<T:(Block)>
{
  public static var COLS:Int = 5;
  public static var ROWS:Int = 5;
  public static var BLOCK_W:Int = 100;
  public static var BLOCK_H:Int = 100;

  public var scene:Scene;
  public var blocks:Array<Array<T>>;

  public function new(_x:Int = 0, _y:Int = 0, _scene)
  {
    scene = _scene;
    blocks = [];
  }

  public function init(createFn:Int->Int->T):Void
  {
    for(j in 0...ROWS) {
      var rowArray:Array<T> = []; 
      for(i in 0...COLS) {
        var block:T = createFn(i,j);
        block.setIndex(i, j);
        rowArray.push(block); 
      }
      blocks.push(rowArray);
    }

    for(j in 0...ROWS) {
      for(i in 0...COLS) {
        var block:Block = getBlock(i, j);
        scene.add(block);
      }
    }
  }

  public function getBlock(i:Int, j:Int):T
  {
    if(i < 0 || i >= COLS) return null;
    if(j < 0 || j >= ROWS) return null;

    return blocks[j][i];
  }

  public function setBlock(i:Int, j:Int, _state_str:String):Void
  {
    if(i < 0 || i >= COLS) return;
    if(j < 0 || j >= ROWS) return;
    getBlock(i, j).changeState(_state_str);
  }

  public function fillGrid(_state_str:String):Void
  {
    for(j in 0...ROWS) {
      for(i in 0...COLS) {
        setBlock(i, j, _state_str);
      }
    }
  }

  public function eachBlock(fn:T->Int->Int->Void)
  {
    for(j in 0...ROWS) {
      for(i in 0...COLS) {
        fn(getBlock(i, j), i, j);
      }
    }
  }
}
