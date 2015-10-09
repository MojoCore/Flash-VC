/**
 * Created by EDINSON on 02/06/2015.
 */
package services {
import flash.events.Event;
import flash.net.URLLoader;

import models.Order;

import mx.collections.ArrayCollection;

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
        params.customErrorStatus=200;
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
            if(result.hasOwnProperty('errors')){
                SendOrderError(event);
            }else{
                if(_fnCompleted!=null){
                    _fnCompleted(result);
                }
            }

        }catch(e:Error){

        }
    }
    private function SendOrderError(event:Event):void{
        trace("call error");
        var result:Object;
        var loader:URLLoader = URLLoader(event.target);
        var data:String=loader.data;
        try{
            result = JSON.parse(data);
        }catch(e:Error){
            result=new Object();
            result.errors=ValidationForm();
        }
        var message:String="";

        if(result.hasOwnProperty("errors")) {
            for (var i:int = 0; i < result.errors.length; i++) {
                if (result.errors[i].hasOwnProperty("name")) {
                    message += result.errors[i].name+": "+(result.errors[i].message as String) + '\n';
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

    public function ValidationForm():ArrayCollection{
        var _cart:models.Cart=_order.cart;
        var errors:ArrayCollection=new ArrayCollection();
        var error_missing_field:String='Missing field {_FIELD_}'
        var ObjError:Object=new Object();
        var status:Boolean=true;
        if(_cart.items.length==0){
            errors.addItem({message:'Cart contains no items'});
            return errors;
        }
        if(_cart.billing_firstName==''){
            errors.addItem({message:error_missing_field,name:'billing_firstName'});
        }
        if(_cart.billing_lastName==''){
            errors.addItem({message:error_missing_field,name:'billing_lastName'});
        }
        if(_cart.email==''){
            errors.addItem({message:error_missing_field,name:'email'});
        }else{
            if(!isValidEmail(_cart.email))
                errors.addItem({message:'billing_email must be a valid email',name:'email'});
        }
        if(_cart.billing_address1==''){
            errors.addItem({message:error_missing_field,name:'billing_address1'});
        }
        if(_cart.billing_city==''){
            errors.addItem({message:error_missing_field,name:'billing_city'});
        }
        if(_cart.billing_state==''){
            errors.addItem({message:error_missing_field,name:'billing_state'});
        }
        if(_cart.billing_zip==''){
            errors.addItem({message:error_missing_field,name:'billing_zip'});
        }
        if(_cart.cc_number==''){
            errors.addItem({message:error_missing_field,name:'cc_number'});
        }else{
            if(_cart.cc_number.length!=16){
                errors.addItem({message:'{_FIELD_} must match "16 digits"',name:'cc_number'});
            }else{
                if(_cart.cc_number!='4111111111111111'){
                    errors.addItem({message:'Invalid CreditCard Number"'});
                }
            }
        }
        if(_cart.cc_cvv==''){
            errors.addItem({message:error_missing_field,name:'cc_cvv'});
        }
        if(_cart.cc_expMonth==''){
            errors.addItem({message:error_missing_field,name:'cc_expMonth'});
        }
        if(_cart.cc_expYear==''){
            errors.addItem({message:error_missing_field,name:'cc_expYear'});
        }
        return errors;
    }
    private function isValidEmail(email:String):Boolean {
        var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
        return emailExpression.test(email);
    }


    public function get order():models.Order {
        return _order;
    }

    public function set order(value:models.Order):void {
        _order = value;
    }
}
}
