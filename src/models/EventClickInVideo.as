/**
 * Created by nodejs01 on 5/20/15.
 */
package models {
import iComponents.iEvent;

import mx.controls.Alert;

import util.RestService;

public class EventClickInVideo implements iEvent{
    private var _type:String;
    private var _isRegisterEvent:Boolean;
    public function EventClickInVideo(type:String) {
        _type = type;
    }

    public function WatchEvent(...args):void {
    }

    public function VerifyEvent():Boolean {
        return false;
    }

    public function RegisterEvent():Boolean {
        _isRegisterEvent=true;
        var service:RestService=new RestService('analyticsevents');
        var jsonEncodeParams:String='';
        var params:Object=new Object();
        //params.video=_video.id;
        //params.videoProgress=_currentTime;
        params.type='VIDEO_PROGRESS';
        params.session='555bf15a173cd50300413841';
        params.referrer="http://videocheckout.com/demovideos/grillbot/";
        params.host="http://videocheckout.com/demovideos/grillbot/";
        //params.user=_video.user;
        params.cid="c16";


        service.Post(params,function(response):void{
            Alert.show(response.toString());
        });
        return true;
    }
}
}
