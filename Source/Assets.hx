import com.haxepunk.HXP;

class Assets
{
  public static var SECTOR_SELECT;
  public static var SECTOR_ICON;
  public static var SECTOR_OFF_ICON;
  public static var SECTOR_ON_ICON;
  public static var STAR_ICON;
  public static var PLANET_ICON;
  public static var UNEXPLORED_ICON;
  public static var VOID_ICON;

  public static function init()
  {
    SECTOR_SELECT = "assets/sector_select.png";
    SECTOR_ICON = "assets/sector_icon.png";
    SECTOR_ON_ICON = "assets/sector_template.png";
    SECTOR_OFF_ICON = "assets/sector_template_off.png";
    STAR_ICON = "assets/star.png";
    PLANET_ICON = "assets/planet.png";
    UNEXPLORED_ICON = "assets/unexplored.png";
    VOID_ICON = "assets/void.png";
  }

}
