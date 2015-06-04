/**
 * Created by EDINSON on 03/06/2015.
 */
package models {
public class EventTime {
    private var _executed:Boolean=false;
    private var _percentage:Number;
    private var _type:String;
    public function EventTime(type:String='',percentage:Number=0) {
        _percentage=percentage;
        _type=type;
    }

    public function get executed():Boolean {
        return _executed;
    }

    public function set executed(value:Boolean):void {
        _executed = value;
    }

    public function get percentage():Number {
        return _percentage;
    }

    public function set percentege(value:Number):void {
        _percentage = value;
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }
}
}
