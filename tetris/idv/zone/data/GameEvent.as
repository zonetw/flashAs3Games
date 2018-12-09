package idv.zone.data {
	import flash.events.Event;
	/**
	 * @author zone
	 */
	public class GameEvent extends Event {

//移動		
		public static const UPDATE_DIR_H : String = "UPDATE_DIR_H";
		public static const UPDATE_DIR_V : String = "UPDATE_DIR_V";

		public static const MOVE_H_ONE_STEP : String = "MOVE_H_START";
		public static const MOVE_H_ADD_SPEED : String = "MOVE_H_ADD_SPEED";
		public static const MOVE_H_STOP_MOVE : String = "MOVE_H_STOP";
		
		public static const MOVE_V_ONE_STEP : String = "MOVE_V_START";
		public static const MOVE_V_ADD_SPEED : String = "MOVE_V_ADD_SPEED";
		public static const MOVE_V_STOP_MOVE : String = "MOVE_V_STOP";
		
		
		
		//方塊
		public static const UPDATE_SQUARE_DATA : String = "SQUARE_DATA_UPDATED";
		public static const UPDATE_NEXT_SQUARE_DATA : String = "NEXT_SQUARE_DATA_UPDATED";
		public static const UPDATE_SCORE : String = "UPDATE_SCORE";
		public static const UPDATE_MAP : String = "UPDATE_MAP";
		
		public static const UPDATE_SQUARE_POS : String = "UPDATE_SQUARE_POS";
		public static const UPDATE_SQUARE_ROTATE : String = "UPDATE_SQUARE_ROTATE";
		
		public static const EMPTY_LINES : String = "EMPTY_LINE";

		public static const ADD_SQUARE : String = "ADD_SQUARE";
		public static const CLEAR_MAP : String = "CLEAR_MAP";
		
		public static const UPDATE_LEFT_LINES : String = "UPDATE_LEFT_LINES";

		//遊戲流程
		public static const GAME_START : String = "GAME_START";
		public static const GAME_RESTART : String = "GAME_RESTART";
		public static const GAME_OVER : String = "GAME_OVER";
		public static const GAME_STOP : String = "GAME_STOP";
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*------------*/
		
		
		
		
		/*------------*/
		public var data:Object;
		
		public function GameEvent(type:String,data:Object)
		{
			super(type);
			this.data=data;
		}
	}
}
