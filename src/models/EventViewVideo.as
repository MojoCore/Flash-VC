/**
 * Created by nodejs01 on 5/19/15.
 */
package models {
import com.adobe.serialization.json.JSON;

import flash.net.URLVariables;

import iComponents.iEvent;

import mx.controls.Alert;

import util.RestService;

public class EventViewVideo implements iEvent{
    private var _isRegisterEvent:Boolean=false;
    private var _percentage:int;
    private var _totalTimeVideo:int;
    private var _currentTime:int;
    private var _video:Video;
    public function EventViewVideo(percentage:int,totalTimeVideo:int) {
        _percentage = percentage;
        _totalTimeVideo = totalTimeVideo;
        _isRegisterEvent=false;
    }

    public function WatchEvent(...args):void {
        _currentTime= args[0];
        _video=args[1];
        if (VerifyEvent()){
            RegisterEvent();
        }
    }

    public function VerifyEvent():Boolean {
        var percentage:Number;
        if(_totalTimeVideo>0){
            percentage=_currentTime/_totalTimeVideo;
            if(!_isRegisterEvent){
                if(percentage>=_percentage/100){
                    return true;
                }
            }

        }

        return false;
    }

    public function RegisterEvent(...args):Boolean {
        _isRegisterEvent=true;
        var service:RestService=new RestService('analyticsevents');
        var jsonEncodeParams:String='';
        var params:Object=new Object();
        params.video=_video.id;
        params.videoProgress=_currentTime;
        params.type='VIDEO_PROGRESS';
        params.session='555bf15a173cd50300413841';
        params.referrer="http://videocheckout.com/demovideos/grillbot/";
        params.host="http://videocheckout.com/demovideos/grillbot/";
        params.user=_video.user;
        params.cid="c16";


        service.Post(params,function(response):void{
            Alert.show(response.toString());
        });
        return true;
    }
}

}
