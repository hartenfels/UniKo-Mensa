package unikomensa;

using StringTools;

typedef Menu    = {type:String, title:String, text:String};
typedef MenuMap = Map<String, Array<Menu>>;


class Parser
{

    static var MENU_TITLES = [
        "menu1"     => "Menü 1",
        "menuv"     => "Vegetarisch",
        "menue"     => "Extratheke",
        "menua"     => "Abendmensa",
        "menub"     => "Bistro",
        "menuvegan" => "Vegan",
    ];

    var map(default, null) = new MenuMap();


    function parseText(text:String)
    {
        text = ~/\([^\(\)]+\)/g      .replace(text, ""     );
        text = ~/\s+/g               .replace(text, " "    );
        text = ~/\s+([\.,:;?!])*\s*/g.replace(text, "$1 "  );
        return text.trim();
    }

    function parseMenu(menus:Array<Menu>, m:Xml):Void
    {
        var type = m.nodeName;
        if (!MENU_TITLES.exists(type))
            return;

        var title = MENU_TITLES[type];
        var text  = parseText('${m.firstChild()}');

        menus.push({type: type, title: title, text: text});
    }

    function parseDatum(d:Xml):Void
    {
        var ymd   = '${d.firstChild()}';
        var menus = new Array<Menu>();

        for (m in d.elements())
            parseMenu(menus, m);

        if (menus.length > 0)
            map[ymd] = menus;
    }

    function parseMensamenue(mm:Xml):Void
    {
        for (d in mm.elementsNamed("Datum"))
            parseDatum(d);
    }

    function new(data:String)
    {
        var xml = Xml.parse(data);
        for (mm in xml.elementsNamed("Mensamenue"))
            parseMensamenue(mm);
    }


    public static function parse(data:String):MenuMap
        return new Parser(data).map;


}
