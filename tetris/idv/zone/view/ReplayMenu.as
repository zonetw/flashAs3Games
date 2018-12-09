package idv.zone.view {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import idv.zone.data.GameEvent;

	import flash.text.TextField;

	/**
	 * @author zone
	 */
	public class ReplayMenu extends MovieClip {
		public var result : TextField;
		public var replayButton : ReplayButton;
		private var _dispatcher : GameEventDispatcher;

		public function ReplayMenu() {
			_dispatcher = GameEventDispatcher.getInstance();
			//this._dispatcher.addEventListener(GameEvent.GAME_OVER, displayResult);
			result.selectable = false;

			replayButton.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			replayButton.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			replayButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
		}

		private function mouseEventHandler(event : MouseEvent) : void {
			switch(event.type) {
				case MouseEvent.MOUSE_OVER:
				replayButton.gotoAndStop("mouseOver");
					break;
				case MouseEvent.MOUSE_OUT:
				replayButton.gotoAndStop("first");
					break;
				case MouseEvent.MOUSE_DOWN:
				replayButton.gotoAndStop("mouseDown");
				this._dispatcher.dispatchGameEvent(GameEvent.GAME_RESTART);
					break;
			}
		}

		public function displayResult(event : GameEvent) : void {
			switch(String(event.data)) {
				case "win":
					result.text = "YOU WIN";
					break;
				case "lose":
					result.text = "YOU LOSE";
					break;
			}
		}
	}
}
