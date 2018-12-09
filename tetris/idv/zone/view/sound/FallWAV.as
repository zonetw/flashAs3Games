package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author zone
	 */
	public class FallWAV extends Sound {
		public function FallWAV(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
