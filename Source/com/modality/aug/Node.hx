package com.modality.aug;

class Node {
	public var x:Int;
	public var y:Int;
	public var cost:Int;
	public var type(default, set):Type;
	public var parent:Node;
	public var direction:Int;
	public var open:Bool;
	public var close:Bool;
	public var diagonal:Bool;
	private var aStar:AStar;

	//Constructor of the class
	public function new(x:Int, y:Int, ?cost:Int, ?type:Type) {
		this.x = x;
		this.y = y;
		this.cost = Reflect.isObject(cost)?cost:1;
		this.type = Reflect.isObject(type)?type:NORMAL_NODE;
	}

	//Get the list of eight adjacent nodes of this node
	public function getAdjacentNodes(map:Array<Array<Node>>) {
		var list = new Array();
		//var adjacent = [[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1]];
		var adjacent = [[1,0],[0,-1],[-1,0],[0,1]];
		for(i in adjacent){
			if(x+i[0]>=0 && y+i[1] >= 0 && x+i[0] < map.length && y+i[1] < map[x+i[0]].length){
				var node = map[x+i[0]][y+i[1]];
				if(Reflect.isObject(node) && node.type != BREAK_NODE && !node.close){
					list.push(node);
				}
			}
		}
		return list;
	}
	public function set_type(type:Type):Type {
		switch(type){
			case START_NODE:
				this.aStar.startNode = this;
			case END_NODE:
				this.aStar.endNode = this;
			default:
		}
		this.type = type;
		return type;
	}

	public function setTypeByText(type:String):Type {
		switch(type){
			case "START_NODE": set_type(START_NODE);
			case "END_NODE": set_type(END_NODE);
			case "NORMAL_NODE": set_type(NORMAL_NODE);
			case "BREAK_NODE": set_type(BREAK_NODE);
		}
		return this.type;
	}
	//get a distance from startNode
	public function getG():Int {
		var endNode = aStar.endNode;
		var xDistance = cast Math.abs(endNode.x - x);
		var yDistance = cast Math.abs(endNode.y - y);
		var G:Int;
		if (xDistance > yDistance) {
			G = 14*yDistance + 10*(xDistance-yDistance);
		}else{   
			G = 14*xDistance + 10*(yDistance-xDistance);
		}
		return G;
	}
	//get a distance to endNode
	public function getH():Int {
		var endNode = aStar.endNode;
		var xDistance = cast Math.abs(endNode.x - x);
		var yDistance = cast Math.abs(endNode.y - y);
		var H:Int;
		if (xDistance > yDistance) {
			H = 14*yDistance + 10*(xDistance-yDistance);
		}else{   
			H = 14*xDistance + 10*(yDistance-xDistance);
		}
		return H;
	}
	//F = G + H
	public function getF():Int{
		return getH() + getG();
	}
	public function setAStar(as:AStar){
		this.aStar = as;
	}
}
enum Type {
	START_NODE;
	NORMAL_NODE;
	BREAK_NODE;
	END_NODE;
}
