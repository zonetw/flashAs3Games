package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;

	/**
	 * @author zone
	 */
	public class RotateWAV extends Sound {
		public function RotateWAV(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
