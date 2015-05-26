/**
 * Created by nodejs01 on 5/19/15.
 */
package Implements {
import models.*;

import com.adobe.serialization.json.JSON;

import flash.net.URLVariables;

import Interfaces.iEvent;

import mx.controls.Alert;

import util.RestService;

public class EventViewVideo implements iEvent{
    private var _isRegisterEvent:Boolean=false;
    private var _percentage:int;
    private var _totalTimeVideo:int;
    private var _currentTime:int;
    private var _video:Video;
    private var _type:String;
    private var _hostname:String;
    public function EventViewVideo(percentage:int,totalTimeVideo:int,type:String,hostname:String,video:Video) {
        _percentage = percentage;
        _totalTimeVideo = totalTimeVideo;
        _isRegisterEvent=false;
        _type=type;
        _hostname=hostname;
        _video=video;
    }

    public function WatchEvent(...args):void {
        _currentTime= args[0];
        if (VerifyEvent()){
            RegisterEvent(args);
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
        var params:Object=new Object();
        params.video=_video.id;
        params.videoProgress=_currentTime;
        params.type=_type;
        params.session='555bf15a173cd50300413841';
        params.referrer=_hostname;
        params.host=_hostname;
        params.user=_video.user;
        params.cid="c16";


        service.Post(params,function(response:Object):void{
            //Alert.show(response.toString());
        });
        return true;
    }

    public function get video():Video {
        return _video;
    }

    public function set video(value:Video):void {
        _video = value;
    }
}

}
