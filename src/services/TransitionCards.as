/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import Implements.CardDefault;

import components.CardDefault;

import components.Cart;
import components.CheckoutDefaultBox;
import components.CheckoutResponsiveBox;

import flash.events.Event;
import flash.events.MouseEvent;

import Interfaces.iCard;
import Interfaces.iEvent;

import models.Card;
import models.Cart;
import models.CartItem;
import Implements.EventAction;
import Implements.EventViewVideo;
import models.Video;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.formatters.CurrencyFormatter;

import spark.components.Button;
import spark.components.Image;
import spark.components.List;
import spark.effects.Fade;
import spark.effects.Move;
import spark.effects.easing.Elastic;

import util.ParamsUrl;

public class TransitionCards {

    private var _cards:ArrayCollection;
    private var _currentCardIndex:int=0;
    private var _currentCard:models.Card;
    private var _cardComponent:iCard;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    [Bindable]
    private var _cart:models.Cart;
    private var _cartBox:components.Cart;
    private var _cartBoxResponsive:components.CartResponsive;
    private var _numberItemsLabel:Button;
    private var _itemsInYourCartImage:Image;
    private var _actionsList:List;

    private var _currency:CurrencyFormatter;
    private var _elastic:Elastic;
    private var _moveCount:Move;
    private var _totalItems:Number;
    private var _totalPrice:Number;
    private var _eventAddToCart:EventAction;
    private var _eventRemoveFromCart:EventAction;
    private var _eventUpdateCart:EventAction;
    private var _video:Video;
    private var _checkoutBox:CheckoutDefaultBox;
    private var _app:Object;


    public function TransitionCards(app:Object,video:Video,cardCmp:iCard) {

        _app=app;
        _video=video;
        _totalItems=0;
        _totalPrice=0;
        _cards = _video.actions;
        _cardComponent = cardCmp;
        _cartBox = _app.CartBox;
        _cartBoxResponsive = _app.cartBoxResponsive;
        _numberItemsLabel=_app.countButton;
        _checkoutBox=_app.checkoutBox;
        _itemsInYourCartImage=_app.itemsInYourCartImage;
        _actionsList = _app.actionsList;
        var host:String=ParamsUrl.GetHost();
        _eventAddToCart=new EventAction('ADD_TO_CART',_video,host);
        _eventRemoveFromCart=new EventAction('REMOVE_FROM_CART',_video,host);
        _eventUpdateCart=new EventAction('UPDATE_FROM_CART',_video,host);
        _cartBox.items.dataProvider=new ArrayCollection();
        _cart=new models.Cart();
        if(_currentCardIndex<=_video.actions.length-1)
            _currentCard = _cards[_currentCardIndex];

        _cardComponent.getComponent().button.addEventListener(MouseEvent.CLICK,AddToCart);
        _cartBox.items.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, items_collectionChange);
        //_cart.items.source = _cart.items.source;
        ConfigureCurrency();

