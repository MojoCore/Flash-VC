/**
 * Created by nodejs01 on 5/11/15.
 */
package services {
import components.CardDefault;

import flash.events.MouseEvent;

import models.Card;
import models.Card;
import models.Video;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

public class JsonUtil {
    private var _cards:ArrayCollection;
    public function JsonUtil() {
    }
    public static function ConvertToCards(cardsJson:Object):ArrayCollection{
        var list_cards:ArrayCollection = new ArrayCollection();
        for(var i:int=0;i<cardsJson.length;i++){
            var card:models.Card=new models.Card();
            card.id = cardsJson[i]._id;
            card.title = cardsJson[i].product.name;
            card.image = cardsJson[i].product.image.url;
            card.price = cardsJson[i].product.price;
            card.buttonText = cardsJson[i].name;
            card.startTime = cardsJson[i].startTime;
            card.endTime = cardsJson[i].endTime;
            card.buttonColor = JsonUtil.ConvertColor(cardsJson[i].buttonBgColor);
            card.product.id = cardsJson[i].product._id;
            card.product.name = cardsJson[i].product.name;
            list_cards.addItem(card);
        }
        return list_cards;
    }

    public static function ConvertColor(c:String):String{
        var color:String = "0x" + c.substr(1);
        return color;
    }

    public static function ConvertToVideo(json:Object):Video{
        var video:Video=new Video();
        video.id = json._id;
        video.user = json.user;
        return video;

    }
}
}
