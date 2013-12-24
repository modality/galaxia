package com.modality.aug;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;

import com.haxepunk.graphics.Image;

class Base extends Entity implements IEventDispatcher
{
  private var _dispatcher:EventDispatcher;

  public function new(x:Float = 0, y:Float = 0, graphic:Graphic = null, mask:Mask = null)
  {
    super(x, y, graphic, mask);
    _dispatcher = new EventDispatcher();
  }

  public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, useWeakReference:Bool=false):Void 
  {
    _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
  }

  public function dispatchEvent(event:Event):Bool 
  {
    return _dispatcher.dispatchEvent(event);
  }

  public function hasEventListener(type:String):Bool 
  {
    return _dispatcher.hasEventListener(type);
  }

  public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void
  {
    _dispatcher.removeEventListener(type, listener, useCapture);
  }

  public function willTrigger(type:String):Bool
  { 
    return _dispatcher.willTrigger(type);
  }

  public function setAlpha(alpha:Float):Void
  {
    cast(this.graphic, Image).alpha = alpha;
  }
}

