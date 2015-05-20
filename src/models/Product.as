/**
 * Created by nodejs01 on 5/20/15.
 */
package models {
public class Product {
    private var _id:String;
    private var _name:String;
    public function Product() {
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }
}
}
