/**
 * Created by nodejs01 on 5/11/15.
 */
package util {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class RestService {
    private static var Server:String='';
    private var urlServer:String='';
    private var urlService:String='';
    public static function SetConfigServer(url:String):void{
        Server= url;
    }
    public static function GetConfigServer():String{
        return Server;
    }
    public function RestService(url:String) {
        this.urlService=url;
    }

    public function Get(id:String,fn:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.url = RestService.GetConfigServer()+this.urlService+'/'+id;
        loader.addEventListener(Event.COMPLETE, fn);
        loader.load(request);
    }
}
}
