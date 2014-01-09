package com.modality.aug;

class Heap<T>
{
  private var compare:T->T->Int;
  private var nodes:Array<T>;

  public function new(_compare:T->T->Int)
  {
    nodes = new Array<T>();
  }

  public static function insort<T>(array:Array<T>, item:T, cmp:T->T->Int, ?lo:Int, ?hi:Int):Void
  {
    if(lo == null) lo = 0;
    if(hi == null) hi = array.length;

    while(lo < hi) {
      var mid:Int = Math.floor((lo + hi) / 2);
      if(cmp(item, array[mid]) < 0) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    array.insert(lo, item);
  }

  public static function heappush<T>(array:Array<T>, item:T, cmp:T->T->Int):Void
  {
    array.push(item);
    _siftdown(array, 0, array.length - 1, cmp);
  }

  public static function heappop<T>(array:Array<T>, cmp:T->T->Int):T
  {
    var lastelt = array.pop();
    if(array.length == 0) return lastelt;
    
    var returnitem = array[0];
    array[0] = lastelt;
    _siftup(array, 0, cmp);

    return returnitem;
  }

  public static function heapreplace<T>(array:Array<T>, item:T, cmp:T->T->Int):T
  {
    var returnitem = array[0];
    array[0] = item;
    _siftup(array, 0, cmp);
    return returnitem;
  }

  public static function heappushpop<T>(array:Array<T>, item:T, cmp:T->T->Int):T
  {
    if(array.length > 0 && cmp(array[0], item) < 0) {
      var returnitem = array[0];
      array[0] = item;
      _siftup(array, 0, cmp);
      return returnitem;
    }
    return item;
  }

  public static function heapify<T>(array:Array<T>, cmp:T->T->Int):Void
  {
    for(i in [0...floor(array.length / 2)].reverse()) {
      _siftup(array, i, cmp);
    }
  }

  public static function updateItem<T>(array:Array<T>, item:T, cmp:T->T->Int):Void
  {
    var pos = -1;
    for(i in 0...array.length) {
      if(item == array[i]) {
        pos = i;
      }
    }
    if(pos == -1) return;
    _siftdown(array, 0, pos, cmp);
    _siftup(array, pos, cmp);
  }

  public static function nlargest<T>(array:Array<T>, n:Int, cmp:T->T->Int):Array<T>
  {
    var result = array.slice(0, n);
    if(result.length == 0) return result;
    heapify(result, cmp);
    for(elem in array.slice(n)) {
      heappushpop(result, elem, cmp);
    }
    return result.sort(cmp).reverse();
  }

  public static function nsmallest<T>(array:Array<T>, n:Int, cmp:T->T->Int):Array<T>
  {
    var result = [];
    if(n*10 <= array.length) {
      result = array.slice(0, n);
      if(result.length == 0) return result;
      var los = result[result.length - 1];
      for(elem in array.slice(n)) {
        if(cmp(elem, los) < 0) {
          insort(result, elem, 0, null, cmp)
          result.pop();
          los = result[result.length - 1];
        }
      }
      return result;
    }
    heapify(array, cmp);
    for(i in 0...Math.min(n, array.length)) {
      result.push(heappop(array, cmp));
    }
    return result;
  }

  public static function _siftdown<T>(array:Array<T>, startpos:Int, pos:Int, cmp:T->T->Int):Void
  {

  }
}
