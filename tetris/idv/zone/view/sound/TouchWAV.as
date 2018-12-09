package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author zone
	 */
	public class TouchWAV extends Sound {
		public function TouchWAV(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
