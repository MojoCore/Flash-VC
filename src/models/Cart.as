/**
 * Created by nodejs01 on 5/12/15.
 */
package models {
import mx.collections.ArrayCollection;

public class Cart {
    private var _id:String;
    private var _createAt:String;
    private var _updatedAt:String;
    private var _video:String;
    private var _accessToken:String;
    private var _user:String;
    private var _v:Number;
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

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get createAt():String {
        return _createAt;
    }

    public function set createAt(value:String):void {
        _createAt = value;
    }

    public function get updatedAt():String {
        return _updatedAt;
    }

    public function set updatedAt(value:String):void {
        _updatedAt = value;
    }

    public function get video():String {
        return _video;
    }

    public function set video(value:String):void {
        _video = value;
    }

    public function get accessToken():String {
        return _accessToken;
    }

    public function set accessToken(value:String):void {
        _accessToken = value;
    }

    public function get user():String {
        return _user;
    }

    public function set user(value:String):void {
        _user = value;
    }

    public function get v():Number {
        return _v;
    }

    public function set v(value:Number):void {
        _v = value;
    }
}
}
