import flash.display.StageAlign;
import flash.display.StageScaleMode;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.modality.galaxia.SectorMenu;
import com.modality.galaxia.Game;
import com.modality.aug.AugTime;

class Main extends Engine
{

	override public function init()
	{
    Assets.init();
    var game:Game = new Game();

    HXP.stage.align = StageAlign.TOP_LEFT;
    HXP.stage.scaleMode = StageScaleMode.NO_SCALE;
    AugTime.setFPS(30);
#if debug
		//HXP.console.enable();
#end
    HXP.scene = new SectorMenu(game);
	}

	public static function main()
	{
	  new Main();
	}

}

