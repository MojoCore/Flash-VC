/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import components.Card;
import components.Cart;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import models.Card;

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
    private var _card:components.Card;
    private var _moveCartBoxRight:Move;
    private var _moveCartBoxLeft:Move;

    function App(){
        RestService.SetConfigServer( 'http://45.55.249.97/api/v1/');
    }
    public function InitializeComponents(video:VideoPlayer,btnCart:Button,btnCount:Button,card:components.Card,cartBox:Cart):void{
        _videoPlayer = video;
        _buttonCart = btnCart
        _buttonCount = btnCount;
        _card = card;
        _cartBox = cartBox;
    }
    public  function Init():void{
        InitAnimationCart();
        AddEventsToComponents();
        //LoadVideoJson();
        LoadVideoLocal();
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
        _videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,VideoCurrentTimeChangeHandler)
        _videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoCompleteHandler)
        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler)
    }

    private function LoadVideoLocal():void{
        var id:String;
        var mycard:models.Card;
        id="5515e136be130e0300c83d17";
        var cards:ArrayCollection=new ArrayCollection();
        for(var i:int=0;i<5;i++){
            mycard=new models.Card();
            mycard.id = i.toString();
            mycard.title = "Producto "+i.toString();
            mycard.image = "http://res.cloudinary.com/hpsqkcuar/image/upload/v1421710067/oge7mve8wvi8cg8rwnuu.png";
            mycard.price = '$' + "100";
            mycard.buttonText = "Add to cart";
            mycard.startTime = 5*(i+1);
            mycard.endTime = 10*(i+1);
            mycard.buttonColor = '0xFF0000';
            cards.addItem(mycard);
        }
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
        var cards:ArrayCollection= services.Card.ConvertToCards(JsonData.actions);
        _videoPlayer.source = JsonData.urls.originalUrl;
        transitionCards = new TransitionCards(cards,_card,_cartBox,_buttonCount);

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

    public function get card():components.Card {
        return _card;
    }

    public function set card(value:components.Card):void {
        _card = value;
    }
}
}
