package;

import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import sys.FileSystem;
class CrashCheck
{

    //Thanks Forever Engine
    static public function gameCrashCheck(){
    	Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }
     
    static public function onCrash(e:UncaughtErrorEvent):Void {
        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        var dateNow:String = Date.now().toString();
        dateNow = StringTools.replace(dateNow, " ", "_");
        dateNow = StringTools.replace(dateNow, ":", "'");
        var errMsg:String = "";

        for (stackItem in callStack)
        {
            switch (stackItem)
            {
                case FilePos(s, file, line, column):
                    errMsg += file + " (line " + line + ")\n";
                default:
                    Sys.println(stackItem);
            }
        }

        errMsg += e.error;
        
        Sys.println(errMsg);
        Sys.println("Making a simple alert ...");

        CrashCheck.applicationAlert("Uncaught Error:", errMsg);
        flash.system.System.exit(0);
    }
	
    public static function applicationAlert(title:String, description:String){
        Application.current.window.alert(description, title);
    }
}
