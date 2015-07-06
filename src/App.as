/**
 * Created by nodejs01 on 5/13/15.
 */
package {
import Implements.CardDefault;
import Implements.CardResponsive;
import components.CheckoutDefaultBox;
import components.CheckoutResponsiveBox;


import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import Interfaces.iCard;
import flash.system.Security;
import flash.system.System;

import models.Cart;
import models.Order;
import models.Video;
import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.controls.Alert;
import org.osmf.events.MediaPlayerStateChangeEvent;


import org.osmf.events.TimeEvent;
import org.osmf.media.MediaPlayerState;

import services.Cart;
import services.ConfigurationForm;

import services.Order;

import services.TransitionCards;



import spark.components.Button;
import spark.components.List;

import spark.components.VideoPlayer;
import spark.effects.Move;
import spark.effects.Resize;
import spark.events.IndexChangeEvent;

import util.ParamsUrl;

import util.RestService;

public class App extends Sprite{
    private var _isResponsive:Boolean;
    private var showCartBox:Boolean = false;
    private var _transitionCards:TransitionCards;
    private var _videoPlayer:VideoPlayer;
    private var _buttonCart:Button;
    private var _buttonCount:Button;
    private var _cartBox:components.Cart;
    private var _card:iCard;
    private var _moveCartBoxRight:Resize;
    private var _moveCartBoxLeft:Resize;
    private var _showActions:Boolean=false;
    private var _moveCheckoutBottom:Move;
    private var _moveCheckoutTop:Move;
    //private var _actionsList:List;
    private var _checkoutBox:CheckoutDefaultBox;
    private var _checkoutBoxResponsive:CheckoutResponsiveBox;

    private var _configurationForm:ConfigurationForm;
    private var _app:Object;
    private var _video:Video;

    private var _hostname:String;
    //private var _cart:models.Cart;

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
        //_actionsList = _app.actionsList;
        _checkoutBox=_app.checkoutBox;
        _checkoutBoxResponsive=_app.checkoutBoxResponsive;
        _checkoutBox.backButton.setStyle('padding',8);
        _checkoutBox.CheckOutButton.setStyle('padding',8);
        //_hostname=_app.loaderInfo.loaderURL;
        if(width<=500){
            _isResponsive=true;
            ChangeResponsive();
        }
        else{
            _isResponsive=false;
            ChangeDefault();

        }
        //InitializeForm();

    }
    public function Init():void{
        InitAnimationCart();
        AddEventsToComponents();
        LoadVideoJson();

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

        _buttonCart.addEventListener(MouseEvent.CLICK,ButtonCartCartHandler);
        _cartBox.CheckOutButton.addEventListener(MouseEvent.CLICK,ShowBoxCheckOut);
        _checkoutBox.backButton.addEventListener(MouseEvent.CLICK, HideBoxCheckOut);
        _checkoutBox.CheckOutButton.addEventListener(MouseEvent.CLICK, CheckoutHandler);

    }

    private function LoadVideoJson():void{
        var service:RestService = new RestService('videos');
        ParamsUrl.ReadParamsFromUrl(_app.loaderInfo.loaderURL);
        service.Get(ParamsUrl.get('id'),function (e:Event):void {
            var loader:URLLoader = URLLoader(e.target);
            var data:Object = JSON.parse(loader.data);
            InitDataForVideo(data);
        },function(event:IOErrorEvent):void{
            Alert.show("url incorrect:"+event.text);
        });
    }
    private function InitDataForVideo(data:Object):void {
        _video=services.JsonUtil.ConvertToVideo(data);
        //_actionsList.dataProvider=_video.actions;
        _app.inCaseYouMissedResponsive.list.dataProvider=_video.actions;
        _app.inCaseYouMissedDefault.list.dataProvider=_video.actions;
        _videoPlayer.source = data.urls.originalUrl;
        _transitionCards = new TransitionCards(_app,_video,_card);
        _transitionCards.isResponsive=_isResponsive;
        SessionCreate();



    }
    private function SessionCreate():void{
        _transitionCards.analyticsEvent.CreateSession(_video,function(data):void{
            RegisterCart();
        });

    }
    private function RegisterCart():void{
        _transitionCards.serviceCart.Create(function(cart:models.Cart){
            _configurationForm=new ConfigurationForm(_app,_video, _transitionCards.serviceCart.cart,_checkoutBox,_checkoutBoxResponsive);
            _configurationForm.Configure(function():void{
                _transitionCards.titleButton=_configurationForm.titleButton;
            });
        });
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
        _app.CheckoutViewStackResponsive.visible=true;
        _app.CheckoutViewStack.visible=false;
        _buttonCart.visible=false;
        
        //_actionsList.visible=false;
        _cartBox.visible=false;
        //_app.panelCard.visible=(_showActions&&!_isResponsive);

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
        _app.CheckoutViewStackResponsive.visible=false;
        _app.CheckoutViewStack.visible=true;
        _buttonCart.visible=true;
        //_actionsList.visible=true;
       // _app.panelCard.visible=(_showActions&&!_isResponsive);
        _cartBox.visible=true;


    }

    public function ShowBoxCheckOut(evt:MouseEvent):void{
        if(showCartBox){
            _moveCartBoxLeft.play();
            showCartBox=false;
        }
        var vs:ViewStack=_app.CheckoutViewStack;
        vs.selectedIndex=0;
        _configurationForm.ShowDefault();
        _app.stage.displayState = StageDisplayState.NORMAL;
        _app.btnTabCart.ActiveTab();
        //_moveCheckoutBottom.play();


    }
    public function HideBoxCheckOut(event:MouseEvent):void {
        if(!showCartBox){
            _moveCartBoxRight.play();
            showCartBox=true;
        }
        _configurationForm.HideDefault();
    }

    public function CheckoutHandler(event:MouseEvent):void {
        var cartItems:ArrayCollection=_cartBox.items.dataProvider as ArrayCollection;
        _transitionCards.serviceCart.Update(cartItems,true,function(){
            CallOrder();
        });

    }

    public function CallOrder():void{
        var orderService:services.Order=new services.Order(new models.Order(_transitionCards.serviceCart.cart));
        orderService.order.cart=_transitionCards.serviceCart.cart;
        orderService.SendOrder(function(result:Object):void{
                     if(result.hasOwnProperty("_id")){
                            var vs:ViewStack=_app.CheckoutViewStack;
                            vs.selectedIndex=1;
                            var vsr:ViewStack=_app.CheckoutViewStackResponsive;
                            vsr.selectedIndex=1;
                            _transitionCards.analyticsEvent.RegisterOrder(result._id);
                        }


        },
        function(data):void{
            Alert.show(data);
        })
    }

    public function get transitionCards():TransitionCards {
        return _transitionCards;
    }

}
}
