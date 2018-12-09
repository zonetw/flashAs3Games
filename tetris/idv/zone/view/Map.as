package idv.zone.view {
	import idv.zone.view.blocks.Block7;
	import idv.zone.view.blocks.Block6;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import idv.zone.view.blocks.CancleBlocks;

	import flash.display.MovieClip;

	import idv.zone.view.blocks.Block5;
	import idv.zone.view.blocks.Block4;
	import idv.zone.view.blocks.Block3;
	import idv.zone.view.blocks.Block2;
	import idv.zone.view.blocks.Block1;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import idv.zone.data.MapData;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import idv.zone.data.SquareData;
	import idv.zone.data.GameEvent;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author zone
	 */
	public class Map extends Sprite {
		private var _dispatcher : GameEventDispatcher;
		private var _squareOnMap : SquareOnMap;
		private var _content : Vector.<Vector.<Sprite>>;
		private var _cancleBlocks : Vector.<MovieClip>;
		private var _timer : Timer;
		
		// 用來暫存map的資料(有消除的時候,重新繪製用)
		private var _mapDetail : Vector.<Vector.<uint>>;
		private const cancelMoviePlayTime : int=400;

		// private var _content:Array;
		public function Map() {
			_dispatcher = GameEventDispatcher.getInstance();
			_squareOnMap = new SquareOnMap();
			_cancleBlocks = new <MovieClip>[];
			_content = new <Vector.<Sprite>>[];
			for (var i : int = 0;i < 25;i++) {
				_content.push(new Vector.<Sprite>(10, true));
			}

			// _bitmapData=new BitmapData(MapData.MAP_WIDTH, MapData.MAP_HEIGHT);
			// _bitmap=new Bitmap(_bitmapData);
			// this.addChild(_bitmap);
			this.addChildAt(_squareOnMap, 0);

			setupListeners();
		}

		private function setupListeners() : void {
			addEventListener(Event.ADDED_TO_STAGE, initial);
			addEventListener(Event.REMOVED_FROM_STAGE, over);

			this._dispatcher.addEventListener(GameEvent.CLEAR_MAP, clearLook);
			this._dispatcher.addEventListener(GameEvent.ADD_SQUARE, updateContent);
			this._dispatcher.addEventListener(GameEvent.EMPTY_LINES, clearLines);
			this._dispatcher.addEventListener(GameEvent.UPDATE_SQUARE_POS, updateSquarePos);
		}

		// OK
		private function updateSquarePos(event : GameEvent) : void {
			_squareOnMap.x = int(event.data[0]) * _squareOnMap.blockSize;
			_squareOnMap.y = int(event.data[1]) * _squareOnMap.blockSize;
		}

		private function clearLook(event : GameEvent) : void {
			if (event == null) {
				trace("由自己觸發");
			} else {
				trace("由事件觸發");
			}
			trace("ClearLook:開始清除Map");

			for (var i : int = 0;i < 25;++i) {
				for (var j : int = 0;j < 10;++j) {
					if (_content[i][j] != null) {
						removeChild(_content[i][j]);
					}
				}
			}

			_content = new <Vector.<Sprite>>[];
			for (i = 0;i < 25;i++) {
				_content.push(new Vector.<Sprite>(10, true));
			}

			while (numChildren == 1) {
				removeChildAt(1);
			}
		}

		// OK
		private function updateContent(event : GameEvent) : void {
			redrawMap(SquareData(event.data).x, SquareData(event.data).y, 5, 5, SquareData(event.data).detail);
		}

		private function redrawMap(xPos : int, yPos : int, width : int, height : int, detail : Vector.<Vector.<uint>>) : void {
			var block : Sprite;
			for (var i : int = 0;i < height;++i) {
				for (var j : int = 0;j < width;++j) {
					if (detail[i][j] > 0) {
						switch(detail[i][j]) {
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
						block.x = (xPos + j) * _squareOnMap.blockSize;
						block.y = (yPos + i) * _squareOnMap.blockSize;
						addChild(block);
						_content[yPos + i][xPos + j] = block;
					}
				}
			}
		}

		// 清除連線
		private function clearLines(event : GameEvent) : void {

			var lines : Vector.<uint>=Vector.<uint>(event.data[0]);
			var line : uint;
			_mapDetail = Vector.<Vector.<uint>>(event.data[2]);
			var cancleBlocks : CancleBlocks;
			for (var i : int = 0;i < lines.length;++i) {
				line = lines[i];
				for (var j : int = 0;j < 10;++j) {
					removeChild(_content[line][j]);
				}

				// 插入消除動畫
				trace("Map:插入一行消除動畫");
				cancleBlocks = new CancleBlocks();
				cancleBlocks.y = line * _squareOnMap.blockSize;
				addChild(cancleBlocks);
				_cancleBlocks.push(cancleBlocks);

				_content.splice(line, 1);
				_content.unshift(new Vector.<Sprite>(10, true));
			}

			// 移動剩下的方塊
			_timer = new Timer(cancelMoviePlayTime, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, cancleTimerEvent);
			_timer.start();
		}

		private function cancleTimerEvent(event : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, cancleTimerEvent);
			_timer.stop();
			_timer = null;

			while(_cancleBlocks.length>0) {
				removeChild(_cancleBlocks[0]);
				_cancleBlocks.splice(0, 1);
			}
			clearLook(null);
			redrawMap(0, 0, 10, 25, _mapDetail);
		}

		/*----------------暫時想不到要寫甚麼-----------------*/
		private function initial(event : Event) : void {
		}

		private function over(event : Event) : void {
		}
	}
}
