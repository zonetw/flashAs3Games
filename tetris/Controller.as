package {
	import idv.zone.data.GameEvent;
	import idv.zone.SystemData;
	import idv.zone.controllerState.ControllerState;

	import flash.events.KeyboardEvent;

	public class Controller {
		/*----------------常數(Start)-------------------------*/
		public static const DIR_H_NONE : int = 0;
		public static const DIR_H_LEFT : int = -1;
		public static const DIR_H_RIGHT : int = 1;
		public static const DIR_V_NONE : int = 0;
		public static const DIR_V_UP : int = -1;
		public static const DIR_V_DOWN : int = 1;
		/*----------------常數(End)---------------------------*/
		private var _hState : ControllerState;
		private var _vState : ControllerState;
		private var _keyRightPressed : Boolean;
		private var _keyLeftPressed : Boolean;
		private var _keyDownPressed : Boolean;
		private static var _instance : Controller;
		private var _dispatcher : GameEventDispatcher;
		private var _keyRotatePressed : Boolean;

		private function resetData() : void {
			this._hState = new ControllerState(DIR_H_NONE, 0);
			this._vState = new ControllerState(DIR_V_NONE, 1);

			_keyDownPressed = false;
			_keyLeftPressed = false;
			_keyRightPressed = false;
			_keyRotatePressed = false;

			this._dispatcher = GameEventDispatcher.getInstance();
		}

		/*--------消除flash自動觸發的keyDown事件---*/
		public function keyHandler(event : KeyboardEvent) : void {
			if (event.type == KeyboardEvent.KEY_DOWN) {
				switch(event.keyCode) {
					case 37:
						if (!_keyLeftPressed) {
							_keyLeftPressed = true;
							this._hState.keyDown(DIR_H_LEFT);
						}
						break;
					case 39:
						if (!_keyRightPressed) {
							_keyRightPressed = true;
							this._hState.keyDown(DIR_H_RIGHT);
							if (SystemData.DEBUG_LV <= 1) {
								trace("controller:39 keydown");
							}
						}
						break;
					case 40:
						if (!_keyDownPressed) {
							_keyDownPressed = true;
							this._vState.keyDown(DIR_V_DOWN);
						}
						break;
						
					case 38:
						if(!_keyRotatePressed){
							_keyRotatePressed=true;
							this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_SQUARE_ROTATE,1);
						}
					break;
				}
			} else {
				switch(event.keyCode) {
					case 37:
						if (_keyLeftPressed) {
							_keyLeftPressed = false;
							this._hState.keyUp(DIR_H_LEFT);
						}
						break;
					case 39:
						if (_keyRightPressed) {
							_keyRightPressed = false;
							this._hState.keyUp(DIR_H_RIGHT);
						}
						break;
					case 40:
						if (_keyDownPressed) {
							_keyDownPressed = false;
							this._vState.keyUp(DIR_V_DOWN);
						}
						break;
						
					case 38:
						if(_keyRotatePressed)
						{
							_keyRotatePressed=false;
						}
					break;
				}
			}
		}

		/*---------------------------------------------*/
		public function Controller(bk_key : SingletonBlocker) : void {
			if (bk_key == null) {
				throw new Error("請用getInstance");
			} else {
				resetData();
			}
		}

		public static function getInstance() : Controller {
			if (_instance == null) {
				_instance = new Controller(new SingletonBlocker());
			}
			return _instance;
		}
	}
}
class SingletonBlocker {
}