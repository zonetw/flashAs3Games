package {
	import idv.zone.view.SoundMgr;
	import idv.zone.view.ReplayMenu;
	import idv.zone.data.GameEvent;

	import flash.display.Sprite;

	public class View extends Sprite {
		private static var _instance : View;
		private var _dispatcher : GameEventDispatcher;
		private var _replayMenu : ReplayMenu;
		private var _soundMgr:SoundMgr;
		
		private function resetData() : void {
			_dispatcher = GameEventDispatcher.getInstance();
			_dispatcher.addEventListener(GameEvent.GAME_RESTART, gameRestart);
			this._dispatcher.addEventListener(GameEvent.GAME_OVER, gameOver);
			_replayMenu = new ReplayMenu();
			_replayMenu.alpha = 0;
			addChild(_replayMenu);
			
			_soundMgr=new SoundMgr();
		}

		private function gameRestart(event : GameEvent) : void {
			trace("移除replayMenu");
			// removeChild(_replayMenu);
			_replayMenu.alpha = 0;
		}

		private function gameOver(event : GameEvent) : void {
			_replayMenu.alpha = 1;
			_replayMenu.displayResult(event);
		}

		public function View(bk_key : SingletonBlocker) : void {
			if (bk_key == null) {
				throw new Error("請用getInstance");
			} else {
				resetData();
			}
		}

		public static function getInstance() : View {
			if (_instance == null) {
				_instance = new View(new SingletonBlocker());
			}
			return _instance;
		}
	}
}
class SingletonBlocker {
}