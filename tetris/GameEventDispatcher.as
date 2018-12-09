package {
	import idv.zone.data.GameEvent;

	import flash.events.EventDispatcher;

	/*---------發事件用----*/
	public class GameEventDispatcher extends EventDispatcher {
		private static var _instance : GameEventDispatcher;

		public function dispatchGameEvent(type : String, data : Object = null) : Boolean {
			var event : GameEvent = new GameEvent(type, data);
			return super.dispatchEvent(event);
		}

		public function GameEventDispatcher(bk_Key : SingletonBlocker) : void {
			if (bk_Key == null) {
				throw new Error("請用getInstance");
			} else {
				}
		}

		public static function getInstance() : GameEventDispatcher {
			if (!_instance) {
				_instance = new GameEventDispatcher(new SingletonBlocker());
			}

			return _instance;
		}
	}
}
class SingletonBlocker {
}