package uk.co.homletmoo.ld31.assets 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Namer 
	{
		[Embed (source = "text/rooms.txt", mimeType = "application/octet-stream")]
		public static var GRAMMAR_ROOM:Class;
		
		private var phrases:Vector.<String>;
		private var words:Dictionary;
		private var variations:Vector.<String>;
		
		public function Namer(grammar_file:Class)
		{
			var b:ByteArray = new grammar_file();
			var grammar:String = b.readUTFBytes(b.length);
			
			phrases = new Vector.<String>();
			words = new Dictionary();
			variations = new Vector.<String>();
			
			var lines:Array = grammar.split("\r\n");
			var type:String;
			var variation:String;
			for each (var line:String in lines)
			{
				if (line.length < 2) continue;
				if (line.charAt(0) == "%" && line.charAt(1) == "%")
				{
					type = line.charAt(2);
					if (words[type] == null)
						words[type] = new Dictionary();
					
					variation = line.charAt(3);
					if (words[type][variation] == null)
						words[type][variation] = new Vector.<String>();
					if (variations.indexOf(variation) == -1)
						variations.push(variation);
				} else if (type == null)
				{
					phrases.push(line);
				} else
				{
					words[type][variation].push(line);
				}
			}
		}
		
		public function get create():String
		{
			var out:String = "";
			var phrase:String =
				phrases[Math.floor(Math.random() * phrases.length)];
			var variation:String =
				variations[Math.floor(Math.random() * variations.length)];
			for (var i:int = 0; i < phrase.length; i++)
			{
				var char:String = phrase.charAt(i);
				if (char == "%")
				{
					var type:String = phrase.charAt(++i);
					var w:Vector.<String> = words[type][variation];
					out += w[Math.floor(Math.random() * w.length)];
				} else
				{
					out += char;
				}
			}
			return out;
		}
	}
}
