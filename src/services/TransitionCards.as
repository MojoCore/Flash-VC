/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import Implements.CardDefault;

import components.CardDefault;

import components.Cart;

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

import spark.components.Button;
import spark.effects.Fade;
import spark.effects.Move;
import spark.effects.easing.Elastic;

public class TransitionCards {
    private var _cards:ArrayCollection;
    private var _currentCardIndex:int=0;
    private var _currentCard:models.Card;
    private var _cardComponent:iCard;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    private var _cart:models.Cart;
    private var _cartBox:components.Cart;
    private var _numberItemsLabel:Button;


    private var _elastic:Elastic;
    private var _moveCount:Move;
    private var _totalItems:Number;
    private var _totalPrice:Number;
    private var _eventAddToCart:iEvent;
    private var _eventRemoveFromCart:iEvent;
    private var _eventUpdateCart:iEvent;
    private var _video:Video;



    public function TransitionCards(cards:ArrayCollection,cardCmp:iCard,cartBox:components.Cart,numberItems:Button,video:Video) {
        _video=video;
        _totalItems=0;
        _totalPrice=0;
        _cards = cards;
        _cardComponent = cardCmp;
        _cartBox = cartBox;
        _numberItemsLabel=numberItems;
        _eventAddToCart=new EventAction('ADD_TO_CART',_video);
        _eventRemoveFromCart=new EventAction('REMOVE_FROM_CART',_video);
        _eventUpdateCart=new EventAction('UPDATE_FROM_CART',_video);
        _cartBox.items.dataProvider=new ArrayCollection();
        _cart=new models.Cart();
        if(_currentCardIndex<=cards.length-1)
            _currentCard = _cards[_currentCardIndex];
        _cardComponent.getComponent().button.addEventListener(MouseEvent.CLICK,AddToCart);
        _cartBox.items.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, items_collectionChange);

        //InitFade();
    }
    private function items_collectionChange(evt:CollectionEvent):void{
        trace(evt.kind);
        trace(evt.items);
        switch(evt.kind){
            case CollectionEventKind.ADD:
                _eventAddToCart.RegisterEvent(evt.items[0].card);
                break;
            case CollectionEventKind.REMOVE:
                _eventRemoveFromCart.RegisterEvent(evt.items[0].card);
                break;
            case CollectionEventKind.UPDATE:
            case CollectionEventKind.REPLACE:
                _eventUpdateCart.RegisterEvent(_cartBox.items.dataProvider.getItemAt(evt.location).card);
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
        _cardComponent.getComponent().button.label="In Cart";

        MoveCount();

    }

    private function MoveCount():void{
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
        var item:CartItem;
        _totalItems=0;
        _totalPrice=0;
        for(var i:int=0;i<total;i++){
            item = _cartBox.items.dataProvider.getItemAt(i) as CartItem;
            _totalItems+= item.amount;
            _totalPrice += item.card.price* item.amount;
        }

        _numberItemsLabel.visible=(_totalItems>0);
        _numberItemsLabel.label = _totalItems.toString();
        _cartBox.TotalLabel.text = '$'+_totalPrice.toString();
    }

    private function FindCardInCart(card:models.Card):int{
        var total:int =  _cartBox.items.dataProvider.length;
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
