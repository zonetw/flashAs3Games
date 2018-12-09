package idv.zone.controllerState {
	import idv.zone.SystemData;
	public class None implements IInput
	{
		private var data:ControllerState;
		private var _dispatcher:GameEventDispatcher;
		
		public function None(data:ControllerState) {
			this.data=data;
			_dispatcher=GameEventDispatcher.getInstance();
		}
		
		public function initial() : void {
			if(SystemData.DEBUG_LV<=1)
			{ 
				trace("input:None");
			}
			this.data.direction=this.data.directionNone;
			this._dispatcher.dispatchGameEvent(data.stopMoveEvent);
		}

		public function keyDown(direction : int) : void {
			this.data.direction=direction;
			this.data.setState(this.data.p1);
		}

		public function keyUp(direction : int) : void {
			throw new Error("None:KeyUp 邏輯有問題");
		}
	}
}