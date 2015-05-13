/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import components.Cart;

import flash.events.Event;

import models.Card;
import models.CardComponent;
import models.Cart;
import models.CartItem;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

import spark.components.Button;

import spark.components.Label;

import spark.effects.Fade;

public class TransitionCards {
    private var _cards:ArrayCollection;
    private var _currentCardIndex:int=0;
    private var _currentCard:models.Card;
    private var _cardComponent:CardComponent;
    private var _visibleCard:Boolean = false;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    private var _cart:models.Cart;
    private var _cartBox:components.Cart;
    private var _numberItemsLabel:Button;
    public function TransitionCards(cards:ArrayCollection,cardCmp:CardComponent,cartBox:components.Cart,numberItems:Button) {
        _cards = cards;
        _cardComponent = cardCmp;
        _cartBox = cartBox;
        _numberItemsLabel=numberItems;
        _cart=new models.Cart();
        if(_currentCardIndex<=cards.length-1)
            _currentCard = _cards[_currentCardIndex];
        InitFade();
    }

    public function ResetTransitions():void{
        _currentCardIndex = 0;
        if(_currentCardIndex<=_cards.length-1)
            _currentCard = _cards[_currentCardIndex];
    }

    private function InitFade():void{
        _fadeShow = new Fade();
        _fadeHide = new Fade();
        _fadeShow.target = _cardComponent.component;
        _fadeHide.target = _cardComponent.component;

        _fadeShow.alphaFrom =0;
        _fadeShow.alphaTo = 1;
        _fadeShow.duration = 500;

        _fadeHide.alphaFrom =1;
        _fadeHide.alphaTo = 0;
        _fadeHide.duration = 500;
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
        var cardItem:models.CartItem=new models.CartItem(this.currentCard,1);
        _cart.Add(cardItem);
        _cartBox.dataCart = _cart.items;
        _numberItemsLabel.label = cart.items.length.toString();
        _numberItemsLabel.visible=true;
    }

    public function EvalCardsInTime(time:int):void{
        if(_currentCardIndex<_cards.length-1){
            if (time >= _currentCard.startTime && time <= _currentCard.endTime) {
                if (!_visibleCard) {
                    _visibleCard = true;
                    _fadeShow.play();
                    _cardComponent.RenderCard(_currentCard,this.AddToCart);
                }

            } else {
                if (_visibleCard) {
                    _visibleCard = false;
                    _fadeHide.play();
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
}
}
