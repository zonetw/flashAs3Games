package idv.zone.view {
	import idv.zone.data.GameEvent;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * @author zone
	 */
	public class LeftLines extends Sprite {
		public var textField:TextField;
		private var _dispatcher:GameEventDispatcher;
		public function LeftLines() {
			_dispatcher=GameEventDispatcher.getInstance();
			this._dispatcher.addEventListener(GameEvent.UPDATE_LEFT_LINES,updateLeftLines);
		}

		private function updateLeftLines(event : GameEvent) : void {
			textField.text=String(event.data);
		}
	}
}
