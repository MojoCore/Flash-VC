/**
 * Created by nodejs01 on 5/19/15.
 */
package Implements {
import components.CardResponsive;

import Interfaces.iCard;

import models.Card;

import mx.formatters.CurrencyFormatter;

import spark.effects.Fade;

public class CardResponsive implements iCard{
    private var _cardComponent:components.CardResponsive;
    private var _fadeShow:Fade;
    private var _fadeHide:Fade;
    private var _isVisible:Boolean;
    private var _currency:CurrencyFormatter;
    public function CardResponsive(cardCmp:components.CardResponsive) {
        _currency=new CurrencyFormatter();
        _currency.precision=2;
        _currency.currencySymbol="$";
        _currency.thousandsSeparatorTo=",";
        _currency.decimalSeparatorTo=".";
        _cardComponent = cardCmp;
        _isVisible = false;
        InitFade();
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

    }

    public function Show():void {
        _fadeShow.play();
    }

    public function Hide():void {
        _fadeHide.play();
    }


    public function getComponent():Object {
        return _cardComponent;
    }

    public function RenderCard(card:models.Card):void{
        _cardComponent.titleLabel.text = card.product.name;
        _cardComponent.image.source = card.image;
        _cardComponent.pricelLabel.text =_currency.format(card.price);
        _cardComponent.button.label = card.buttonText;
        _cardComponent.button.setStyle('color',card.buttonColor);

    }

    public function IsVisible():Boolean {
        return _isVisible;
    }

    public function SetVisible(value:Boolean):void {
        _isVisible = value;
        _cardComponent.button.enabled = _isVisible;
    }


}
}
