/**
 * Created by nodejs01 on 5/12/15.
 */
package models {
public class CartItem {
    private var _card:Card;
    private var _amount:Number=1;
    private var _jsonObject:Object;
    public function CartItem(card:Card,amount:Number) {
        _card = card;
        _amount = amount;
        _jsonObject=new Object();
    }

    public function get amount():Number {
        return _amount;
    }

    public function set amount(value:Number):void {
        _amount = value;
        _jsonObject.quantity= value;
    }

    public function get card():Card {
        return _card;
    }

    public function set card(value:Card):void {
        _card = value;
    }

    public function get jsonObject():Object {
        return _jsonObject;
    }

    public function set jsonObject(value:Object):void {
        _jsonObject = value;
    }
}
}
