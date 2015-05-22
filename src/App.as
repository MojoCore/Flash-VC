/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import Implements.CardDefault;
import Implements.CardResponsive;


import components.Cart;


import flash.display.Sprite;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import Interfaces.iCard;
import Interfaces.iEvent;

import models.Card;
import Implements.EventViewVideo;
import models.Video;

import mx.binding.utils.ChangeWatcher;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

import org.osmf.events.MediaPlayerStateChangeEvent;


import org.osmf.events.TimeEvent;
import org.osmf.media.MediaPlayerState;

import services.TransitionCards;



import spark.components.Button;

import spark.components.VideoPlayer;
import spark.effects.Move;
import spark.effects.Resize;

import util.ParamsUrl;

import util.RestService;

public class App extends Sprite{
    private var showCartBox:Boolean = false;
    private var JsonData:Object;
    private var transitionCards:TransitionCards;
    private var _videoPlayer:VideoPlayer;
    private var _buttonCart:Button;
    private var _buttonCount:Button;
    private var _cartBox:Cart;
    private var _card:iCard;
    private var _moveCartBoxRight:Resize;
    private var _moveCartBoxLeft:Resize;

    private var _widthWatch:ChangeWatcher;
    private var _heightWatch:ChangeWatcher;
    private var _resizeExecuting:Boolean = false;
    private var _app:Object;
    private var _eventTime:iEvent;
    private var _video:Video;

    function App(){
        trace("start app...");
        RestService.SetConfigServer( 'http://45.55.249.97/api/v1/');
    }
    public function InitializeComponents(app:Object,width:int):void{
        _app=app;
        _videoPlayer = _app.videoPlayer;
        _buttonCart = _app.cartButton;
        _buttonCount = _app.countButton;
        _cartBox = _app.CartBox;
        if(width<=500)
            _card = new Implements.CardResponsive(_app.cardR);
        else
            _card = new Implements.CardDefault(_app.card);


    }
    public  function Init():void{
        InitAnimationCart();
        AddEventsToComponents();
        //LoadVideoJson();
        LoadVideoLocal();

    }

    public function InitAnimationCart():void{
        _moveCartBoxRight=new Resize();
        _moveCartBoxRight.target=_cartBox;
        _moveCartBoxRight.widthTo=278;
        _moveCartBoxRight.duration=200;
        _moveCartBoxLeft=new Resize();
        _moveCartBoxLeft.target=_cartBox;
        _moveCartBoxLeft.widthTo=0;
        _moveCartBoxLeft.duration=200;
    }

    private function AddEventsToComponents():void{
        _videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,VideoCurrentTimeChangeHandler);
        _videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoCompleteHandler);
        _videoPlayer.addEventListener(TimeEvent.DURATION_CHANGE, VideoDurationChangeHandler);
        _videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, VideoMediaPlayerStateChangeHandler);
        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler);

    }

    private function VideoDurationChangeHandler(event:TimeEvent):void {
        _eventTime=new EventViewVideo(25,_videoPlayer.duration);
    }


    private function LoadVideoLocal():void{
        var id:String;
        var mycard:models.Card;
        id="5515e136be130e0300c83d17";
        var cards:ArrayCollection=new ArrayCollection();
        _video=new Video()
        _video.id="1";
        _video.user='1111';


        mycard=new models.Card();
        mycard.id = "54bd946d0bbcf90300067cc6";
        mycard.title ='Rotary International';
        mycard.image = 'http://res.cloudinary.com/hpsqkcuar/image/upload/v1421710067/oge7mve8wvi8cg8rwnuu.png';
        mycard.price =  10;
        mycard.buttonText = "Donate Now";
        mycard.startTime = 12.48;
        mycard.endTime = 25;
        mycard.buttonColor = '0xe7a016';
        cards.addItem(mycard);

        mycard=new models.Card();
        mycard.id = "54bd930e4570eb0300b629b0";
        mycard.title ='Rotary International';
        mycard.image = 'http://res.cloudinary.com/hpsqkcuar/image/upload/v1421710067/oge7mve8wvi8cg8rwnuu.png';
        mycard.price =  20;
        mycard.buttonText = "Donate Now";
        mycard.startTime = 30;
        mycard.endTime = 53;
        mycard.buttonColor = '0xe7a016';
        cards.addItem(mycard);

        _videoPlayer.source = "http://s3.amazonaws.com/total-apps-video-checkout/uploads/5bd7b500-a018-11e4-8bb3-eb8f66e87af8.mp4";
        transitionCards = new TransitionCards(cards,_card,_cartBox,_buttonCount,_video);

    }
    private function LoadVideoJson():void{
        var id:String;
        var service:RestService = new RestService('videos');
        ParamsUrl.ReadParamsFromUrl();
        id=ParamsUrl.get('id');
        service.Get(id, function (e:Event):void {
            var loader:URLLoader = URLLoader(e.target);
            JsonData = JSON.parse(loader.data);
            InitDataForVideo();
        },function(event:IOErrorEvent):void{
            LoadVideoLocal();
        });
    }
    private function InitDataForVideo():void {
        var cards:ArrayCollection= services.JsonUtil.ConvertToCards(JsonData.actions);
        _video=services.JsonUtil.ConvertToVideo(JsonData);
        _videoPlayer.source = JsonData.urls.originalUrl;
        transitionCards = new TransitionCards(cards,_card,_cartBox,_buttonCount,_video);
        trace("Hola");

    }

    /*Events components*/
    private function VideoCurrentTimeChangeHandler(event:TimeEvent):void {
        _eventTime.WatchEvent(event.time,_video);
        transitionCards.EvalCardsInTime(event.time);
    }
    private function VideoCompleteHandler(event:TimeEvent):void {
        _app.panelCard.visible=true;
        transitionCards.ResetTransitions();
    }
    protected function VideoMediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent):void {
        if (event.state == MediaPlayerState.LOADING)
            trace("loading ...");
        if (event.state == MediaPlayerState.PLAYING){
            _app.panelCard.visible=false;
            transitionCards.ResetTransitions();
            trace("playing ...");
        }

    }
    private function ButtonCartCartHandler(event:MouseEvent):void{
        showCartBox = !showCartBox;
        if (showCartBox) {
            _moveCartBoxRight.play();
        } else {
            _moveCartBoxLeft.play();
        }
    }


    /* public attributes*/
    public function get videoPlayer():VideoPlayer {
        return _videoPlayer;
    }

    public function set videoPlayer(value:VideoPlayer):void {
        _videoPlayer = value;
    }

    public function get buttonCart():Button {
        return _buttonCart;
    }

    public function set buttonCart(value:Button):void {
        _buttonCart = value;
    }

    public function get cartBox():Cart {
        return _cartBox;
    }

    public function set cartBox(value:Cart):void {
        _cartBox = value;
    }

    public function get buttonCount():Button {
        return _buttonCount;
    }

    public function set buttonCount(value:Button):void {
        _buttonCount = value;
    }

    public function get card():iCard {
        return _card;
    }

    public function set card(value:iCard):void {
        _card = value;
    }

    public function ChangeResponsive():void{
        _card=new CardResponsive(_app.cardR);
        transitionCards.ChangeResponsive(_card);
        _app.card.visible=false;
    }
    public function ChangeDefault():void{
        _card=new CardDefault(_app.card);
        transitionCards.ChangeDefault(_card);
        _app.cardR.visible=false;
    }
}
}
