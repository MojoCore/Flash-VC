/**
 * Created by nodejs01 on 5/19/15.
 */
package models {
import mx.collections.ArrayCollection;

public class Video {
    private var _id:String;
    private var _user:String;
    private var _duration:Number;
    private var _actions:ArrayCollection;
    private var _formConfig:Object;
    private var _campaign_type:String;
    private var _encodedFiles:Object;
    public function Video() {
        _actions=new ArrayCollection();
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

    public function get actions():ArrayCollection {
        return _actions;
    }

    public function set actions(value:ArrayCollection):void {
        _actions = value;
    }

    public function get duration():Number {
        return _duration;
    }

    public function set duration(value:Number):void {
        _duration = value;
    }

    public function get formConfig():Object {
        return _formConfig;
    }

    public function set formConfig(value:Object):void {
        _formConfig = value;
    }

    public function get campaign_type():String {
        return _campaign_type;
    }

    public function set campaign_type(value:String):void {
        _campaign_type = value;
    }

    public function get encodedFiles():Object {
        return _encodedFiles;
    }

    public function set encodedFiles(value:Object):void {
        _encodedFiles = value;
    }
}
}
