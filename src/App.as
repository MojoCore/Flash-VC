/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import Implements.CardDefault;
import Implements.CardResponsive;


import components.Cart;


import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import iComponents.iCard;
import iComponents.iEvent;

import models.Card;
import models.EventViewVideo;
import models.Video;

import mx.binding.utils.ChangeWatcher;

import mx.collections.ArrayCollection;
import mx.controls.Alert;


import org.osmf.events.TimeEvent;

import services.TransitionCards;



import spark.components.Button;

import spark.components.VideoPlayer;
import spark.effects.Move;

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
    private var _moveCartBoxRight:Move;
    private var _moveCartBoxLeft:Move;

    private var _widthWatch:ChangeWatcher;
    private var _heightWatch:ChangeWatcher;
    private var _resizeExecuting:Boolean = false;
    private var _app:Object;
    private var _eventTime:iEvent;
    private var _video:Video;

    function App(){
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
        LoadVideoJson();
        //LoadVideoLocal();
    }

    public function InitAnimationCart():void{
        _moveCartBoxRight=new Move();
        _moveCartBoxRight.target=_cartBox;
        _moveCartBoxRight.xBy=278;
        _moveCartBoxRight.duration=200;
        _moveCartBoxLeft=new Move();
        _moveCartBoxLeft.target=_cartBox;
        _moveCartBoxLeft.xBy=-278;
        _moveCartBoxLeft.duration=200;
    }

    private function AddEventsToComponents():void{
        _videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,VideoCurrentTimeChangeHandler);
        _videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoCompleteHandler);
        _videoPlayer.addEventListener(TimeEvent.DURATION_CHANGE, VideoDurationChangeHandler);
        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler);
        //_widthWatch = ChangeWatcher.watch(_app.parentApplication,'width',onSizeChange);
        //_heightWatch = ChangeWatcher.watch(_app.parentApplication,'height',onSizeChange);
        //Alert.show("ok")

    }

    private function VideoDurationChangeHandler(event:TimeEvent):void {
        _eventTime=new EventViewVideo(25,_videoPlayer.duration);
        //Alert.show(_videoPlayer.duration.toString());
    }
    private function onSizeChange(event:Event):void {
        /*if(!_resizeExecuting)
            callLater(handleResize);
        _resizeExecuting = true;*/
        var text:String = ""
        text = stage.stageWidth + " - " + stage.stageHeight;
        Alert.show(text);
    }

    private function handleResize():void {
        //do expensive work here

    }

    private function stopWatching() {
        //invoke this to stop watching the properties and prevent the handleResize method from executing
        _widthWatch.unwatch();
        _heightWatch.unwatch();
    }


    private function resizeHandler(event:Event):void {
        var text:String = ""
        text = stage.stageWidth + " - " + stage.stageHeight;
        Alert.show(text);
    }

    private function LoadVideoLocal():void{
        var id:String;
        var mycard:models.Card;
        id="5515e136be130e0300c83d17";
        var cards:ArrayCollection=new ArrayCollection();
        /*for(var i:int=0;i<5;i++){
            mycard=new models.Card();
            mycard.id = i.toString();
            mycard.title = "Producto "+i.toString();
            mycard.image = "http://res.cloudinary.com/hpsqkcuar/image/upload/v1421710067/oge7mve8wvi8cg8rwnuu.png";
            mycard.price = 100;
            mycard.buttonText = "Add to cart";
            mycard.startTime = 5*(i+1);
            mycard.endTime = 10*(i+1);
            mycard.buttonColor = '0xFF0000';
            cards.addItem(mycard);
        }*/

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
        transitionCards = new TransitionCards(cards,_card,_cartBox,_buttonCount);

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
        });
    }
    private function InitDataForVideo():void {
        var cards:ArrayCollection= services.JsonUtil.ConvertToCards(JsonData.actions);
        _video=services.JsonUtil.ConvertToVideo(JsonData);
        _videoPlayer.source = JsonData.urls.originalUrl;
        transitionCards = new TransitionCards(cards,_card,_cartBox,_buttonCount);
        trace("Hola");

    }

    /*Events components*/
    private function VideoCurrentTimeChangeHandler(event:TimeEvent):void {
        _eventTime.WatchEvent(event.time,_video);
        transitionCards.EvalCardsInTime(event.time);
    }
    private function VideoCompleteHandler(event:TimeEvent):void {

        transitionCards.ResetTransitions();
    }
    private function ButtonCartCartHandler(event:MouseEvent):void{
        showCartBox = !showCartBox;
        if (showCartBox) {
            _moveCartBoxRight.play();
        } else {
            _moveCartBoxLeft.play();
        }
    }

    public function StageRezizeHandler(e:Event):void{
        //trace("The application window changed size!");
        //Alert.show("New width:  " + stage.stageWidth);
        //trace("New height: " + _stage.height);
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
