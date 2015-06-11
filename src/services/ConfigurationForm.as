/**
 * Created by EDINSON on 04/06/2015.
 */
package services {
import components.CheckoutDefaultBox;
import components.CheckoutResponsiveBox;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.URLLoader;

import models.Cart;

import mx.collections.ArrayCollection;

import mx.containers.ViewStack;

import skins.SkinTextInput;


import spark.components.FormItem;
import spark.components.HGroup;
import spark.components.TextInput;
import spark.components.TextInput;
import spark.effects.Move;

import spark.events.IndexChangeEvent;
import spark.layouts.HorizontalLayout;

import util.RestService;

public class ConfigurationForm extends Sprite{
    private var _user:String;
    private var _service:RestService;
    private var _formDefault:CheckoutDefaultBox;
    private var _formResponsive:CheckoutResponsiveBox;
    private var _cart:models.Cart;
    private var _dataConfig:Object;
    private var _app:Object;
    private var _moveCheckoutTop:Move;
    private var _moveCheckoutBottom:Move;
    static private const CONFIG_SERVICE_NAME='users'
    static private const  exclusionsForm:Array  = ["cs_buttonText",'cs_includeIcon','cs_customDisclaimer','cs_disclaimer2','cs_disclaimer1','cs_business_type'];
    private var fields:ArrayCollection;
    public function ConfigurationForm(app:Object,user:String,cart:models.Cart,formDefault:CheckoutDefaultBox=null,formResponsive:CheckoutResponsiveBox=null) {
        _app=app;
        _user=user;
        _cart=cart;
        _formDefault=formDefault;
        _formResponsive=formResponsive
        _service=new RestService(CONFIG_SERVICE_NAME);
        fields=new ArrayCollection();
        fields.addItem({originalname:'cs_phonenumber',id:'phonenumber',name:'Phone Number'});
        fields.addItem({originalname:'cs_occupation',id:'occupation',name:'Occupation'});
        fields.addItem({originalname:'cs_employer',id:'employer',name:'Employer'});
        fields.addItem({originalname:'cs_corporation',id:'corporation',name:'Corporation'});


    }
    public function Configure():void{
        LoadConfiguration();
    }
    public function LoadConfiguration(){
        _service.Get(_user+'?getSettings=1',function(event:Event):void{
            var loader:URLLoader=URLLoader(event.target);
            _dataConfig=JSON.parse(loader.data);
            ConfigureForm();
        });

    }
    public function ConfigureForm():void{
        ConfigAnimation();
        AddListeners();
        _formResponsive.CheckOutButton.label=_dataConfig.cs_buttonText;
        _formDefault.CheckOutButton.label=_dataConfig.cs_buttonText;
        var countFields=0;
        var _existFormItem:Boolean=true;
        var formItem:FormItem;
        var formItemResponsive:HGroup;
        var total:int=0;
        var i:int=0;
        var positionForm:int=2;
        var addHeight:int=0;
        for (var id:String in _dataConfig) total++;
        formItem = _formDefault.finishStaticFieldItems;
        formItemResponsive=_formResponsive.finishStaticFieldItems;
        countFields=1;
        for(var id:String in _dataConfig){
            i++;
            if(FindExludeItem(id)==-1){
                if(_dataConfig[id].hasOwnProperty("present")) {
                    if(_dataConfig[id].present) {
                        addHeight += 30;
                        countFields++;
                        if(!_existFormItem) {
                            formItem = NewFormItem();
                            formItemResponsive = NewFormItemResponsive();
                            _existFormItem = true;
                        }
                        var field:Object=GetField(id);
                        var textInput:TextInput = NewField(field.id, field.name);
                        var textInputR:TextInput = NewFieldResponsive(field.id, field.name);
                        textInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicDefaultHandler);
                        textInput.addEventListener(KeyboardEvent.KEY_UP,changeDynamicDefaultHandler);
                        textInputR.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicResponsiveHandler);
                        textInputR.addEventListener(KeyboardEvent.KEY_UP,changeDynamicResponsiveHandler);
                        field.input=textInput;
                        field.inputResponsive=textInputR;
                        formItem.addElement(textInput);
                        formItemResponsive.addElement(textInputR);
                        if (countFields == 2 || i == total) {
                            _formDefault.CheckOutForm.addElementAt(formItem, positionForm);
                            _formResponsive.CheckOutForm.addElementAt(formItemResponsive, positionForm);
                            positionForm++
                            _existFormItem = false;
                            countFields = 0;
                        }
                    }
                }
            }
        }
        if (countFields >0) {
            _formDefault.CheckOutForm.addElementAt(formItem, positionForm);
            _formResponsive.CheckOutForm.addElementAt(formItemResponsive, positionForm);

        }
        (_app.CheckoutViewStack as ViewStack).height=_formDefault.height+addHeight;
        (_app.CheckoutViewStack as ViewStack).y=-(_formDefault.height+addHeight);
        /*if(_app.stage.stageHeight<=450){
            (_app.CheckoutViewStack as ViewStack).height=_app.stage.stageHeight-50;
        }*/

        _moveCheckoutTop.yTo=-(_formDefault.height+addHeight);
        //_formDefault.parent.re

    }
    private function GetField(originalName:String):Object{
        var index=-1;
        var field:Object;
        for(var i:int=0;i<fields.length;i++){
            if(originalName==fields[i].originalname){
                index=i;
                return fields[i];
            }
        }
        return null;
    }
    public function ConfigAnimation():void{
        _moveCheckoutBottom=new Move();
        _moveCheckoutBottom.target = _app.CheckoutViewStack;
        _moveCheckoutBottom.yTo=0;
        _moveCheckoutBottom.duration=200;

        _moveCheckoutTop=new Move();
        _moveCheckoutTop.target = _app.CheckoutViewStack;
        _moveCheckoutTop.yTo=-450;
        _moveCheckoutTop.duration=200;
    }
    public function ShowDefault():void{
        _moveCheckoutBottom.play();
    }
    public function HideDefault():void{
        _moveCheckoutTop.play();
    }
    private function FindExludeItem(name:String):int{
        var index=-1;
        for(var i:int=0;i<exclusionsForm.length;i++){
            if(name==exclusionsForm[i]){
                index=i;
            }
        }
        return index;
    }
    private function NewFormItem():FormItem{
        var formItem:FormItem=new FormItem();
        formItem.setStyle('textAlign','left');
        formItem.setStyle('color','white');
        formItem.percentWidth=100;
        formItem.layout=new HorizontalLayout();
        return formItem;

    }
    private function NewFormItemResponsive():HGroup{
        var formItem:HGroup=new HGroup();
        formItem.percentWidth=100;
        return formItem;

    }
    private function NewField(id:String,name:String):TextInput{
        var textInput:TextInput=new TextInput();
        textInput.id=id;
        textInput.percentWidth=50;
        textInput.setStyle('skinClass',skins.SkinTextInput);
        textInput.prompt=name;
        return textInput;
    }
    private function NewFieldResponsive(id:String,name:String):TextInput{
        var textInput:TextInput=new TextInput();
        textInput.id=id;
        textInput.percentWidth=50;
        textInput.setStyle('skinClass',skins.SkinTextInputResponsive);
        textInput.prompt=name;
        return textInput;
    }
    private function AddListeners():void{
        //var components:ArrayList=new ArrayList(_formResponsive.nameInput,_formResponsive.emailInput)
        _formResponsive.nameInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.nameInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.emailInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.emailInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.addressInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.addressInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        //_formResponsive.phoneInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        //_formResponsive.phoneInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.cityInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.cityInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.stateInput.addEventListener(IndexChangeEvent.CHANGE,changeResponsiveHandler);

        _formResponsive.zipInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.zipInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.cardnumberInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.cardnumberInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);

        _formResponsive.cvvInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.cvvInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);
        _formResponsive.monthInput.addEventListener(IndexChangeEvent.CHANGE,changeResponsiveHandler);
        _formResponsive.yearInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.yearInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);

        _formDefault.nameInput.addEventListener(KeyboardEvent.KEY_DOWN, changeDefaultHandler);
        _formDefault.nameInput.addEventListener(KeyboardEvent.KEY_UP, changeDefaultHandler);

        _formDefault.emailInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.emailInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.addressInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.addressInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        //_formDefault.phoneInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        //_formDefault.phoneInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.cityInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.cityInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.stateInput.addEventListener(IndexChangeEvent.CHANGE,changeDefaultHandler);

        _formDefault.zipInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.zipInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.cardnumberInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.cardnumberInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.cvvInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.cvvInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
        _formDefault.monthInput.addEventListener(IndexChangeEvent.CHANGE, changeDefaultHandler);

        _formDefault.yearInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDefaultHandler);
        _formDefault.yearInput.addEventListener(KeyboardEvent.KEY_UP,changeDefaultHandler);
    }

    private function changeDynamicDefaultHandler(event:KeyboardEvent):void{
        var input:TextInput=(event.currentTarget as TextInput);
        var index=-1;
        for(var i:int=0;i<fields.length;i++){
            if(fields[i].id==input.id){
                index=i;
            }

        }
        if(index>=0){
            switch(input.id){
                case "phonenumber":
                    _cart.phonenumber=input.text;
                    fields[index].inputResponsive.text=_cart.phonenumber;
                    break;
                case "occupation":
                    _cart.occupation=input.text;
                    fields[index].inputResponsive.text=_cart.occupation;
                    break;
                case "corporation":
                    _cart.corporation=input.text;
                    fields[index].inputResponsive.text=_cart.corporation;
                    break;
                case "employer":
                    _cart.employer=input.text;
                    fields[index].inputResponsive.text=_cart.employer;
                    break;
            }
        }
    }
    private function changeDynamicResponsiveHandler(event:KeyboardEvent):void{
        var input:TextInput=(event.currentTarget as TextInput);
        var index=-1;
        for(var i:int=0;i<fields.length;i++){
            if(fields[i].id==input.id){
                index=i;
            }

        }
        if(index>=0){
            switch(input.id){
                case "phonenumber":
                    _cart.phonenumber=input.text;
                    fields[index].input.text=_cart.phonenumber;
                    break;
                case "occupation":
                    _cart.occupation=input.text;
                    fields[index].input.text=_cart.occupation;
                    break;
                case "corporation":
                    _cart.corporation=input.text;
                    fields[index].input.text=_cart.corporation;
                    break;
                case "employer":
                    _cart.employer=input.text;
                    fields[index].input.text=_cart.employer;
                    break;
            }
        }

    }
    private function UpdateCart(form):void{
        _cart.billing_firstName=form.nameInput.text;
        _cart.email = form.emailInput.text
        _cart.billing_address1=form.addressInput.text
        /*if(form.contains())
        _cart.phonenumber=form.phonenumber.text;
        _cart.corporation=form.corporation.text;
        _cart.employer=form.employer.text;
        _cart.ocupattion=form.ocupattion.text;*/

        _cart.billing_city=form.cityInput.text;
        _cart.billing_zip=form.zipInput.text;
        _cart.cc_number=form.cardnumberInput.text;
        _cart.cc_cvv=form.cvvInput.text;
        if(form.stateInput.selectedIndex>=0)
            _cart.billing_state=form.stateInput.selectedItem.data;
        if(form.monthInput.selectedIndex>=0)
            _cart.cc_expMonth=form.monthInput.selectedItem.data;
        _cart.cc_expYear=form.yearInput.text;
    }
    private function changeDefaultHandler(event:Object):void {
        UpdateCart(_formDefault);
        _formResponsive.nameInput.text =  _cart.billing_firstName;
        _formResponsive.emailInput.text =  _cart.email;
        _formResponsive.addressInput.text = _cart.billing_address1;
        //_formResponsive.phoneInput.text = _cart.phonenumber;
        _formResponsive.cityInput.text = _cart.billing_city;
        _formResponsive.stateInput.selectedIndex = _formDefault.stateInput.selectedIndex;
        _formResponsive.zipInput.text = _cart.billing_zip;
        _formResponsive.cardnumberInput.text = _cart.cc_number;
        _formResponsive.cvvInput.text = _cart.cc_cvv;
        _formResponsive.monthInput.selectedIndex = _formDefault.monthInput.selectedIndex;
        _formResponsive.yearInput.text = _cart.cc_expYear;
    }

    private function changeResponsiveHandler(event:Object):void {

        UpdateCart(_formResponsive);
        _formDefault.nameInput.text =  _cart.billing_firstName;
        _formDefault.emailInput.text =  _cart.email;
        _formDefault.addressInput.text = _cart.billing_address1;
        //_formDefault.phoneInput.text = _cart.phonenumber;
        _formDefault.cityInput.text = _cart.billing_city;
        _formDefault.stateInput.selectedIndex = _formResponsive.stateInput.selectedIndex;
        _formDefault.zipInput.text = _cart.billing_zip;
        _formDefault.cardnumberInput.text = _cart.cc_number;
        _formDefault.cvvInput.text = _cart.cc_cvv;
        _formDefault.monthInput.selectedIndex = _formResponsive.monthInput.selectedIndex;
        _formDefault.yearInput.text = _cart.cc_expYear;
    }


}
}
