package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width=800, height=454, frameRate=24,backgroundColor=0x000000)]
	public class ClickBublesProject extends Sprite
	{
		private var _mainUI : MovieClip;
		private var _targetList : Array;
		private var _onMov : Boolean;
		private var _chooseList : Array;
		private var _curIndex : uint;
		
		public function ClickBublesProject()
		{
			initUI();
			initPanel();
			initEvent();
			_mainUI["mcStartPanel"].visible = true;
			_mainUI["mcResultPanel"].visible = false;
		}
		
		private function initUI():void
		{
			_mainUI = new UI_CBMain();
			this.addChild(_mainUI);
		}
		
		private function initPanel():void
		{
			for(var i:int=1;i<=15;i++)
			{
				_mainUI["mc_"+i].mouseEnabled = false;
				_mainUI["mc_"+i].mouseChildren = false;
				_mainUI["mc_"+i].visible = false;
				_mainUI["mc_"+i].gotoAndStop(1);
				_mainUI["mcMov_"+i].buttonMode = true;
				_mainUI["mcMov_"+i].mouseChildren = false;
				_mainUI["mcMov_"+i].gotoAndStop(1);
				_mainUI["mcMov_"+i].visible = true;
			}
		}
		
		private function initData():void
		{
			_onMov = false;
			_chooseList = [];
			_targetList = [];
			for(var i:int=1;i<=5;i++)
			{
				for(var j:int=1; j <= 3; j++)
				{
					_targetList.push(i);
				}
			}
			randomList(_targetList);
		}
		
		private function resetPanel():void
		{
			for(var i:int=1;i<=15;i++)
			{
				_mainUI["mc_"+i].gotoAndStop(_targetList[i-1]);
			}
		}
		
		private function randomList(list : Array):void
		{
			var randomIndex : int;
			var temp : int;
			for(var i:int=0;i<list.length;i++)
			{
				randomIndex = uint(list.length * Math.random());
				temp = list[randomIndex];
				list[randomIndex] = list[i];
				list[i] = temp;
			}
		}
		
		private function initEvent():void
		{
			for(var i:int=1;i<=15;i++)
			{
				_mainUI["mcMov_"+i].addEventListener(MouseEvent.CLICK,onMovClick);
			}
			_mainUI["mcStartPanel"]["btnStart"].addEventListener(MouseEvent.CLICK,onStartClick);
			_mainUI["mcResultPanel"]["btnReplay"].addEventListener(MouseEvent.CLICK,onReplayClick);
		}
		
		private function onStartClick(e : MouseEvent):void
		{
			_mainUI["mcStartPanel"].visible = false;
			initPanel();
			initData();
			resetPanel();
		}
		
		private function onReplayClick(e : MouseEvent):void
		{
			_mainUI["mcResultPanel"].visible = false;
			_mainUI["mcStartPanel"].visible = true;
		}
		
		private function onMovClick(e : MouseEvent):void
		{
			if(_onMov)
			{
				return;
			}
			_onMov = true;
			_curIndex = uint(e.target.name.split("_")[1]);
			trace(_targetList[_curIndex-1]);
			_chooseList.push(_targetList[_curIndex-1]);
			_mainUI["mcMov_"+_curIndex].gotoAndPlay(1);
			_mainUI["mcMov_"+_curIndex].addEventListener(Event.ENTER_FRAME,onMovFrame);
		}
		
		private function onMovFrame(e : Event):void
		{
			var mc : MovieClip = e.target as MovieClip;
			if(mc.currentFrame == mc.totalFrames)
			{
				mc.stop();
				mc.visible = false;
				mc.removeEventListener(Event.ENTER_FRAME,onMovFrame);
				_mainUI["mc_"+_curIndex].visible = true;
				checkResult();
			}
		}
		
		private function checkResult():void
		{
			if(_chooseList.length >= 2)
			{
				var isWin : Boolean = false;
				for(var i:int=0;i<_chooseList.length-1;i++)
				{
					for(var j:int=i+1;j<_chooseList.length;j++)
					{
						if(_chooseList[i] == _chooseList[j])
						{
							isWin = true;
							break;
						}
					}
					if(isWin) 
						break;
				}
			}
			if(isWin)
			{
				//游戏成功，跳结算界面
				showResultPanel(1);
			}else
			{
				if(_chooseList.length >= 3)
				{
					//游戏结束，失败
					showResultPanel(2);
				}else
				{
					_onMov = false;
				}
			}
		}
		
		private function showResultPanel(result : uint):void
		{
			_mainUI["mcResultPanel"].visible = true;
			_mainUI["mcResultPanel"]["mcTitle"].gotoAndStop(result);
		}
		
	}
}