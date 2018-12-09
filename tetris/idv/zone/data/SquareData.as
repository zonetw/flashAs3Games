package idv.zone.data {
	import idv.zone.SystemData;

	public class SquareData {
		public static const SIZE : int = 5;
		public static const KIND_SQUARE : int = 0;
		public static const KIND_NEXT_SQUARE : int = 1;
		private const MIDDLE : int = 2;
		// 左上角座標
		public var x : int;
		public var y : int;
		private var _detail : Vector.<Vector.<uint>>;
		// 碰撞測試用:看剩下多少空格
		private var _spaceTop : Vector.<uint>;
		private var _spaceBottom : Vector.<uint>;
		private var _spaceLeft : Vector.<uint>;
		private var _spaceRight : Vector.<uint>;
		//
		private var _edgeLeft : int;
		private var _edgeRight : int;
		private var _edgeDown : int;
		private var _edgeUp : int;
		private var _dispatcher : GameEventDispatcher;
		// 0:map上的方塊 1:next方塊
		private var _kind : int;
		// 目前方塊的形狀
		private var _shape : int;

		public function SquareData(squareKind : int) {
			this._dispatcher = GameEventDispatcher.getInstance();
			this._kind = squareKind;
		}

		// 變更種類
		public  function updateDetail(shape : int) : void {
			_detail = new <Vector.<uint>>[new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true)];
			_shape = shape;

			switch(shape) {
				// 直線
				case 1:
					this._detail[2][0] = shape;
					this._detail[2][1] = shape;
					this._detail[2][2] = shape;
					this._detail[2][3] = shape;
					break;
				// Z1
				case 2:
					this._detail[2][1] = shape;
					this._detail[2][2] = shape;
					this._detail[3][2] = shape;
					this._detail[3][3] = shape;
					break;
				// Z2
				case 3:
					this._detail[2][2] = shape;
					this._detail[2][3] = shape;
					this._detail[3][1] = shape;
					this._detail[3][2] = shape;
					break;
				// L1
				case 4:
					this._detail[2][1] = shape;
					this._detail[3][1] = shape;
					this._detail[3][2] = shape;
					this._detail[3][3] = shape;
					break;
				// L2
				case 5:
					this._detail[2][3] = shape;
					this._detail[3][1] = shape;
					this._detail[3][2] = shape;
					this._detail[3][3] = shape;
					break;
				// 凸
				case 6:
					this._detail[2][2] = shape;
					this._detail[3][1] = shape;
					this._detail[3][2] = shape;
					this._detail[3][3] = shape;
					break;
				// 方塊
				case 7:
					this._detail[2][1] = shape;
					this._detail[2][2] = shape;
					this._detail[3][1] = shape;
					this._detail[3][2] = shape;
					break;
			}
			if (SystemData.DEBUG_LV <= 7) {
				trace(this + "更新為:");
				for (var i : int = 0;i < SIZE;++i) {
					trace(_detail[i][0] + "," + _detail[i][1] + "," + _detail[i][2] + "," + _detail[i][3] + "," + _detail[i][4]);
				}
			}

			updateEdge();

			// 完成之後發事件通知view更新
			switch(this._kind) {
				case KIND_SQUARE:
					this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_SQUARE_DATA, this);
					break;
				case KIND_NEXT_SQUARE:
					this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_NEXT_SQUARE_DATA, this);
					break;
			}
		}

		// direction:1 順時針 -1逆時針 (OK)
		public function rotateSquare(direction : int) : void {
			if (_kind != KIND_SQUARE) {
				return;
			}
			if (SystemData.DEBUG_LV <= 2) {
				for (i = 0;i < SIZE;++i) {
					trace(_detail[i][0] + "," + _detail[i][1] + "," + _detail[i][2] + "," + _detail[i][3] + "," + _detail[i][4]);
				}
			}

			var tempVector : Vector.<Vector.<uint>> = new <Vector.<uint>>[new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true), new Vector.<uint>(SIZE, true)];
			var nextI : int;
			var nextJ : int;
			var i : int;
			var j : int;

			for (i = 0; i < SIZE;++i) {
				for (j = 0;j < SIZE;j++) {
					switch(direction) {
						case 1:
							nextI = j;
							nextJ = -i + MIDDLE * 2;
							break;
						case -1:
							nextI = MIDDLE * 2 - j;
							nextJ = i;
							break;
					}
					tempVector[nextI][nextJ] = _detail[i][j];
				}
			}

			_detail = tempVector;

			if (SystemData.DEBUG_LV <= 1) {
				trace("after Rotate");
				trace("detail=");
				for (i = 0;i < SIZE;++i) {
					trace(_detail[i][0] + "," + _detail[i][1] + "," + _detail[i][2] + "," + _detail[i][3] + "," + _detail[i][4]);
				}
			}

			updateEdge();

			this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_SQUARE_DATA, this);
		}

		private function updateEdge() : void {
			var i : int;
			var j : int;
			var k : int ;

			_edgeLeft = SIZE - 1;
			_edgeRight = 0;
			_edgeDown = 0;
			_edgeUp = SIZE - 1;

			// 1.檢查水平方向
			_spaceLeft = new Vector.<uint>(SIZE, true);
			_spaceRight = new Vector.<uint>(SIZE, true);

			for (i = 0;i < SIZE;++i) {
				k = 0;
				j = SIZE - 1;
				for (;j >= 0;--j,++k) {
					if (detail[i][j] > 0) {
						if (j < _edgeLeft) {
							_edgeLeft = j ;
						}
						_spaceLeft[i] = j;
					}

					if (detail[i][k] > 0) {
						if (k > _edgeRight) {
							_edgeRight = k;
						}
						_spaceRight[i] = j;
						// SIZE-1-k;
					}
				}
			}

			// 檢查垂直方向
			_spaceBottom = new Vector.<uint>(SIZE, true);
			_spaceTop = new Vector.<uint>(SIZE, true);

			for (i = _edgeLeft;i <= _edgeRight;++i) {
				j = SIZE - 1;
				k = 0;

				for (;j >= 0;--j,++k) {
					if (detail[j][i] > 0) {
						if (j < _edgeUp) {
							_edgeUp = j;
						}
						_spaceTop[i] = j;
					}

					if (detail[k][i] > 0) {
						if (k > _edgeDown) {
							_edgeDown = k;
						}
						_spaceBottom[i] = j;
					}
				}
			}

			if (SystemData.DEBUG_LV <= 7) {
				trace("SquareData:edgeLeft=" + _edgeLeft + " edgeRight=" + _edgeRight + " edgeUp=" + _edgeUp + " edgeDown=" + _edgeDown);
				trace("_spaceTop=" + _spaceTop[0] + "," + _spaceTop[1] + "," + _spaceTop[2] + "," + _spaceTop[3] + "," + _spaceTop[4]);
				trace("_spaceBottom=" + _spaceBottom[0] + "," + _spaceBottom[1] + "," + _spaceBottom[2] + "," + _spaceBottom[3] + "," + _spaceBottom[4]);
				trace("_spaceLeft=" + _spaceLeft[0] + "," + _spaceLeft[1] + "," + _spaceLeft[2] + "," + _spaceLeft[3] + "," + _spaceLeft[4]);
				trace("_spaceRight=" + _spaceRight[0] + "," + _spaceRight[1] + "," + _spaceRight[2] + "," + _spaceRight[3] + "," + _spaceRight[4]);
			}
		}

		/*------------get set---------------*/
		public function get detail() : Vector.<Vector.<uint>> {
			return _detail;
		}

		public function get edgeLeft() : int {
			return _edgeLeft;
		}

		public function get edgeRight() : int {
			return _edgeRight;
		}

		public function get edgeBottom() : int {
			return _edgeDown;
		}

		public function get edgeTop() : int {
			return _edgeUp;
		}

		public function get bottomGird() : Vector.<uint> {
			return _spaceBottom;
		}

		public function get spaceTop() : Vector.<uint> {
			return _spaceTop;
		}

		public function get spaceBottom() : Vector.<uint> {
			return _spaceBottom;
		}

		public function get spaceLeft() : Vector.<uint> {
			return _spaceLeft;
		}

		public function get spaceRight() : Vector.<uint> {
			return _spaceRight;
		}

		public function get shape() : int {
			return _shape;
		}
	}
}