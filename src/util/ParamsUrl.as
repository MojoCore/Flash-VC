/**
 * Created by nodejs01 on 5/11/15.
 */
package util {
import flash.external.ExternalInterface;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

public class ParamsUrl {
    private static var _params:ArrayCollection;

    public function ParamsUrl() {
    }
    public static function GetHost():String {
        var obj:Object;
        var pageURL:String = 'http://localhost';//ExternalInterface.call("window.location.href.toString");
        var params:Array = pageURL.split("?");
        if(params.length>0) {
            return params[0];
        }else{
            return 'http://localhost';
        }
    }
    public static function ReadParamsFromUrl(url):void {
        _params = new ArrayCollection();
        var obj:Object;
        //var pageURL:String = ExternalInterface.call("window.location.href.toString");
        var pageURL:String = url;
        Alert.show(pageURL);
        var params:Array = pageURL.split("?");
        if(params.length>1){
            var paramPairs:Array = pageURL.split("?")[1].split("&");
            for each (var pair:String in paramPairs) {
                var param:Array = pair.split("=");
                obj = new Object();
                obj.key = param[0];
                obj.value = param[1];
                _params.addItem(obj);
            }
        }else{
            obj = new Object();
            obj.key = 'id';
            obj.value = '54bd66d587e5c10300888785';
            _params.addItem(obj);
        }

    }

    public static function get(key:String):String{
        var value:String;
        for(var i:int=0;i<ParamsUrl._params.length;i++){
            if(ParamsUrl._params[i].key==key){
                value = ParamsUrl.params[i].value;
            }
        }
        return value;
    }

    public static function get params():ArrayCollection {
        return _params;
    }

    public static function set params(value:ArrayCollection):void {
        _params = value;
    }
}

}
