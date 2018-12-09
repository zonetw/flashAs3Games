package idv.zone.controllerState{
	public interface IInput {
		function keyDown(direction:int):void;
		function keyUp(direction:int):void;
		function initial():void;
	}
}