/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import models.Card;
import models.CardComponent;

import mx.collections.ArrayCollection;

import spark.effects.Fade;

public class TransitionCards {
    private var _cards:ArrayCollection;
    private var _currentCardIndex:int=0;
    private var _currentCard:models.Card;
    private var _cardComponent:CardComponent;
    private var _visibleCard:Boolean = false;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    public function TransitionCards(cards:ArrayCollection,cardCmp:CardComponent) {
        _cards = cards;
        _cardComponent = cardCmp;
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

    public function EvalCardsInTime(time:int):void{
        if(_currentCardIndex<_cards.length-1){
            if (time >= _currentCard.startTime && time <= _currentCard.endTime) {
                if (!_visibleCard) {
                    _visibleCard = true;
                    _fadeShow.play();
                    _cardComponent.RenderCard(_currentCard);
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
}
}
