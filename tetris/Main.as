package  {
	import idv.zone.data.GameEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;

	public class Main extends Sprite{
	
		private var _model:Model;
		private var _view:View;
		private var _controller:Controller;
		private var _dispatcher:GameEventDispatcher;
		public function Main() {
			trace(123);
			_dispatcher=GameEventDispatcher.getInstance();						
			_controller=Controller.getInstance();
			_view=View.getInstance();
			this.addChild(_view);
			_model=Model.getInstance();
			this._dispatcher.dispatchGameEvent(GameEvent.GAME_START);			
			this.stage.focus=this.stage;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, _controller.keyHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, _controller.keyHandler);
			
			
		}
	}
}