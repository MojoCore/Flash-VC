/**
 * Created by nodejs01 on 5/11/15.
 */
package models {

public class Card{
    private var _y:int;
    private var _x:int;
    private var _title:String='';
    private var _image:String='';
    private var _price:String='';
    private var _buttonText:String='Add to Card';
    private var _startTime:int;
    private var _endTime:int;

    public function Card(){

    }

    public function get title():String {
        return _title;
    }

    public function set title(value:String):void {

        _title = value;

    }

    public function get price():String {
        return _price;
    }

    public function set price(value:String):void {
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
}
}
