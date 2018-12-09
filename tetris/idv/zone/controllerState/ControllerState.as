package idv.zone.controllerState {
	import idv.zone.SystemData;
	import idv.zone.data.GameEvent;

	public class ControllerState {
		public var direction : int;
		public var _dispatcher : GameEventDispatcher;
		private var currentState : IInput;
		private var _none : None;
		private var _p1 : Phase1;
		private var _p2 : Phase2;
		public var updateDirectionEvent : String;
		public var startMoveEvent : String;
		public var startAddSpeedEvent : String;
		public var stopMoveEvent : String;
		public var directionNone : int;

		public function ControllerState(direction : int, kind : int) {
			if(SystemData.DEBUG_LV<=1)
			{ 
				trace("input State:initial (kind="+kind+")");
			}
			
			this.direction = direction;
			setEvent(kind);
			_none = new None(this);
			_p1 = new Phase1(this);
			_p2 = new Phase2(this);
			currentState = _none;
			_dispatcher = GameEventDispatcher.getInstance();
			this._dispatcher.addEventListener(GameEvent.GAME_RESTART,resetData);
			
		}


		private function setEvent(kind : int) : void {
			switch(kind) {
				case 0:
				this.directionNone=Controller.DIR_H_NONE;
					this.updateDirectionEvent = GameEvent.UPDATE_DIR_H;
					this.startMoveEvent = GameEvent.MOVE_H_ONE_STEP;
					this.startAddSpeedEvent = GameEvent.MOVE_H_ADD_SPEED;
					this.stopMoveEvent=GameEvent.MOVE_H_STOP_MOVE;
					break;
				case 1:
				this.directionNone=Controller.DIR_V_NONE;
					this.updateDirectionEvent = GameEvent.UPDATE_DIR_V;
					this.startMoveEvent = GameEvent.MOVE_V_ONE_STEP;
					this.startAddSpeedEvent = GameEvent.MOVE_V_ADD_SPEED;
					this.stopMoveEvent=GameEvent.MOVE_V_STOP_MOVE;
					break;
			}
		}

		public function resetData(event:GameEvent) : void {
			currentState = _none;
		}

		public function keyDown(direction : int) : void {
			currentState.keyDown(direction);
		}

		public function keyUp(direction : int) : void {
			currentState.keyUp(direction);
		}

		public function setState(state : IInput) : void {
			this.currentState = state;
			this.currentState.initial();
		}

		public function get none() : None {
			return _none;
		}

		public function get p1() : Phase1 {
			return _p1;
		}

		public function get p2() : Phase2 {
			return _p2;
		}
	}
}