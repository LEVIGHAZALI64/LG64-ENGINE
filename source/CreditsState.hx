package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Dynamic> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var pisspoop = [ //Name - Icon name - Description - Link - BG Color
			['LEVI ENGINE Android Port'],
			['LG64',		    'levi',		    'Youtuber And Main Coder of The Port',	 'https://youtube.com/c/LG64TUBE',	'0xFFC30085'],
			['LEVI Engine Team'],
			['LG64',		'levi',		'Main Programmer of Levi Engine',					'https://youtube.com/c/LG64TUBE',	'0xFFFFDD33'],
			['Haliza',			'haliza',		'Main Artist/Animator of Levi Engine',				'https://youtube.com/channel/UCLcYgsHrrPHTxZt_Uk19c5A',		'0xFFC30085'],
			[''],
			['Engine Contributors'],
			['Kimiri',				'kimiri',			'Animation Programmer',						'https://twitter.com/KimiriChan?s=20&t=0bqZg6mzPiziwYFEcWanBQ',			'0xFF4494E6'],
			['knuxy03',		'knuxy',	'My Best Friends on YouTube',						'https://youtube.com/c/Knuxy03',	'0xFFE01F32'],
			['nafri',			'nafri',			'My Best Friend Too On YouTube',				'https://youtube.com/c/Nafri4166',			'0xFFFF9300'],
			['Tristama',				'tristama',			'Note Splash Animations',							'https://twitter.com/Tristama_?s=20&t=0bqZg6mzPiziwYFEcWanBQ',			'0xFFFFFFFF'],
			['Anniki',			'anniki',		'Main Supporter of the Engine',		'https://twitter.com/rivergravidade?s=20&t=0bqZg6mzPiziwYFEcWanBQ',	'0xFFD10616'],
			['BlueThebone',				'sus',		'Someone Is A Little Sussy Baka Desu Here',	'https://twitter.com/bluethebone?s=20&t=0bqZg6mzPiziwYFEcWanBQ',	'0xFF61536A'],
			['Trake',				'trake',		'Animation Designer',	'https://youtube.com/c/TrakeDaGamer',	'0xFF61536A'],
			['Brick ST',				'brick',		'Lead Animation Designer',	'https://twitter.com/Brick_ST_?s=20&t=0bqZg6mzPiziwYFEcWanBQ',	'0xFF61536A'],
			['Radhila Alya',				'alya',		'Gacha Animation Designer',	'https://youtube.com/channel/UCpUVd6eauHn9VnjUM89-jvA',	'0xFF61536A'],
			['Raiden alfares',				'raiden',		'Help Me For The Code Android Port',	'https://youtube.com/channel/UChE0s906J1YZRf1Ln9wP8Gg',	'0xFF61536A'],
			['Necky',				'necky',		'Optimized All The Sprites',	'https://youtube.com/channel/UCBd_G_wH1lBDlh6j9M93DnA',	'0xFF61536A'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	'0xFFF73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	'0xFFFFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			'0xFF53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		'0xFF6475F3']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = Std.parseInt(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();

		#if mobileC
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  Std.parseInt(creditsStuff[curSelected][4]);
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
