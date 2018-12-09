package {
	import idv.zone.SystemData;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import idv.zone.data.GameEvent;
	import idv.zone.data.MapData;
	import idv.zone.data.SquareData;

	public class Model {
		public const MAIN_TIME_FREQ : int = 400;
		private static var _instance : Model;
		private var _score : int;
		private var _lv : int;
		private var _dispatcher : GameEventDispatcher;
		private var _timer : Timer;
		/*--------------移動相關--------------*/
		private const speedNormal : int = 1;
		private const speedAdd : int = 3;
		private var _directionH : int;
		private var _directionV : int;
		private var _moveSpeedH : int;
		private var _moveSpeedV : int;
		
		private var _square : SquareData;
		private var _nextSquare : SquareData;
		private var _map : MapData;
		private var _running : Boolean;

		private function initilaData() : void {
			_dispatcher = GameEventDispatcher.getInstance();
			_map = new MapData();
			_square = new SquareData(SquareData.KIND_SQUARE);
			_nextSquare = new SquareData(SquareData.KIND_NEXT_SQUARE);
			_timer = new Timer(MAIN_TIME_FREQ);

			_square.updateDetail(randomShape());

			resetData();
			setupListeners();
		}

		private function resetData() : void {
			updateScore((_score*(-1)));
			_score=0;
			_lv = 0;

			_directionH = 0;
			_directionV = 1;
			_moveSpeedV = speedNormal;
			_running = false;
		}


		//事件相關函式
		private function setupListeners() : void {
			_timer.addEventListener(TimerEvent.TIMER, timerEvent);

			_dispatcher.addEventListener(GameEvent.GAME_START, startGame);
			_dispatcher.addEventListener(GameEvent.GAME_RESTART, restartGame);
			_dispatcher.addEventListener(GameEvent.GAME_OVER, stopGame);

			_dispatcher.addEventListener(GameEvent.MOVE_H_ONE_STEP, moveHandler);
			_dispatcher.addEventListener(GameEvent.MOVE_V_ONE_STEP, moveHandler);
			
			_dispatcher.addEventListener(GameEvent.MOVE_H_STOP_MOVE, moveHandler);
			_dispatcher.addEventListener(GameEvent.MOVE_V_STOP_MOVE, moveHandler);
			
			_dispatcher.addEventListener(GameEvent.MOVE_H_ADD_SPEED, moveHandler);
			_dispatcher.addEventListener(GameEvent.MOVE_V_ADD_SPEED, moveHandler);
			
			_dispatcher.addEventListener(GameEvent.UPDATE_DIR_H, moveHandler);
			_dispatcher.addEventListener(GameEvent.UPDATE_DIR_V, moveHandler);

			_dispatcher.addEventListener(GameEvent.UPDATE_SQUARE_ROTATE, rotateSquareCheck);
			_dispatcher.addEventListener(GameEvent.EMPTY_LINES, calScore);
		}
		
		
		private function moveHandler(event : GameEvent) : void {
			switch(event.type) {
				case GameEvent.MOVE_H_ONE_STEP:
					moveSquare(speedNormal * _directionH, 0);
					break;
				case GameEvent.MOVE_V_ONE_STEP:
					moveSquare(0, speedNormal * _directionV);
					break;
					
				case GameEvent.MOVE_H_STOP_MOVE:
					_moveSpeedH = 0;
					_directionH = 0;
					break;
				case GameEvent.MOVE_V_STOP_MOVE:
					_moveSpeedV = speedNormal;
					break;
					
				case GameEvent.MOVE_H_ADD_SPEED:
					_moveSpeedH += speedAdd;
					break;
				case GameEvent.MOVE_V_ADD_SPEED:
					_moveSpeedV += speedAdd;
					break;
					
				case GameEvent.UPDATE_DIR_H:
					_directionH = int(event.data);
					break;
				case GameEvent.UPDATE_DIR_V:
					_directionV = int(event.data);
					break;
			}
		}

		private function startGame(event : GameEvent) : void {
			initialGameStage();
			_timer.start();
		}

		private function initialGameStage() : void {
			_square.updateDetail(randomShape());
			_square.x = 3;
			_square.y = 0;
			_nextSquare.updateDetail(randomShape());
			updateScore(0);
		}

		private function stopGame(event : GameEvent) : void {
			_timer.stop();
		}

		private function restartGame(event : GameEvent) : void {
			resetData();
			_timer.start();
		}

		private function timerEvent(event : TimerEvent) : void {
			refreshMap();

			var h : int = _moveSpeedH * _directionH;
			var v : int = _moveSpeedV * _directionV;
			moveSquare(h, v);
			//moveSquare(h, 20);
		}

		/*-----------功能取向的函式----------------------------------------*/
		private function randomShape() : int {
			return uint(Math.random() * 7) + 1;
		}

		// OK
		private function rotateSquareCheck(event : GameEvent) : void {
			_square.rotateSquare(1);
			// 1.檢查是否出界
			if (
			(_square.x + _square.edgeLeft < 0) || (_square.x + _square.edgeRight >= MapData.MAP_WIDTH) || (_square.y + _square.edgeBottom >= MapData.MAP_HEIGHT) || (_square.y + _square.edgeTop < 0)
			) {
				if (SystemData.DEBUG_LV <= 9) {
					trace("方塊不可旋轉");
				}

				_square.rotateSquare(-1);
				return;
			} else {
				// 2.檢查是否會碰撞,不會才可以轉

				var counter : int = 0;
				var mapX : int = _square.x;
				var mapY : int = _square.y;

				for (var i : int = _square.edgeTop;i <= _square.edgeBottom;++i) {
					for (var j : int = _square.edgeLeft;j <= _square.edgeRight;++j) {
						if (_map.detail[mapY + i][mapX + j] > 0) {
							++counter;
						}
					}
				}

				if (counter > 0) {
					_square.rotateSquare(-1);
				} else {
					this._dispatcher.dispatchGameEvent(GameEvent.UPDATE_SQUARE_DATA, _square);
				}
			}
		}

		private function refreshMap() : void {
			// 試著移動方塊,如果不能動就代表已經到底
			if (_running == true) {
				if (checkMovement(0, 1)[1] == 0) {
					_dispatcher.dispatchGameEvent(GameEvent.UPDATE_MAP, _square);
					_map.stickSquareToMap(_square);
					_square.x = 3;
					_square.y = 0;
					_square.updateDetail(_nextSquare.shape);
					_nextSquare.updateDetail(randomShape());
				}
			} else {
				_running = true;
			}
		}

		private function moveSquare(xMove : int, yMove : int) : void {
			var data : Array = checkMovement(xMove, yMove);
			_square.x += data[0] ;
			_square.y += data[1];
			data = [_square.x, _square.y];
			_dispatcher.dispatchGameEvent(GameEvent.UPDATE_SQUARE_POS, data);
		}

		// 傳入xy預計要移動的向量,傳回調整後的向量
		private function checkMovement(xMove : int, yMove : int) : Array {
			// 1.邊界測試OK
			var squareLeftOnMap : int = _square.x + _square.edgeLeft;
			var squareRightOnMap : int = _square.x + _square.edgeRight;
			var squareTopOnMap : int = _square.y + _square.edgeTop;
			var squareBottomOnMap : int = _square.y + _square.edgeBottom;

			if (xMove != 0) {
				// 水平的兩個邊界只有一個會成立
				if (squareLeftOnMap + xMove < 0 ) {
					xMove = squareLeftOnMap * (-1);
				} else if ((squareRightOnMap + xMove) >= MapData.MAP_WIDTH) {
					xMove = MapData.MAP_WIDTH - 1 - squareRightOnMap;
				}
			}

			if ((yMove > 0) && ((squareBottomOnMap + yMove) >= MapData.MAP_HEIGHT) ) {
				yMove = MapData.MAP_HEIGHT - squareBottomOnMap - 1;
			} else if ((yMove < 0) && (squareTopOnMap + yMove) < 0) {
				yMove = -squareTopOnMap;
			}

			// 2.碰撞測試
			// 確認y方向

			// (下)
			var hMap : int = squareLeftOnMap;
			var hSquare : int = _square.edgeLeft;

			var vMap : int = 0;
			var vSquare : int = 0;
			var vCounter : int = 0;
			// 看某行可以移動幾格
			var limit : int = 0;
			var minyMove : int = yMove;

			if (SystemData.DEBUG_LV <= 8) {
				trace("---------------檢查碰撞(y)---------------------");
			}

			if (yMove > 0) {
				for (;hMap <= squareRightOnMap ;++hMap,++hSquare) {
					vMap = _square.y + SquareData.SIZE - _square.spaceBottom[hSquare];
					limit = vMap + yMove;
					vCounter = 0;
					for (;vMap < limit;++vMap,++vCounter) {
						if (SystemData.DEBUG_LV <= 8) {
							trace("_map.detail[" + vMap + "][" + hMap + "]=" + _map.detail[vMap][hMap]);
						}

						if (_map.detail[vMap][hMap] > 0) {
							if (SystemData.DEBUG_LV <= 8) {
								trace("(第" + hMap + "行)可移動:" + (vCounter));
							}
							break;
						}
					}

					if (vCounter < minyMove) {
						minyMove = vCounter;
					}
				}
				yMove = minyMove;
				if (SystemData.DEBUG_LV <= 8) {
					trace('最後的yMove: ' + yMove);
					trace("------------------檢查碰撞(y)結束-----------------");
				}
			} else if (yMove < 0) {
				throw new Error("yMove<0");
			}

			// 測試x方向 這個時候已經往下移動方塊
			var minxMove : int = xMove;
			var hCounter : int;

			if (xMove == 0) {
				// 空
			} else if (xMove > 0) {
				vMap = squareTopOnMap + yMove;
				vSquare = _square.edgeTop;
				for (;vSquare <= _square.edgeBottom ;++vMap,++vSquare) {
					hMap = _square.x + SquareData.SIZE - _square.spaceRight[vSquare];
					hCounter = 0;
					limit = hMap + xMove;
					for (;hMap < limit;++hMap,++hCounter) {
						if (_map.detail[vMap][hMap] > 0) {
							break;
						}
					}

					if (hCounter < minxMove) {
						minxMove = hCounter;
					}
				}
				xMove = minxMove;
			} else {
				vMap = squareTopOnMap + yMove;
				vSquare = _square.edgeTop;

				for (;vSquare <= _square.edgeBottom ;++vMap,++vSquare) {
					hMap = _square.x + _square.spaceLeft[vSquare];
					hCounter = 1;
					limit = hMap + xMove;
					for (;hMap >= limit;--hMap,--hCounter) {
						if (_map.detail[vMap][hMap] > 0) {
							break;
						}
					}
					if (hCounter > minxMove) {
						minxMove = hCounter;
					}
				}
				xMove = minxMove;
			}

			if (SystemData.DEBUG_LV <= 8) {
				trace("***************************");
				trace("最後算出的移動量:[" + xMove + "," + yMove + "]\n");
			}
			return [xMove, yMove];
		}

		// 計算成績
		private function calScore(event : GameEvent) : void {
			var baseScore : int = 100;
			var lines : int = int(event.data[1]);
			var score : int = 1;
			switch(lines) {
				case 1:
					score = baseScore;
					break;
				case 2:
					score = baseScore * lines * 1.5;
					break;
				case 3:
					score = baseScore * lines * 2;
					break;
				default:
					score = baseScore * lines * 4;
					break;
			}
			trace("Model:加分數到score");
			updateScore(score);
		}
		
		//更新成績
		private function updateScore(score : int) : void {
			_score += score;
			_dispatcher.dispatchGameEvent(GameEvent.UPDATE_SCORE, _score);
		}

		/*-------------------------------單體模式-----------------------------*/
		public static function getInstance() : Model {
			if (_instance == null) {
				_instance = new Model(new SingletonBlocker());
			}
			return _instance;
		}

		public function Model(bk_key : SingletonBlocker) : void {
			if (bk_key == null) {
				throw new Error("請用getInstance");
			} else {
				initilaData();
			}
		}
	}
}
class SingletonBlocker {
}