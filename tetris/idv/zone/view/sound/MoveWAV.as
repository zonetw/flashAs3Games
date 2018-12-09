package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author zone
	 */
	public class MoveWAV extends Sound {
		public function MoveWAV(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
