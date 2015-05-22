/**
 * Created by nodejs01 on 5/20/15.
 */
package Implements {
import models.*;

import Interfaces.iEvent;

import mx.controls.Alert;

import util.RestService;

public class EventAction implements iEvent{
    private var _type:String;
    private var _video:Video;
    private var _card:Card;
    private var _isRegisterEvent:Boolean;
    public function EventAction(type:String,video:Video) {
        _type = type;
        _video = video;
    }

    public function WatchEvent(...args):void {
    }

    public function VerifyEvent():Boolean {
        return false;
    }

    public function RegisterEvent(...args):Boolean {
        _card=args[0];

        _isRegisterEvent=true;
        var service:RestService=new RestService('analyticsevents');

        var params:Object=new Object();
        params._id=_video.id;
        params.accessToken='dn-VUnjg5uHexPIsXnAovduESblOf_H2';
        params.createdAt= "2015-05-20T20:30:29.853Z";
        params.action = _card.id;
        params.product = _card.product.id;
        params.type=_type;
        params.session='555bf15a173cd50300413841';
        params.referrer="http://videocheckout.com/demovideos/grillbot/";
        params.host="http://videocheckout.com/demovideos/grillbot/";
        //params.user=_video.user;
        params.cid="c16";


        /*service.Post(params,function(response):void{
            Alert.show(response.toString());
        });*/
        trace("EVENT: "+_type)
        return true;
    }
}
}
