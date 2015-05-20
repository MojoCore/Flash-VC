/**
 * Created by nodejs01 on 5/19/15.
 */
package iComponents {
import models.Card;

public interface iCard {
    function Show():void;
    function Hide():void;
    function getComponent():Object;
    function RenderCard(card:Card):void;
    function IsVisible():Boolean;
    function SetVisible(value:Boolean):void;
}
}
