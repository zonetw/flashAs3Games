package idv.zone.view.sound {
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;

	/**
	 * @author zone
	 */
	public class BGM extends Sound {
		public function BGM(stream : URLRequest = null, context : SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
