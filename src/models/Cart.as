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
    private var _billing_firstName:String="";
    private var _billing_lastName:String="";
    private var _billing_address1:String="";
    private var _billing_city:String="";
    private var _billing_state:String="";
    private var _billing_zip:String="";
    private var _cc_cvv:String="";
    private var _cc_expMonth:String="";
    private var _cc_expYear:String="";
    private var _cc_number:String="";
    private var _email:String="";
    private var _phonenumber:String="";
    private var _corporation:String='';
    private var _occupation:String;
    private var _employer:String;
    [Bindable]
    private var _items:ArrayCollection;
    public function Cart() {
        _items= new ArrayCollection();
    }
    public function Add(item:CartItem):void{
        _items.addItem(item);
    }
    [Bindable]
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

    public function get billing_firstName():String {
        return _billing_firstName;
    }

    public function set billing_firstName(value:String):void {
        _billing_firstName = value;
    }

    public function get billing_address1():String {
        return _billing_address1;
    }

    public function set billing_address1(value:String):void {
        _billing_address1 = value;
    }

    public function get billing_city():String {
        return _billing_city;
    }

    public function set billing_city(value:String):void {
        _billing_city = value;
    }

    public function get billing_state():String {
        return _billing_state;
    }

    public function set billing_state(value:String):void {
        _billing_state = value;
    }

    public function get billing_zip():String {
        return _billing_zip;
    }

    public function set billing_zip(value:String):void {
        _billing_zip = value;
    }

    public function get cc_cvv():String {
        return _cc_cvv;
    }

    public function set cc_cvv(value:String):void {
        _cc_cvv = value;
    }

    public function get cc_expMonth():String {
        return _cc_expMonth;
    }

    public function set cc_expMonth(value:String):void {
        _cc_expMonth = value;
    }

    public function get cc_expYear():String {
        return _cc_expYear;
    }

    public function set cc_expYear(value:String):void {
        _cc_expYear = value;
    }

    public function get cc_number():String {
        return _cc_number;
    }

    public function set cc_number(value:String):void {
        _cc_number = value;
    }

    public function get email():String {
        return _email;
    }

    public function set email(value:String):void {
        _email = value;
    }

    public function get phonenumber():String {
        return _phonenumber;
    }

    public function set phonenumber(value:String):void {
        _phonenumber = value;
    }

    public function get billing_lastName():String {
        return _billing_lastName;
    }

    public function set billing_lastName(value:String):void {
        _billing_lastName = value;
    }

    public function get corporation():String {
        return _corporation;
    }

    public function set corporation(value:String):void {
        _corporation = value;
    }

    public function get occupation():String {
        return _occupation;
    }

    public function set occupation(value:String):void {
        _occupation = value;
    }

    public function get employer():String {
        return _employer;
    }

    public function set employer(value:String):void {
        _employer = value;
    }
}
}
