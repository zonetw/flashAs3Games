package idv.zone.data {
	import idv.zone.SystemData;

	public class MapData {
		public static const MAP_WIDTH : int = 10;
		public static const MAP_HEIGHT : int = 25;
		// 記錄目前map的方塊配置
		private var _detail : Vector.<Vector.<uint>>;
		private var _dispatcher : GameEventDispatcher;
		private var _leftLines : int;

		public function MapData() {
			_dispatcher = GameEventDispatcher.getInstance();
			this._dispatcher.addEventListener(GameEvent.GAME_RESTART,restartGame);
			resetData();
		}

		private function restartGame(event : GameEvent) : void {
			resetData();
		}

		private function resetData() : void {
			_detail = new <Vector.<uint>>[];
			for (var i : int = 0;i < MAP_HEIGHT;++i) {
				_detail[i] = new Vector.<uint>(MAP_WIDTH, true);
			}
			_leftLines = 10;
			updateLeftLines(0);

			// 通知map清空畫面
			this._dispatcher.dispatchGameEvent(GameEvent.CLEAR_MAP);
		}

		// 把square上面的資料複製到map上面
		public function stickSquareToMap(square : SquareData) : void {
			this._dispatcher.dispatchGameEvent(GameEvent.ADD_SQUARE, square);

			var vPosSquare : int = square.edgeTop;
			var vPosMap : int = square.y + square.edgeTop;
			var hPosSquare : int;
			var hPosMap : int;
			var counterForEmptyCheck : int;
			var cancelLinesCounter : int = 0;
			var canceldLines : Vector.<uint>=new Vector.<uint>();

			for (;vPosSquare <= square.edgeBottom;++vPosSquare,++vPosMap) {
				hPosSquare = square.edgeLeft;
				hPosMap = square.x + square.edgeLeft;
				counterForEmptyCheck = 0;

				for (;hPosSquare <= square.edgeRight;++hPosSquare,++hPosMap) {
					_detail[vPosMap][hPosMap] += square.detail[vPosSquare][hPosSquare];
					if((vPosMap<=5)&&(_detail[vPosMap][hPosMap]>0))
					{
						this._dispatcher.dispatchGameEvent(GameEvent.GAME_OVER,"lose");
					}
				}

				for (var i : int = 0;i < MAP_WIDTH;i++) {
					if (0 == _detail[vPosMap][i]) {
						++counterForEmptyCheck;
					}
				}

				if (0 == counterForEmptyCheck) {
					// 更新map的資料
					_detail.splice(vPosMap, 1);
					_detail.unshift(new Vector.<uint>(MAP_WIDTH, true));

					// 記錄1.被消除的列編號 以及2.總共消除幾行
					canceldLines[cancelLinesCounter] = vPosMap;
					++cancelLinesCounter;
				}
			}
			// 統計完後發出事件
			if (cancelLinesCounter > 0) {
				var data : Array = [canceldLines, cancelLinesCounter, _detail];
				this._dispatcher.dispatchGameEvent(GameEvent.EMPTY_LINES, data);
				updateLeftLines(cancelLinesCounter);
			}

			if (SystemData.DEBUG_LV <= 8) {
				trace("\nmapData:update後");
				for (vPosSquare = 0;vPosSquare < MAP_HEIGHT;++vPosSquare) {
					trace(_detail[vPosSquare][0] + "," + _detail[vPosSquare][1] + "," + _detail[vPosSquare][2] + "," + _detail[vPosSquare][3] + "," + _detail[vPosSquare][4] + "," + _detail[vPosSquare][5] + "," + _detail[vPosSquare][6] + "," + _detail[vPosSquare][7] + "," + _detail[vPosSquare][8] + "," + _detail[vPosSquare][9]);
				}
			}
		}

		private function updateLeftLines(cancelLinesCounter : int) : void {
			if ((_leftLines - cancelLinesCounter) <= 0) {
				_leftLines=0;
				this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_LEFT_LINES, 0);
				this._dispatcher.dispatchGameEvent(GameEvent.GAME_OVER,"win");
			} else {
				_leftLines-=cancelLinesCounter;
				this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_LEFT_LINES, _leftLines);
			}
		}

		public function get detail() : Vector.<Vector.<uint>> {
			return _detail;
		}
	}
}