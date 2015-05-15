/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import components.Card;

import flash.events.MouseEvent;

import models.Card;
import models.Card;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

public class Card {
    private var _cards:ArrayCollection;
    public function Card() {
    }
    public static function ConvertToCards(cardsJson:Object):ArrayCollection{
        var list_cards:ArrayCollection = new ArrayCollection();
        for(var i:int=0;i<cardsJson.length;i++){
            var card:models.Card=new models.Card();
            card.id = cardsJson[i]._id;
            card.title = cardsJson[i].product.name;
            card.image = cardsJson[i].product.image.url;
            card.price = '$' + cardsJson[i].product.price;
            card.buttonText = cardsJson[i].name;
            card.startTime = cardsJson[i].startTime;
            card.endTime = cardsJson[i].endTime;
            card.buttonColor = Card.ConvertColor(cardsJson[i].buttonBgColor);
            list_cards.addItem(card);
        }
        return list_cards;
    }

    public static function ConvertColor(c:String):String{
        var color:String = "0x" + c.substr(1);
        return color;
    }

    public static function RenderCard(component:components.Card ,card:models.Card):void{
        component.titleLabel.text = card.title;
        component.image.source = card.image;
        component.pricelLabel.text = card.price;
        component.button.label = card.buttonText;
        component.button.setStyle('color',card.buttonColor);

    }
}
}
