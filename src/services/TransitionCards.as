/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import Implements.CardDefault;

import components.CardDefault;

import components.Cart;

import flash.events.Event;
import flash.events.MouseEvent;

import iComponents.iCard;
import iComponents.iEvent;

import models.Card;
import models.Cart;
import models.CartItem;
import models.EventViewVideo;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import spark.components.Button;
import spark.effects.Fade;
import spark.effects.Move;
import spark.effects.easing.Elastic;

public class TransitionCards {
    private var _cards:ArrayCollection;
    private var _currentCardIndex:int=0;
    private var _currentCard:models.Card;
    private var _cardComponent:iCard;
    private var _visibleCard:Boolean = false;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    private var _cart:models.Cart;
    private var _cartBox:components.Cart;
    private var _numberItemsLabel:Button;


    private var _elastic:Elastic;
    private var _moveCount:Move;
    private var _totalItems:Number;
    private var _totalPrice:Number;



    public function TransitionCards(cards:ArrayCollection,cardCmp:iCard,cartBox:components.Cart,numberItems:Button) {
        _totalItems=0;
        _totalPrice=0;
        _cards = cards;
        _cardComponent = cardCmp;
        _cartBox = cartBox;
        _numberItemsLabel=numberItems;
        _cart=new models.Cart();
        if(_currentCardIndex<=cards.length-1)
            _currentCard = _cards[_currentCardIndex];
        _cardComponent.getComponent().button.addEventListener(MouseEvent.CLICK,AddToCart);
        _cart.items.addEventListener(CollectionEvent.COLLECTION_CHANGE, items_collectionChange);
        //InitFade();
    }
    private function items_collectionChange(evt:CollectionEvent):void{
        CalculateTotals()
        if(_totalItems>0)
            _numberItemsLabel.visible=true;
        else
            _numberItemsLabel.visible=false;
        //MoveCount();

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


        var index:int=this.FindCardInCart(this.currentCard);
        var cartItem:models.CartItem;
        if (index != -1) {
            cartItem = models.CartItem(_cart.items.getItemAt(index));
            cartItem.amount = cartItem.amount + 1;

        } else {
            cartItem = new models.CartItem(this.currentCard, 1);
            _cart.Add(cartItem);

        }
        _cardComponent.getComponent().button.label="In Cart";
        _cartBox.dataCart = _cart.items;
        (_cartBox.items.dataProvider as ArrayCollection).refresh();
        MoveCount();

    }

    private function MoveCount():void{
        _currentCard = null;
        _currentCard = _cards[_currentCardIndex];
        //Alert.show("add..");
        trace("message");

        _moveCount=new Move();
        _moveCount.target=_numberItemsLabel;
        _moveCount.yBy=-10;
        _moveCount.duration=200;
        _moveCount.repeatCount=2
        _moveCount.repeatBehavior="reverse"

        _moveCount.play();



    }

    private function CalculateTotals():void{
        var total:int = _cart.items.length;
        _totalItems=0;
        _totalPrice=0;
        for(var i:int=0;i<total;i++){
            _totalItems+=_cart.items.getItemAt(i).amount
            _totalPrice += _cart.items.getItemAt(i).card.price*_cart.items.getItemAt(i).amount;
        }
        _numberItemsLabel.label = _totalItems.toString();
        _cartBox.TotalLabel.text = '$'+_totalPrice.toString();
    }

    private function FindCardInCart(card:models.Card):int{
        var total:int = _cart.items.length;
        var index:int=-1;
        for(var i:int=0;i<total;i++){
            if(_cart.items.getItemAt(i).card.id==card.id){
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
