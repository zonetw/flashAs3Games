package idv.zone.view {
	import flash.display.Sprite;
	import flash.text.TextField;

	import idv.zone.data.GameEvent;

	public class Score extends Sprite {
		private var _score : int;
		public var textField : TextField;
		private var _dispatcher : GameEventDispatcher;

		public function Score() {
			_dispatcher = GameEventDispatcher.getInstance();
			this._dispatcher.addEventListener(GameEvent.GAME_START, resetData);
			textField.selectable=false;
			//resetData(null);
		}

		private function resetData(event : GameEvent) : void {
			_score = 0;
			textField.text = String(_score);
			trace("初始化分數設定");
			setupListener();
		}

		private function setupListener() : void {
			this._dispatcher.addEventListener(GameEvent.UPDATE_SCORE, updateScore);
			//this._dispatcher.addEventListener(GameEvent.GAME_OVER, over);
		}

//		private function over(event : GameEvent) : void {
//			removeListener();
//		}
//
//		private function removeListener() : void {
//			this._dispatcher.removeEventListener(GameEvent.UPDATE_SCORE, updateScore);
//			this._dispatcher.removeEventListener(GameEvent.GAME_OVER, over);
//		}

		private function updateScore(event : GameEvent) : void {
			trace("接收到分數="+event.data);
			textField.text = String(event.data);
		}
	}
}