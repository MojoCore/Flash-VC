/**
 * Created by nodejs01 on 5/11/15.
 */
package util {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

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

    public function Get(id:String,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.url = RestService.GetConfigServer()+this.urlService+'/'+id;
        loader.addEventListener(Event.COMPLETE, response);
        loader.load(request);
    }
    public function All(params:URLVariables,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.method = URLRequestMethod.GET;
        request.data = params;
        request.url = RestService.GetConfigServer()+this.urlService;

        loader.addEventListener(Event.COMPLETE, response);
        loader.load(request);
    }
    public function Post(params:URLVariables,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.method = URLRequestMethod.POST;
        request.data = params;
        request.url = RestService.GetConfigServer()+this.urlService;

        loader.addEventListener(Event.COMPLETE, response);
        loader.load(request);
    }
    public function Put(params:URLVariables,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.method = URLRequestMethod.PUT;
        request.data = params;
        request.url = RestService.GetConfigServer()+this.urlService;
        request.requestHeaders = [new URLRequestHeader("X-HTTP-Method-Override","PUT")];
        loader.addEventListener(Event.COMPLETE, response);
        loader.load(request);
    }
    public function Delete(id:String,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.method = URLRequestMethod.DELETE;
        request.url = RestService.GetConfigServer()+this.urlService+'/'+id;
        request.requestHeaders = [new URLRequestHeader("X-HTTP-Method-Override","DELETE")];
        loader.addEventListener(Event.COMPLETE, response);
        loader.load(request);
    }
}
}
