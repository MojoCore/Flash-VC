/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import Implements.CardDefault;
import Implements.CardResponsive;
import Implements.EventAction;
import components.CheckoutDefaultBox;
import components.CheckoutResponsiveBox;


import flash.display.Sprite;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import Interfaces.iCard;
import Interfaces.iEvent;

import models.Card;
import Implements.EventViewVideo;

import models.Cart;
import models.CartItem;
import models.Video;

import mx.binding.utils.ChangeWatcher;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.controls.Alert;
import mx.controls.TileList;
import mx.core.FlexGlobals;

import org.osmf.events.MediaPlayerStateChangeEvent;


import org.osmf.events.TimeEvent;
import org.osmf.media.MediaPlayerState;

import services.TransitionCards;



import spark.components.Button;
import spark.components.List;

import spark.components.VideoPlayer;
import spark.effects.Move;
import spark.effects.Resize;

import util.ParamsUrl;

import util.RestService;

public class App extends Sprite{
    private var _isResponsive:Boolean;
    private var showCartBox:Boolean = false;
    private var JsonData:Object;
    private var _transitionCards:TransitionCards;
    private var _videoPlayer:VideoPlayer;
    private var _buttonCart:Button;
    private var _buttonCount:Button;
    private var _cartBox:components.Cart;
    private var _card:iCard;
    private var _moveCartBoxRight:Resize;
    private var _moveCartBoxLeft:Resize;

    private var _moveCheckoutBottom:Move;
    private var _moveCheckoutTop:Move;
    private var _actionsList:List;
    private var _checkoutBox:CheckoutDefaultBox;
    private var _checkoutBoxResponsive:CheckoutResponsiveBox;


    private var _app:Object;
    private var _eventTime0:iEvent;
    private var _eventTime25:iEvent;
    private var _eventTime50:iEvent;
    private var _eventTime75:iEvent;
    private var _eventTime100:iEvent;

    private var _video:Video;
    private var _eventCreateSession:EventAction;
    private var _hostname:String;
    private var _cart:models.Cart;

    function App(){
        trace("start app...");

        RestService.SetConfigServer( 'https://video-checkout-staging.herokuapp.com/api/v1/');



    }
    public function InitializeComponents(app:Object,width:int):void{
        _app=app;
        _videoPlayer = _app.videoPlayer;
        _buttonCart = _app.cartButton;
        _buttonCount = _app.countButton;
        _cartBox = _app.CartBox;
        _actionsList = _app.actionsList;
        _checkoutBox=_app.checkoutBox;
        _checkoutBoxResponsive=_app.checkoutBoxResponsive;
        if(width<=500){
            ChangeResponsive();
            //_card = new Implements.CardResponsive(_app.cardR);
            //_isResponsive=true;
        }
        else{
            ChangeDefault();
            //_card = new Implements.CardDefault(_app.card);
            //_isResponsive=false;
        }


        //
        _checkoutBox.backButton.setStyle('padding',8);
        _checkoutBox.CheckOutButton.setStyle('padding',8);


    }
    public  function Init():void{

        InitAnimationCart();
        AddEventsToComponents();
        LoadVideoJson();
        //LoadVideoLocal();

    }

    public function InitAnimationCart():void{
        _moveCartBoxRight=new Resize();
        _moveCartBoxRight.target=_cartBox;
        _moveCartBoxRight.widthTo=278;


        _moveCartBoxRight.duration=100;
        _moveCartBoxLeft=new Resize();
        _moveCartBoxLeft.target=_cartBox;
        _moveCartBoxLeft.widthTo=0;
        _moveCartBoxLeft.duration=100;

        _moveCheckoutBottom=new Move();
        _moveCheckoutBottom.target = _app.CheckoutViewStack;
        _moveCheckoutBottom.yTo=0;
        _moveCheckoutBottom.duration=200;

        _moveCheckoutTop=new Move();
        _moveCheckoutTop.target = _app.CheckoutViewStack;
        _moveCheckoutTop.yTo=-450;
        _moveCheckoutTop.duration=200;

    }