        _cartBoxResponsive.items.dataProvider = _cartBox.items.dataProvider;
        //_cartBox.items.validateNow();
        //InitFade();
    }
    private function ConfigureCurrency():CurrencyFormatter{
        _currency=new CurrencyFormatter();
        _currency.precision=2;
        _currency.currencySymbol="$";
        _currency.thousandsSeparatorTo=",";
        _currency.decimalSeparatorTo=".";
        return _currency;
    }
    private function items_collectionChange(evt:CollectionEvent):void{
        trace(evt.kind);
        trace(evt.items);
        switch(evt.kind){
            case CollectionEventKind.ADD:
                _eventAddToCart.RegisterEventUpdateCart(_cart, _cartBox.items.dataProvider as ArrayCollection);
                break;
            case CollectionEventKind.REMOVE:
                _eventAddToCart.RegisterEventUpdateCart(_cart, _cartBox.items.dataProvider as ArrayCollection);
                break;
            case CollectionEventKind.UPDATE:
            case CollectionEventKind.REPLACE:
                _eventAddToCart.RegisterEventUpdateCart(_cart, _cartBox.items.dataProvider as ArrayCollection);
                break;
        }

        CalculateTotals()

    }


    public function ResetTransitions():void{
        _currentCardIndex = 0;
        if(_currentCardIndex<=_cards.length-1)
            _currentCard = _cards[_currentCardIndex];
    }

    private function InitFade():void{
        _fadeShow = new Fade();
        _fadeHide = new Fade();
        _fadeShow.target = _cardComponent;
        _fadeHide.target = _cardComponent;

        _fadeShow.alphaFrom =0;
        _fadeShow.alphaTo = 1;
        _fadeShow.duration = 500;

        _fadeHide.alphaFrom =1;
        _fadeHide.alphaTo = 0;
        _fadeHide.duration = 500;

        _elastic=new Elastic();



    }

    public function NextCard():models.Card{
        if(_currentCardIndex < _cards.length-1)
            _currentCardIndex++;
        _currentCard = _cards[_currentCardIndex];
        return _currentCard;
    }

    public function get currentCard():models.Card {
        return _currentCard;
    }

    public function AddToCart(e:Event):void{
        var index:int= this.FindCardInCart(this.currentCard);
        trace(index.toString());
        var cartItem:models.CartItem;
        if (index != -1) {
            var amount:int =_cartBox.items.dataProvider.getItemAt(index).amount + 1;

            cartItem = new models.CartItem(this.currentCard, amount);
            _cartBox.items.dataProvider.setItemAt(cartItem,index);

        } else {
            cartItem = new models.CartItem(this.currentCard, 1);
            _cartBox.items.dataProvider.addItem(cartItem);

        }
        //_cart.items.refresh();
        //_cartBox.items.validateNow();
        //_cartBox.items.dataProvider=_cart.items;


        //(_cartBox.items.dataProvider as ArrayCollection).refresh();

        _cardComponent.getComponent().button.label="In Cart";

        MoveCount();

    }
    public function AddCardToCart(card:Card):void{
        var index:int= this.FindCardInCart(card);
        var cartItem:models.CartItem;
        if (index != -1) {
            var amount:int =_cartBox.items.dataProvider.getItemAt(index).amount + 1;
            //var amount:int =_cart.items.getItemAt(index).amount + 1;
            cartItem = new models.CartItem(card, amount);
           // _cart.items.setItemAt(cartItem,index);
            _cartBox.items.dataProvider.setItemAt(cartItem,index);
        } else {
            cartItem = new models.CartItem(card, 1);
            _cartBox.items.dataProvider.addItem(cartItem);
            //_cart.items.addItem(cartItem);

        }
        _cardComponent.getComponent().button.label="In Cart";

        MoveCount();

    }
    public function MoveCount():void{
        _currentCard = null;
        _currentCard = _cards[_currentCardIndex];
        _moveCount=new Move();
        _moveCount.target=_numberItemsLabel;
        _moveCount.yBy=-10;
        _moveCount.duration=200;
        _moveCount.repeatCount=2
        _moveCount.repeatBehavior="reverse"
        _moveCount.play();

    }

    private function CalculateTotals():void{
        var total:int =  _cartBox.items.dataProvider.length;
        //var total:int =  _cart.items.length;
        var item:CartItem;
        _totalItems=0;
        _totalPrice=0;
        for(var i:int=0;i<total;i++){
            item = _cartBox.items.dataProvider.getItemAt(i) as CartItem;
            _totalItems+= item.amount;
            _totalPrice += item.card.price* item.amount;
        }

        _numberItemsLabel.visible=(_totalItems>0);
        _itemsInYourCartImage.visible=(_totalItems>0);

        _cartBox.emptyLabel.visible=(_totalItems==0);
        _cartBoxResponsive.emptyLabel.visible=(_totalItems==0);

        _cartBox.footBox.visible=(_totalItems>0);
        _cartBoxResponsive.height=55*total;
        //_cartBoxResponsive.footBox.visible=(_totalItems>0);

        _numberItemsLabel.label = _totalItems.toString();
        _cartBox.TotalLabel.text = _currency.format(_totalPrice);
        _checkoutBox.TotalLabel.text = _currency.format(_totalPrice);
        (_app.checkoutBoxResponsive as CheckoutResponsiveBox).TotalLabel.text = _currency.format(_totalPrice);
    }

    public function FindCardInCart(card:models.Card):int{
        var total:int =  _cartBox.items.dataProvider.length;
        //var total:int =  _cart.items.length;
        var index:int=-1;
        for(var i:int=0;i<total;i++){
            if( (_cartBox.items.dataProvider.getItemAt(i) as CartItem).card.id==card.id){
                index = i;
            }
        }
        return index;
    }

    public function EvalCardsInTime(time:int):void{
        if(_currentCardIndex<=_cards.length-1){
            if (time >= _currentCard.startTime && time <= _currentCard.endTime) {
                if (!_cardComponent.IsVisible()) {
                    _cardComponent.SetVisible(true);
                    _cardComponent.Show();
                    _cardComponent.RenderCard(_currentCard);
                }

            } else {
                if (_cardComponent.IsVisible()) {
                    _cardComponent.SetVisible(false);
                    _cardComponent.Hide();
                }

                if (time > currentCard.endTime) {
                    NextCard();
                }
            }
        }

    }

    public function get cart():models.Cart {
        return _cart;
    }

    public function set cart(value:models.Cart):void {
        _cart = value;
    }

    public function get cardComponent():iCard {
        return _cardComponent;
    }

    public function set cardComponent(value:iCard):void {
        _cardComponent = value;
    }

    public function ChangeResponsive(card:iCard):void{
        _cardComponent=card;
        _cardComponent.getComponent().button.addEventListener(MouseEvent.CLICK,AddToCart);
    }
    public function ChangeDefault(card:iCard):void{
        _cardComponent=card;
        _cardComponent.getComponent().button.addEventListener(MouseEvent.CLICK,AddToCart);
    }
}
}
