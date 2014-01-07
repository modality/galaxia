import flash.display.StageAlign;
import flash.display.StageScaleMode;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.modality.galaxia.Sector;
import com.modality.galaxia.SectorType;
import com.modality.galaxia.Game;
import com.modality.aug.AugTime;
import com.modality.galaxia.Generator;
import com.modality.galaxia.GeneratorStats;
import com.modality.galaxia.Constants;

class Main extends Engine
{

	override public function init()
	{
    Assets.init();
    var game:Game = new Game();

    HXP.stage.align = StageAlign.TOP_LEFT;
    //HXP.stage.scaleMode = StageScaleMode.NO_SCALE;
    AugTime.setFPS(30);
#if debug
		//HXP.console.enable();
#end
#if mobile
    HXP.screen.scale = 2;
    HXP.screen.color = Constants.COLOR_BG;
#end
    
    HXP.scene = new Sector(SectorType.Core); //SectorMenu();

    // STATISTICS OUTPUT
    //Generator.init();
    //var gs:GeneratorStats = new GeneratorStats();
	}

	public static function main()
	{
	  new Main();
	}

}