    private function AddEventsToComponents():void{
        _videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE,VideoCurrentTimeChangeHandler);
        _videoPlayer.addEventListener(TimeEvent.COMPLETE, VideoCompleteHandler);
        _videoPlayer.addEventListener(TimeEvent.DURATION_CHANGE, VideoDurationChangeHandler);
        _videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, VideoMediaPlayerStateChangeHandler);
        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler);
        _cartBox.CheckOutButton.addEventListener(MouseEvent.CLICK,ShowBoxCheckOut);
        _checkoutBox.backButton.addEventListener(MouseEvent.CLICK, HideBoxCheckOut);
        _checkoutBox.CheckOutButton.addEventListener(MouseEvent.CLICK, CheckoutHandler);

    }



    private function VideoDurationChangeHandler(event:TimeEvent):void {
        _eventTime0=new EventViewVideo(0,_videoPlayer.duration,'VIDEO_PLAY',_hostname,_video);
        _eventTime25=new EventViewVideo(25,_videoPlayer.duration,'PROGRESS_VIDEO',_hostname,_video);
        _eventTime50=new EventViewVideo(50,_videoPlayer.duration,'PROGRESS_VIDEO',_hostname,_video);
        _eventTime75=new EventViewVideo(75,_videoPlayer.duration,'PROGRESS_VIDEO',_hostname,_video);
        _eventTime100=new EventViewVideo(100,_videoPlayer.duration,'VIDEO_ENDED',_hostname,_video);
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
        _transitionCards = new TransitionCards(_app,_video,_card);

    }
    private function LoadVideoJson():void{
        var id:String;
        var service:RestService = new RestService('videos');
        ParamsUrl.ReadParamsFromUrl(_app.loaderInfo.loaderURL);
        id=ParamsUrl.get('id');

        service.Get(id, function (e:Event):void {
            var loader:URLLoader = URLLoader(e.target);
            JsonData = JSON.parse(loader.data);
            InitDataForVideo();
        },function(event:IOErrorEvent):void{
            //LoadVideoLocal();
            Alert.show("url incorrect:"+event.text);
        });
    }
    private function InitDataForVideo():void {

        var cards:ArrayCollection= services.JsonUtil.ConvertToCards(JsonData.actions);

        _actionsList.dataProvider=cards;
        _video=services.JsonUtil.ConvertToVideo(JsonData);
        _video.actions=cards;
        _videoPlayer.source = JsonData.urls.originalUrl;
        _transitionCards = new TransitionCards(_app,_video,_card);
        trace("Hola");
        _eventCreateSession=new EventAction('ANALYTICS_SESSION_CREATE',_video,ParamsUrl.GetHost());
        _eventCreateSession.RegisterEventCreate(function(response:Object):void{
            var serviceCart:RestService= new RestService('carts');
            var params:Object=new Object();
            params.video=_video.id;
            serviceCart.Post(params,function(e:Event):void{
                var loader:URLLoader = URLLoader(e.target);
                var r = JSON.parse(loader.data);
                _cart=new models.Cart();
                _cart.id=r._id;
                _cart.video=r.video;
                _cart.user=r.user;
                _cart.createAt=r.createAt;
                _cart.updatedAt=r.updatedAt;
                _cart.accessToken=r.accessToken;
                _transitionCards.cart=_cart;
                trace("id"+_cart.id);
            })
        });

    }
    private function getHostName():String {
        var g_BaseURL = FlexGlobals.topLevelApplication.url;
        var pattern1:RegExp = new RegExp("http://[^/]*/");
        if (pattern1.test(g_BaseURL) == true) {
            var g_HostString = pattern1.exec(g_BaseURL).toString();
        } else{
            var g_HostString = "http://localhost/"
        }

        return g_HostString;
    }

    /*Events components*/
    private function VideoCurrentTimeChangeHandler(event:TimeEvent):void {
        _eventTime0.WatchEvent(event.time);
        _eventTime25.WatchEvent(event.time);
        _eventTime50.WatchEvent(event.time);
        _eventTime75.WatchEvent(event.time);

        _transitionCards.EvalCardsInTime(event.time);
    }
    private function VideoCompleteHandler(event:TimeEvent):void {
        _app.panelCard.visible=(true&&!_isResponsive);
        _transitionCards.ResetTransitions();
        _eventTime100.RegisterEvent(event.time);
    }
    protected function VideoMediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent):void {
        if (event.state == MediaPlayerState.LOADING)
            trace("loading ...");
        if (event.state == MediaPlayerState.PLAYING){
            _app.panelCard.visible=false;
            _transitionCards.ResetTransitions();
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

    public function get cartBox():components.Cart {
        return _cartBox;
    }

    public function set cartBox(value:components.Cart):void {
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
        _isResponsive=true;
        _card=new CardResponsive(_app.cardR);
        if(_transitionCards)
            _transitionCards.ChangeResponsive(_card);
        _app.card.visible=false;
        _cartBox.percentHeight=100;
        _app.footer.visible=true;
        _app.footer.includeInLayout=true;

    }
    public function ChangeDefault():void{
        _isResponsive=false;
        _card=new CardDefault(_app.card);
        if(_transitionCards)
            _transitionCards.ChangeDefault(_card);
        _app.cardR.visible=false;
        _cartBox.percentHeight=100;
        _app.footer.visible=false;
        _app.footer.includeInLayout=false;

    }

    public function ShowBoxCheckOut(evt:MouseEvent):void{
        if(showCartBox){
            _moveCartBoxLeft.play();
            showCartBox=false;
        }
        var vs:ViewStack=_app.CheckoutViewStack;
        vs.selectedIndex=0;
        _moveCheckoutBottom.play();


    }
    public function HideBoxCheckOut(event:MouseEvent):void {
        if(!showCartBox){
            _moveCartBoxRight.play();
            showCartBox=true;
        }
        _moveCheckoutTop.play();
    }

    public function CheckoutHandler(event:MouseEvent):void {
        var service:RestService=new RestService('carts');
        var cartItems:ArrayCollection=_cartBox.items.dataProvider as ArrayCollection;
        var params:Object=new Object();
        params._id=_cart.id;
        params.createdAt=_cart.createAt;
        params.updatedAt=(new Date()).toString();
        params.video= _video.id;
        params.accessToken = _cart.accessToken;
        params.user = _cart.user;
        params.items=new Array();
        for(var i:int=0;i<cartItems.length;i++){
            params.items[i]=(cartItems.getItemAt(i) as CartItem).card.jsonObject;
            params.items[i].quantity=(cartItems.getItemAt(i) as CartItem).amount;
            params.items[i].product_id=(cartItems.getItemAt(i) as CartItem).card.product.id;
            params.items[i].action_id=(cartItems.getItemAt(i) as CartItem).card.id;
            params.items[i].item_id=(cartItems.getItemAt(i) as CartItem).card.clientUUID;
            params.items[i]._id=params.items[i].product_id;
            delete  params.items[i]['product'];

        }
        params.billing_address1=_checkoutBox.addressInput.text;
        params.billing_city= _checkoutBox.cityInput.text;
        params.billing_firstName= _checkoutBox.nameInput.text;
        params.billing_state= _checkoutBox.stateInput.selectedItem;
        params.billing_zip= _checkoutBox.zipInput.text;
        params.cc_cvv= _checkoutBox.cvvInput.text;
        params.cc_expMonth=_checkoutBox.monthInput.selectedItem;
        params.cc_expYear= _checkoutBox.yearInput.text;
        params.cc_number= _checkoutBox.cardnumberInput.text;
        params.createdAt= _cart.createAt;
        params.email= _checkoutBox.emailInput.text;

        //(_app.watchVideoButton as Button).setStyle('padding',12);
        service.Put(_cart.id,params,function(response:Event):void{
            var result:Object;
            var loader:URLLoader = URLLoader(response.target);
            result = JSON.parse(loader.data);
            trace(result);
            CallOrder();
        });


    }

    public function CallOrder():void{
        var service:RestService=new RestService('orders');
        var params:Object=new Object();
        params.cartId=_cart.id;
        service.Post(params,function(response:Event):void{
            var result:Object;
            var loader:URLLoader = URLLoader(response.target);
            result = JSON.parse(loader.data);
            trace(result);
            var vs:ViewStack=_app.CheckoutViewStack;
            vs.selectedIndex=1;

            var vsr:ViewStack=_app.CheckoutViewStackResponsive;
            vsr.selectedIndex=1;
        });
    }

    public function get transitionCards():TransitionCards {
        return _transitionCards;
    }

    public function set transitionCards(value:TransitionCards):void {
        _transitionCards = value;
    }
}
}
