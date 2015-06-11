/**
 * Created by EDINSON on 03/06/2015.
 */
package services {
import flash.events.Event;
import flash.net.URLLoader;

import models.Card;
import models.EventTime;

import models.Video;

import util.ParamsUrl;
import util.RestService;

public class AnalyticEvent {
    private var _video:Video;
    private var _service:RestService;
    public static const SESSION_CREATE='ANALYTICS_SESSION_CREATE';
    public static const ADD_TO_CART='ADD_TO_CART';
    public static const UPDATE_FROM_CART='UPDATE_FROM_CART';
    public static const REMOVE_FROM_CART='REMOVE_FROM_CART';
    public static const VIDEO_PLAY='VIDEO_PLAY';
    public static const SERVICE_NAME= 'analyticsevents';
    public static const  VIDEO_PROGRESS='VIDEO_PROGRESS';
    public static const  VIDEO_ENDED='VIDEO_ENDED';
    public static const ACTION_SHOW='ACTION_SHOW';
    public static const ORDER_SAVED='ORDER_SAVED';
    private var _isRegister=false;
    private var _v:String;
    private var _id:String;
    private var _accessToken:String;
    private var _createdAt:String;
    private var _host:String;
    private var _countId:int;
    private var _session:String;

    public function AnalyticEvent(host:String) {
        _service=new RestService(SERVICE_NAME);
        _host=ParamsUrl.GetHost();
        _countId=0;
        trace(_host);
    }
    private function IncrementCountId():int{
        _countId+=2;
        return _countId;
    }
    public function CreateSession(video:Video,fnCompleted:Function=null):void{
        _video=video;
        if(!_isRegister){
            _countId=0;
            var params:Object=new Object();
            params.type=SESSION_CREATE;
            params.video=_video.id;
            params.host=_host;
            params.user = _video.user;
            params.cid="c"+IncrementCountId().toString();
            _service.Post(params,function(event:Event):void{
                var loader:URLLoader = URLLoader(event.target);
                var data:Object = JSON.parse(loader.data);
                _isRegister=true;
                _v=data.__v;
                _accessToken=data.accessToken;
                _id=data._id;
                _createdAt=data.createdAt;
                _session=data._id;
                if(fnCompleted!=null)
                    fnCompleted(data);

            });
        }

    }
    public function RegisterEventCart(card:Card,type:String,fnCompleted:Function=null):void{
        var params:Object=new Object();
        params.action=card.id;
        params.product=card.product.id;
        params.cid='c'+IncrementCountId()
        params.host=_host;
        params.referrer=_host;
        params.session=_session;
        params.type=type;
        params.user = _video.user;
        params.video=_video.id;
        _service.Post(params,function(event:Event):void{
            var loader:URLLoader = URLLoader(event.target);
            var data:Object = JSON.parse(loader.data);
            if(fnCompleted!=null)
                fnCompleted(data);
        });
    }
    public function RegisterEventAction(card:Card,type:String,fnCompleted:Function=null):void{
        var params:Object=new Object();
        params.action=card.id;
        params.cid='c'+IncrementCountId()
        params.host=_host;
        params.referrer=_host;
        params.session=_session;
        params.type=type;
        params.user = _video.user;
        params.video=_video.id;
        _service.Post(params,function(event:Event):void{
            var loader:URLLoader = URLLoader(event.target);
            var data:Object = JSON.parse(loader.data);
            if(fnCompleted!=null)
                fnCompleted(data);
        });
    }
    public function RegisterEventTime(type:String,time:Number,fnCompleted:Function=null):void{
        var params:Object=new Object();
        params.cid='c'+IncrementCountId();
        params.host=_host;
        params.referrer=_host;
        params.session=_session;
        params.type=type;
        params.user = _video.user;
        params.video=_video.id;
        if(type!=AnalyticEvent.VIDEO_ENDED)
            params.videoProgress=time;
        _service.Post(params,function(event:Event):void{
            var loader:URLLoader = URLLoader(event.target);
            var data:Object = JSON.parse(loader.data);
            if(fnCompleted!=null)
                fnCompleted(data);
        });
    }

    public function RegisterOrder(orderId:String,fnCompleted:Function=null):void{
        var params:Object=new Object();
        params.cid='c'+IncrementCountId();
        params.host=_host;
        params.order=orderId;
        params.referrer=_host;
        params.session=_session;
        params.type=ORDER_SAVED;
        params.user=_video.user;
        params.video=_video.id;
        _service.Post(params,function(event:Event):void{
            var loader:URLLoader = URLLoader(event.target);
            var data:Object = JSON.parse(loader.data);
            if(fnCompleted!=null)
                fnCompleted(data);
        });


    }

    public function WatchEventTime(eventTime:EventTime,time:Number):void{
        var time_for_register:Number=0;
        if(!eventTime.executed){
            time_for_register=eventTime.percentage*_video.duration/100;
            if(time>time_for_register){
                RegisterEventTime(eventTime.type,time);
                eventTime.executed=true;
                trace('avance:'+eventTime.percentage,time);
            }
        }
    }

}
}
