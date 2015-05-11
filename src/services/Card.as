/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import models.Card;
import models.Card;

import mx.collections.ArrayCollection;

public class Card {
    private var _cards:ArrayCollection;
    public function Card() {
    }
    public static function ConvertToCards(cardsJson:Object):ArrayCollection{
        var list_cards:ArrayCollection = new ArrayCollection();
        for(var i:int=0;i<cardsJson.length;i++){
            var card:models.Card=new models.Card();
            card.title = cardsJson[i].product.name;
            card.image = cardsJson[i].product.image.url;
            card.price = '$' + cardsJson[i].product.price;
            card.buttonText = cardsJson[i].name;
            card.startTime = cardsJson[i].startTime;
            card.endTime = cardsJson[i].endTime;
            list_cards.addItem(card);
        }
        return list_cards;
    }
}
}
