/**
 * Created by nodejs01 on 5/11/15.
 */
package models {

public class Card{
    private var _y:int;
    private var _x:int;
    private var _id:String;
    private var _title:String='';
    private var _image:String='';
    private var _price:Number=0;
    private var _buttonText:String='Add to Card';
    private var _buttonColor:String="";
    private var _startTime:int;
    private var _endTime:int;
    private var _product:Product;
    private var _clientUUID:String;
    private var _jsonObject:Object;

    public function Card(){
        _product=new Product();
        _jsonObject=new Object();
    }

    public function get title():String {
        return _title;
    }

    public function set title(value:String):void {

        _title = value;

    }

    public function get price():Number {
        return _price;
    }

    public function set price(value:Number):void {
        _price = value;
    }

    public function get buttonText():String {
        return _buttonText;
    }

    public function set buttonText(value:String):void {
        _buttonText = value;
    }

    public function get image():String {
        return _image;
    }

    public function set image(value:String):void {
        _image = value;
    }

    public function get endTime():int {
        return _endTime;
    }

    public function set endTime(value:int):void {
        _endTime = value;
    }

    public function get startTime():int {
        return _startTime;
    }

    public function set startTime(value:int):void {
        _startTime = value;
    }

    public function get buttonColor():String {
        return _buttonColor;
    }

    public function set buttonColor(value:String):void {
        _buttonColor = value;
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get product():Product {
        return _product;
    }

    public function set product(value:Product):void {
        _product = value;
    }

    public function get jsonObject():Object {
        return _jsonObject;
    }

    public function set jsonObject(value:Object):void {
        _jsonObject = value;
    }

    public function get clientUUID():String {
        return _clientUUID;
    }

    public function set clientUUID(value:String):void {
        _clientUUID = value;
    }
}
}
