/**
 * Created by nodejs01 on 5/20/15.
 */
package Implements {
import flash.events.Event;
import flash.net.URLLoader;

import models.*;

import Interfaces.iEvent;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

import mx.controls.Alert;
import mx.core.FlexGlobals;

import util.RestService;

public class EventAction implements iEvent{
    private var _type:String;
    private var _video:Video;
    private var _card:Card;
    private var _isRegisterEvent:Boolean;
    private var _hostname:String;
    private var _response;
    public function EventAction(type:String,video:Video,hostname:String='') {
        _type = type;
        _video = video;
        _hostname=hostname;
    }

    public function WatchEvent(...args):void {
    }

    public function VerifyEvent():Boolean {
        return false;
    }

    public function RegisterEvent(...args):Boolean {

        if(args.length>0)
            _card=args[0];

        _isRegisterEvent=true;
        var service:RestService=new RestService('analyticsevents');

        var params:Object=new Object();
        params.type=_type;

        params.video=_video.id;
        params.host=_hostname;
        params.user = _video.user;
        params.cid="c16";
        if(args.length>0){
            params._id=_video.id;
            params.createdAt= (new Date()).toString();
            params.action = _card.id;
            params.product = _card.product.id;

            params.session='555bf15a173cd50300413841';
            params.referrer="http://videocheckout.com/demovideos/grillbot/";
        }

        service.Post(params,function(response:Event):void{

            var loader:URLLoader = URLLoader(response.target);
            _response = JSON.parse(loader.data);
            trace(_response);
        });
        trace("EVENT: "+_type)
        return true;
    }

    public function RegisterEventCreate(...args):void {

        _isRegisterEvent=true;
        var service:RestService=new RestService('analyticsevents');

        var params:Object=new Object();
        params.type=_type;

        params.video=_video.id;
        params.host=_hostname;
        params.user = _video.user;
        params.cid="c16";

        service.Post(params,function(response:Event):void{
            var loader:URLLoader = URLLoader(response.target);
            _response = JSON.parse(loader.data);
            args[0](_response);
        });

    }

    public function RegisterEventUpdateCart(...args):Boolean {
        var cart:Cart=args[0];
        var actions:ArrayCollection=args[1] as ArrayCollection;

        //{"_id":"5563a49191f7a00300cd7fac","createdAt":"2015-05-25T22:39:13.766Z","updatedAt":"2015-05-25T22:39:13.766Z","video":"55412794e8cb740300b20826","accessToken":"OtzNGpavwGOvERs2lmbpV9y3SrXXbdMo","user":"54b41443c849e80200642e19","items":[{"item_id":"9c0f3600-eea3-11e4-bdb1-2d9c8955e0dd","product_id":"55412c98f55b72030024c052","action_id":"55412d00e8cb740300b2084e","startTime":14,"endTime":21,"text":"Orange Grillbot","price":129.95,"image":"https://res.cloudinary.com/hpsqkcuar/image/upload/c_pad,h_160,w_160/v1430334601/am0l3yvrux2crmfsjhgd.jpg","overlayOpacity":100,"buttonText":"add to cart","buildInAction":"fade-in","buildOutAction":"fade-out","buttonBgColor":"#ff0000","buttonTextColor":"#ffffff","afterButtonText":"In Cart","isProduct":true,"visible":false,"inSummary":true,"position":{"top":null,"bottom":"9.561199514199625%","left":"1.0403120936280885%","right":null},"_id":"55412c98f55b72030024c052","quantity":1}]}
        _isRegisterEvent=true;
        var service:RestService=new RestService('carts');

        var params:Object=new Object();
        params.type=_type;
        params._id=cart.id;
        params.createdAt=cart.createAt;
        params.updatedAt=(new Date()).toString();
        params.video= _video.id;
        params.accessToken = cart.accessToken;
        params.user = cart.user;
        params.items=actions;
        params.items=new Array();
        for(var i:int=0;i<actions.length;i++){
            params.items[i]=(actions.getItemAt(i) as CartItem).card.jsonObject;
            params.items[i].quantity=(actions.getItemAt(i) as CartItem).amount;
            params.items[i].product_id=(actions.getItemAt(i) as CartItem).card.product.id;
            params.items[i].action_id=(actions.getItemAt(i) as CartItem).card.id;
            params.items[i].item_id=(actions.getItemAt(i) as CartItem).card.clientUUID;
            params.items[i]._id=params.items[i].product_id;
            delete  params.items[i]['product'];

        }


        service.Put(cart.id,params,function(response:Event):void{

            var loader:URLLoader = URLLoader(response.target);
            _response = JSON.parse(loader.data);
            trace(_response);
        });
        trace("EVENT: "+_type)
        return true;
    }

    public function get hostname():String {
        return _hostname;
    }

    public function set hostname(value:String):void {
        _hostname = value;
    }

    public function get response():* {
        return _response;
    }

    public function set response(value):void {
        _response = value;
    }
}
}
