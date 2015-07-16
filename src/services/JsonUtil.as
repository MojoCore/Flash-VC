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

import mx.collections.Sort;
import mx.collections.SortField;

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
            card.clientUUID=cardsJson[i].clientUUID;
            card.jsonObject= cardsJson[i];
            list_cards.addItem(card);
        }
        JsonUtil.arrayCollectionSort(list_cards,'startTime',true);
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
        video.actions = JsonUtil.ConvertToCards(json.actions);
        var obj:Object={
            required:['phonenumber','employer','occupation'],
            properties:{
                phonenumber:{
                    uitype:'text',
                    label:{
                        en:'Phone Number',
                        es:'Teléfono'
                    },
                    priority:1
                },
                employer:{
                    uitype:'text',
                    label:{
                        en:'Employer',
                        es:'Empleador'
                    },
                    priority:2
                },
                corporation:{
                    uitype:'text',
                    label:{
                        en:'Corporation',
                        es:'Empresa'
                    },
                    priority:3
                },
                occupation:{
                    uitype:'text',
                    label:{
                        en:'Occupation',
                        es:'Ocupación'
                    },
                    priority:4
                },
                disclaimer1:{
                    uitype:'term',
                    label:{
                        en:'By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.',
                        es:'Termino de Aceptación 1'
                    },
                    priority:1
                },
                disclaimer2:{
                    uitype:'term',
                    label:{
                        en:'Term 2',
                        es:'Termino de Aceptación 2'
                    },
                    priority:2
                }
            },
            button:{
                text:"Contribute",
                bgcolor:"#41abe7",
                color:"white"
            },
            disclaimers:{
                0:{
                    label:{
                        en:'Press {{button_text}} for replace in {{user_company}} and press other {{button_text}}. By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.'
                    }
                },
                1:{
                    label:{
                        en:'By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.'
                    }
                }
            }

        }
        video.formConfig=json.formConfig||new Object();
        return video;

    }

    public static function arrayCollectionSort(ar:ArrayCollection, fieldName:String, isNumeric:Boolean):void
    {
        var dataSortField:SortField = new SortField();
        dataSortField.name = fieldName;
        dataSortField.numeric = isNumeric;
        var numericDataSort:Sort = new Sort();
        numericDataSort.fields = [dataSortField];
        ar.sort = numericDataSort;
        ar.refresh();
    }
}
}
