/**
 * Created by nodejs01 on 5/11/15.
 */
package models {
import components.Card;

import flash.events.MouseEvent;

import models.Card;

public class CardComponent {
    private var _component:components.Card;
    public function CardComponent(card:components.Card) {
        _component = card;
    }

    public function RenderCard(card:models.Card,btnAdd:Function):void{
        _component.titleLabel.text = card.title;
        _component.image.source = card.image;
        _component.pricelLabel.text = card.price;
        _component.button.label = card.buttonText;
        _component.button.setStyle('color',card.buttonColor);
        _component.button.addEventListener(MouseEvent.CLICK,btnAdd);

    }

    public function get component():components.Card {
        return _component;
    }

    public function set component(value:components.Card):void {
        _component = value;
    }
}
}
