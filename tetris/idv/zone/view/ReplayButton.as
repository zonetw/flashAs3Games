package idv.zone.view {
	import flash.events.Event;
	import flash.display.MovieClip;

	/**
	 * @author zone
	 */
	public class ReplayButton extends MovieClip {
		public function ReplayButton() {
			addEventListener(Event.ADDED_TO_STAGE, initial);
		}

		private function initial(event : Event) : void {
			addFrameScript(0,stop);
		}
				
	}
}
