package idv.zone.controllerState {
	import idv.zone.SystemData;
	public class Phase2 implements IInput {
		private var _data : ControllerState;
		
		public function Phase2(data:ControllerState) {
			_data=data;
		}
		
		public function initial() : void {
			_data._dispatcher.dispatchGameEvent(_data.startAddSpeedEvent);
			
			if(SystemData.DEBUG_LV<=10)
			{ 
				trace("input:P2");
			}
		}

		public function keyDown(direction : int) : void {
			if(_data.direction!=direction){
				_data.direction=direction;
				_data.setState(_data.p1);
			}
			else{
				throw new Error("Controller判斷有問題");
			}
		}

		public function keyUp(direction : int) : void {
			if(SystemData.DEBUG_LV<=10)
			{ 
				trace("input:p2 keyup");
			}
			if(_data.direction==direction){
				_data.setState(_data.none);
			}
		}
	}
}