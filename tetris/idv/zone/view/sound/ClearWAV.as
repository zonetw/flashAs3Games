package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author zone
	 */
	public class ClearWAV extends Sound {
		public function ClearWAV(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
