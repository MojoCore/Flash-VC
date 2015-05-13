/**
 * Created by nodejs01 on 5/12/15.
 */
package models {
public class CartItem {
    private var _card:Card;
    private var _amount:Number=1;
    public function CartItem(card:Card,amount:Number) {
        _card = card;
        _amount = amount;
    }

    public function get amount():Number {
        return _amount;
    }

    public function set amount(value:Number):void {
        _amount = value;
    }

    public function get card():Card {
        return _card;
    }

    public function set card(value:Card):void {
        _card = value;
    }
}
}
