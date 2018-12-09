package idv.zone.view {
	import idv.zone.view.blocks.Block7;
	import idv.zone.view.blocks.Block6;
	import idv.zone.view.blocks.Block5;
	import idv.zone.view.blocks.Block4;
	import idv.zone.view.blocks.Block3;
	import idv.zone.view.blocks.Block2;
	import idv.zone.view.blocks.Block1;
	import idv.zone.SystemData;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	import idv.zone.data.GameEvent;
	import idv.zone.data.SquareData;

	import flash.display.Sprite;

	/**
	 * @author zone
	 */
	public class SquareOnMap extends Sprite {
		protected var _blockSize : int = 15;
		protected var _dispatcher : GameEventDispatcher;
		protected var _bitmapData : BitmapData;
		protected var _bitmap : Bitmap;
		protected var _size : int;

		public function SquareOnMap() {
			_dispatcher = GameEventDispatcher.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, initial);
			_size = _blockSize * SquareData.SIZE;
			// _bitmapData = new BitmapData(_size, _size);
			// _bitmap = new Bitmap(_bitmapData);
			// addChild(_bitmap);
		}

		protected function initial(event : Event) : void {
			this._dispatcher.addEventListener(GameEvent.UPDATE_SQUARE_DATA, updateLook);
		}

		protected function updateLook(event : GameEvent) : void {
			while (numChildren > 0) {
				removeChildAt(0);
			}

			if (SystemData.DEBUG_LV <= 8) {
				trace("SquareOnMap:開始繪製裡面的內容");
			}
			// _bitmapData = new BitmapData(_size, _size);
			var data : SquareData = SquareData(event.data);
			var shape : int = data.shape;
			var block : Sprite;

			for (var i : int = 0;i < data.detail.length;++i) {
				for (var j : int = 0;j < data.detail[0].length;++j) {
					if (data.detail[i][j] > 0) {
						var xPos : int = j * _blockSize;
						var yPos : int = i * _blockSize;

						switch(shape) {
							case 1:
								block = new Block1();
								break;
							case 2:
								block = new Block2();
								break;
							case 3:
								block = new Block3();
								break;
							case 4:
								block = new Block4();
								break;
							case 5:
								block = new Block5();
								break;
							case 6:
								block = new Block6();
								break;
							case 7:
								block = new Block7();
								break;
						}

						// _bitmapData.fillRect(new Rectangle(xPos, yPos, _blockSize, _blockSize), color);
						block.x = xPos;
						block.y = yPos;
						addChild(block);
					}
				}
			}

			if (SystemData.DEBUG_LV <= 8) {
				trace("SquareOnMap:繪製完畢");
			}
		}

		public function get blockSize() : int {
			return _blockSize;
		}

		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}
	}
}
