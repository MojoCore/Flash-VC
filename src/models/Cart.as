/**
 * Created by nodejs01 on 5/12/15.
 */
package models {
import mx.collections.ArrayCollection;

public class Cart {
    private var _items:ArrayCollection;
    public function Cart() {
        _items= new ArrayCollection();
    }
    public function Add(item:CartItem):void{
        _items.addItem(item);
    }

    public function get items():ArrayCollection {
        return _items;
    }

    public function set items(value:ArrayCollection):void {
        _items = value;
    }
}
}
