/**
 * Created by nodejs01 on 5/11/15.
 */
package util {
import com.adobe.serialization.json.JSON;

import flash.events.AsyncErrorEvent;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import mx.controls.Alert;

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

    public function Get(id:String,response:Function,error:Function=null):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.url = RestService.GetConfigServer()+this.urlService+'/'+id;
        loader.addEventListener(Event.COMPLETE, response);
        if(error!=null)
            loader.addEventListener(IOErrorEvent.IO_ERROR, error);
        else
            loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
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
    public function Post(params:Object,response:Function):void{
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest();
        request.contentType='application/json';
        request.method = URLRequestMethod.POST;
        request.data = com.adobe.serialization.json.JSON.encode(params);
        request.url = RestService.GetConfigServer()+this.urlService;
        loader.addEventListener(Event.COMPLETE, response);
        loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandlerAsyncErrorEvent);
        loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEvent);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandlerSecurityErrorEvent);
        loader.addEventListener(Event.INIT, initHandler);
        loader.load(request);
    }
    private function initHandler(event:IOErrorEvent):void {
        trace('initHandler');
    }

    private function errorHandlerSecurityErrorEvent(event:IOErrorEvent):void {
        trace('errorHandlerSecurityErrorEvent');
    }
    private function errorHandlerIOErrorEvent(event:IOErrorEvent):void {
        trace('errorHandlerIOErrorEvent');
    }

    private function errorHandlerAsyncErrorEvent(event:AsyncErrorEvent):void {
        trace('errorHandlerAsyncErrorEvent');
    }

    private function loaderIOErrorHandler(event:IOErrorEvent):void {
        Alert.show('loaderIOErrorHandler');
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

    public function httpStatusHandler(event:HTTPStatusEvent):void{
        trace("httpStatusHandler"+event);
    }

}
}
