/**
 * Created by nodejs01 on 5/19/15.
 */
package models {
public class Video {
    private var _id:String;
    private var _user:String;
    public function Video() {
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get user():String {
        return _user;
    }

    public function set user(value:String):void {
        _user = value;
    }
}
}
