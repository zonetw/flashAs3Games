package idv.zone.view {
	import flash.events.Event;
	import idv.zone.data.GameEvent;
	/**
	 * @author zone
	 */
	public class SquareNext extends SquareOnMap {
		public function SquareNext() {
			_blockSize=10;
			super();
		}

		override protected function initial(event:Event) : void {
			this._dispatcher.addEventListener(GameEvent.UPDATE_NEXT_SQUARE_DATA, updateLook);
		}
	}
}
