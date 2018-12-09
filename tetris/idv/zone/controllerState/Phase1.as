package idv.zone.controllerState {
	import idv.zone.SystemData;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Phase1 implements IInput {
		private const timerDelay : int = 400;
		private var timer : Timer;
		private var _data : ControllerState;
		private var _dispatcher : GameEventDispatcher;

		public function Phase1(data : ControllerState) {
			_data = data;
			_dispatcher = GameEventDispatcher.getInstance();
		}

		public function initial() : void {
			if (SystemData.DEBUG_LV <= 10) {
				trace("input:P1");
			}
			_dispatcher.dispatchGameEvent(_data.updateDirectionEvent, _data.direction);
			_dispatcher.dispatchGameEvent(_data.startMoveEvent, _data.direction);

			timer = new Timer(timerDelay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerEvent);
			timer.start();
		}

		public function keyDown(direction : int) : void {
			if (direction != _data.direction) {
				_data.direction = direction;
				_dispatcher.dispatchGameEvent(_data.updateDirectionEvent, direction);

				if (timer.running) {
					timer.stop();
					timer.start();
				}
			} else {
				throw new Error("Phase1 KeyDown出問題");
			}
		}

		public function keyUp(direction : int) : void {
			if (direction == _data.direction) {
				stopTimer();
				_data.setState(_data.none);
			}
		}

		private function timerEvent(event : TimerEvent) : void {
			stopTimer();
			_data.setState(_data.p2);
		}

		private function stopTimer() : void {
			if (timer.running) {
				timer.stop();
			}
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerEvent);
			timer = null;
		}
	}
}