/**
 * Created by EDINSON on 02/06/2015.
 */
package models {
public class Order {
    private var _cart:Cart;
    public function Order(cart:Cart=null) {
        _cart=cart;
    }

    public function get cart():Cart {
        return _cart;
    }

    public function set cart(value:Cart):void {
        _cart = value;
    }
}
}
