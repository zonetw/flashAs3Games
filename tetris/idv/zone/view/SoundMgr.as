package idv.zone.view {
	import idv.zone.view.sound.FallWAV;

	import flash.media.SoundTransform;

	import idv.zone.SystemData;

	import flash.events.Event;

	import idv.zone.view.sound.RotateWAV;

	import flash.media.Sound;

	import idv.zone.data.GameEvent;
	import idv.zone.view.sound.TouchWAV;

	import flash.media.SoundChannel;

	import idv.zone.view.sound.BGM;
	import idv.zone.view.sound.ClearWAV;
	import idv.zone.view.sound.MoveWAV;

	public class SoundMgr {
		private var _bgm : BGM;
		private var _clearLines : ClearWAV;
		private var _move : MoveWAV;
		private var _touch : TouchWAV;
		private var _rotate : RotateWAV;
		private var _effectChannel : SoundChannel;
		private var _bgmChannel : SoundChannel;
		private var _dispatcher : GameEventDispatcher;
		private var _currentBGM : Sound;
		private var _fall : FallWAV;
		private var _moveEffectChannel : SoundChannel;
		private var _soundtransfrom : SoundTransform;

		public function SoundMgr() {
			_dispatcher = GameEventDispatcher.getInstance();
			_effectChannel = new SoundChannel();
			_moveEffectChannel = new SoundChannel();
			_soundtransfrom = new SoundTransform();
			_soundtransfrom.volume = 0.4;

			_bgmChannel = new SoundChannel();

			_bgm = new BGM();
			_currentBGM = _bgm;

			_move = new MoveWAV();
			_fall = new FallWAV();
			_touch = new TouchWAV();
			_clearLines = new ClearWAV();
			_rotate = new RotateWAV();

			setupListeners();
		}

		private function setupListeners() : void {
			this._dispatcher.addEventListener(GameEvent.GAME_START, bgmHandler);
			this._dispatcher.addEventListener(GameEvent.GAME_RESTART, bgmHandler);
			this._dispatcher.addEventListener(GameEvent.GAME_OVER, bgmHandler);

			this._dispatcher.addEventListener(GameEvent.MOVE_V_ADD_SPEED, moveeffectHandler);
			this._dispatcher.addEventListener(GameEvent.MOVE_V_STOP_MOVE, moveeffectHandler);
			this._dispatcher.addEventListener(GameEvent.MOVE_H_ONE_STEP, moveeffectHandler);
			this._dispatcher.addEventListener(GameEvent.MOVE_V_ONE_STEP, moveeffectHandler);
			this._dispatcher.addEventListener(GameEvent.UPDATE_MAP, effectHandler);
			this._dispatcher.addEventListener(GameEvent.UPDATE_SQUARE_ROTATE, effectHandler);
			this._dispatcher.addEventListener(GameEvent.EMPTY_LINES, effectHandler);

			_bgmChannel.addEventListener(Event.SOUND_COMPLETE, bgmReplay);
		}

		private function moveeffectHandler(event : GameEvent) : void {
			_moveEffectChannel.stop();
						

			switch(event.type) {
				case GameEvent.MOVE_H_ONE_STEP:
				case GameEvent.MOVE_V_ONE_STEP:
					_moveEffectChannel = _move.play();
					_moveEffectChannel.soundTransform=_soundtransfrom;
					break;
				case GameEvent.MOVE_V_ADD_SPEED:
					_moveEffectChannel = _fall.play(0, 9999);
					_moveEffectChannel.soundTransform=_soundtransfrom;
					break;
				case GameEvent.MOVE_V_STOP_MOVE:
					//
					break;
			}
		}

		private function bgmReplay(event : Event) : void {
			if (SystemData.DEBUG_LV <= 11) {
				trace("bgm播放完畢");
			}
			_bgmChannel = _currentBGM.play();
		}

		private function effectHandler(event : GameEvent) : void {
			_effectChannel.stop();
			var tempSound : Sound;
			switch(event.type) {
				case GameEvent.UPDATE_MAP:
					tempSound = _touch;
					break;
				case GameEvent.UPDATE_SQUARE_ROTATE:
					tempSound = _rotate;
					break;
				case GameEvent.EMPTY_LINES:
					tempSound = _clearLines;
					break;
			}
			_effectChannel = tempSound.play(0, 1);
		}

		private function bgmHandler(event : GameEvent) : void {
			_bgmChannel.stop();
			switch(event.type) {
				case GameEvent.GAME_START:
				case GameEvent.GAME_RESTART:
					_currentBGM = _bgm;
					_bgmChannel = _bgm.play(0, 999);
					var soundTransform : SoundTransform = new SoundTransform();
					soundTransform.volume = 0.6;
					_bgmChannel.soundTransform = soundTransform;
					trace(_bgmChannel.soundTransform.volume);
					break;
				case GameEvent.GAME_OVER:
					//
					break;
			}
		}
	}
}