/**
 * Created by EDINSON on 02/06/2015.
 */
package services {
import flash.events.Event;
import flash.net.URLLoader;

import models.Order;

import util.RestService;

public class Order{
    private var _order:models.Order;
    private var _service:RestService;
    private var _fnCompleted:Function;
    private var _fnError:Function;
    public function Order(order:models.Order=null) {
        _service=new RestService('orders');
        _order=order;
    }
    public function SendOrder(fnCompleted:Function=null,fnError:Function=null):void{
        var params:Object=new Object();
        params.cartId=_order.cart.id;
        _fnCompleted=fnCompleted;
        _fnError=fnError;
        _service.Post(params,this.SendOrderCompleted,this.SendOrderError);
    }
    private function  SendOrderCompleted(event:Event):void{
        try{
            var result:Object;
            var data:Boolean=false;
            var loader:URLLoader = URLLoader(event.target);
            result = JSON.parse(loader.data);
            if(result.hasOwnProperty("_id")){
                data=true;
            }else{
                data=false;
            }
            if(_fnCompleted!=null){
                _fnCompleted(data);
            }
        }catch(e:Error){

        }
    }
    private function SendOrderError(event:Event):void{
        trace("call error");
        var result:Object;
        var loader:URLLoader = URLLoader(event.target);
        var data=loader.data;
        try{
            result = JSON.parse(data);
        }catch(e:Error){
            result=new Object();
        }
        var message:String="";
        if(result.hasOwnProperty("errors")) {
            for (var i:int = 0; i < result.errors.length; i++) {
                if (result.errors[i].hasOwnProperty("name")) {
                    message += (result.errors[i].message as String).replace("{_FIELD_}", result.errors[i].name) + '\n';
                } else {
                    message += result.errors[i].message + "\n";
                }
            }
        }else{
            message="Data is empty";
        }
        _fnError(message)
        //Alert.show(message);
    }


}
}
