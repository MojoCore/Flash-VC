/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import components.Card;
import components.Cart;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import models.CardComponent;

import mx.collections.ArrayCollection;
import org.osmf.events.TimeEvent;

import services.TransitionCards;

import spark.components.Button;

import spark.components.VideoPlayer;
import spark.effects.Move;

import util.ParamsUrl;

import util.RestService;

public class App{
    private var showCartBox:Boolean = false;
    private var JsonData:Object;
    private var transitionCards:TransitionCards;
    private var _videoPlayer:VideoPlayer;
    private var _buttonCart:Button;
    private var _buttonCount:Button;
    private var _cartBox:Cart;
    private var _card:Card;
    private var _moveCartBoxRight:Move;
    private var _moveCartBoxLeft:Move;

    function App(){
        RestService.SetConfigServer( 'http://45.55.249.97/api/v1/');
    }
    public function InitializeComponents(video:VideoPlayer,btnCart:Button,btnCount:Button,card:Card,cartBox:Cart):void{
        _videoPlayer = video;
        _buttonCart = btnCart
        _buttonCount = btnCount;
        _card = card;
        _cartBox = cartBox;
    }
    public  function Init(){
        InitAnimationCart();
        AddEventsToComponents();
        LoadVideoJson();
    }

    public function InitAnimationCart():void{
        _moveCartBoxRight=new Move();
        _moveCartBoxRight.target=_cartBox;
        _moveCartBoxRight.xBy=278;
        _moveCartBoxRight.duration=500;
        _moveCartBoxLeft=new Move();
        _moveCartBoxLeft.target=_cartBox;
        _moveCartBoxLeft.xBy=-278;
        _moveCartBoxLeft.duration=500;
    }

    private function AddEventsToComponents():void{
        _videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,VideoCurrentTimeChangeHandler)
        _videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoCompleteHandler)
        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler)
    }


    private function LoadVideoJson():void{
        var id:String;
        var service:RestService = new RestService('videos');
        ParamsUrl.ReadParamsFromUrl();
        id=ParamsUrl.get('id');
        service.Get(id, function (e:Event) {
            var loader:URLLoader = URLLoader(e.target);
            JsonData = JSON.parse(loader.data);
            InitDataForVideo();
        });
    }
    private function InitDataForVideo():void {
        var cards:ArrayCollection;
        videoPlayer.source = JsonData.urls.originalUrl;
        cards=services.Card.ConvertToCards(JsonData.actions);
        transitionCards = new TransitionCards(cards,new CardComponent(card),_cartBox,_buttonCount);

    }

    /*Events components*/
    private function VideoCurrentTimeChangeHandler(event:TimeEvent):void {
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

    public function get card():Card {
        return _card;
    }

    public function set card(value:Card):void {
        _card = value;
    }
}
}
