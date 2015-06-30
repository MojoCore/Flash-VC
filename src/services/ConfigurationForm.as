/**
 * Created by EDINSON on 04/06/2015.
 */
package services {
import components.CheckoutDefaultBox;
import components.CheckoutResponsiveBox;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.net.URLLoader;

import models.Cart;

import mx.collections.ArrayCollection;

import mx.containers.ViewStack;

import myLib.controls.ScrollBar;

import skins.SkinTextInput;

import spark.components.CheckBox;


import spark.components.FormItem;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.TextInput;
import spark.components.VGroup;
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
    private var _states:ArrayCollection;
    private var _years:ArrayCollection;
    private var _months:ArrayCollection;
    private var _titleButton:String;
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
        InitYears();
        InitStates();
        InitMonths();

    }
    private function InitYears():void{
        _years=new ArrayCollection();
        var date:Date=new Date();
        var year:int = date.getFullYear();
        for(var i:int=0;i<7;i++){
            _years.addItem({label:year+i,data:year+i});
        }

    }
    private function InitStates():void{
        _states=new ArrayCollection();
        _states.addItem({label:'Alabama',data:'AL'});
        _states.addItem({label:'Alaska',data:'AK'});
        _states.addItem({label:'Arizona',data:'AZ'});
        _states.addItem({label:'Arkanas',data:'AR'});
        _states.addItem({label:'California',data:'CA'});
        _states.addItem({label:'Alabama',data:'CO'});
        _states.addItem({label:'Connecticut',data:'CT'});
        _states.addItem({label:'Delaware',data:'DE'});
        _states.addItem({label:'Florida',data:'FL'});
        _states.addItem({label:'Georgia',data:'GA'});
        _states.addItem({label:'Hawaii',data:'HI'});
        _states.addItem({label:'Idaho',data:'ID'});
        _states.addItem({label:"Illinois",data:"IL"});
        _states.addItem({label:"Indiana",data:"IN"});
        _states.addItem({label:"Idaho",data:"ID"});
        _states.addItem({label:"Iowa",data:"IA"});
        _states.addItem({label:"Kansas",data:"KS"});
        _states.addItem({label:"Kentucky",data:"KY"});
        _states.addItem({label:"Louisiana",data:"LA"});
        _states.addItem({label:"Maine",data:"ME"});
        _states.addItem({label:"Maryland",data:"MD"});
        _states.addItem({label:"Massachusetts",data:"MA"});
        _states.addItem({label:"Michigan",data:"MI"});
        _states.addItem({label:"Minnesota",data:"MN"});
        _states.addItem({label:"Mississippi",data:"MS"});
        _states.addItem({label:"Missouri",data:"MO"});
        _states.addItem({label:"Montana",data:"MT"});
        _states.addItem({label:"Nebraska",data:"NE"});
        _states.addItem({label:"New Hampshire",data:"NH"});
        _states.addItem({label:"New Jersey",data:"NJ"});
        _states.addItem({label:"New Mexico",data:"NM"});
        _states.addItem({label:"New York",data:"NY"});
        _states.addItem({label:"North Carolina",data:"NC"});
        _states.addItem({label:"North Dakota",data:"ND"});
        _states.addItem({label:"Ohio",data:"OH"});
        _states.addItem({label:"Oklahoma",data:"OK"});
        _states.addItem({label:"Oregon",data:"OR"});
        _states.addItem({label:"Pennsylvania",data:"PA"});
        _states.addItem({label:"Rhode Island",data:"RI"});
        _states.addItem({label:"South Carolina",data:"SC"});
        _states.addItem({label:"South Dakota",data:"SD"});
        _states.addItem({label:"Tennessee",data:"TN"});
        _states.addItem({label:"Texas",data:"TX"});
        _states.addItem({label:"Utah",data:"UT"});
        _states.addItem({label:"Vermont",data:"VT"});
        _states.addItem({label:"Virginia",data:"VA"});
        _states.addItem({label:"Washington",data:"WA"});
        _states.addItem({label:"West Virginia",data:"WV"});
        _states.addItem({label:"Wisconsin",data:"WI"});
        _states.addItem({label:"Wyoming",data:"WY"});

    }

    private function InitMonths():void{
        _months=new ArrayCollection();
        _months.addItem({label:"JANUARY",data:"01"});
        _months.addItem({label:"FEBRUARY",data:"02"});
        _months.addItem({label:"MARCH",data:"03"});
        _months.addItem({label:"APRIL",data:"04"});
        _months.addItem({label:"MAY",data:"05"});
        _months.addItem({label:"JUNE",data:"06"});
        _months.addItem({label:"JULY",data:"07"});
        _months.addItem({label:"AUGUST",data:"08"});
        _months.addItem({label:"SEPTEMBER",data:"09"});
        _months.addItem({label:"OCTOBER",data:"10"});
        _months.addItem({label:"NOVEMBER",data:"11"});
        _months.addItem({label:"DECEMBER",data:"12"});
    }
    public function Configure(fn:Function=null):void{
        LoadConfiguration(fn);
    }
    public function LoadConfiguration(fn:Function=null){
        _formResponsive.stateInput.dataProvider=_states;
        //_formResponsive.monthInput.dataProvider=_months;
        //_formResponsive.yearInput.dataProvider=_years;
        _formDefault.stateInput.dataProvider=_states;
        _formDefault.monthInput.dataProvider=_months;
        _formDefault.yearInput.dataProvider=_years;
        _service.Get(_user+'?getSettings=1',function(event:Event):void{
            var loader:URLLoader=URLLoader(event.target);
            _dataConfig=JSON.parse(loader.data);
            ConfigureForm();
            if(fn!=null){
                fn();
            }
        });

    }
    public function ConfigureForm():void{
        ConfigAnimation();
        AddListeners();
        _titleButton=_dataConfig.cs_buttonText;
        _formResponsive.CheckOutButton.label=_dataConfig.cs_buttonText;
        _formDefault.CheckOutButton.label=_dataConfig.cs_buttonText;

        _app.btnTabCheckout.title=_dataConfig.cs_buttonText;
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
                        var textInputR:Object = NewFieldResponsive(field.id, field.name);
                        textInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicDefaultHandler);
                        textInput.addEventListener(KeyboardEvent.KEY_UP,changeDynamicDefaultHandler);
                        textInputR.textInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicResponsiveHandler);
                        textInputR.textInput.addEventListener(KeyboardEvent.KEY_UP,changeDynamicResponsiveHandler);
                        textInputR.textInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
                        field.input=textInput;
                        field.inputResponsive=textInputR.textInput;
                        formItem.addElement(textInput);
                        formItemResponsive.addElement(textInputR.groupItem);
                        if (countFields == 2 || i == total) {
                            _formDefault.CheckOutForm.addElementAt(formItem, positionForm);
                            _formResponsive.CheckOutForm.addElementAt(formItemResponsive, positionForm);
                            positionForm++
                            _existFormItem = false;
                            countFields = 0;
                        }
                    }
                }
            }else{
                if(id=='cs_disclaimer1'){
                    _formDefault.cs_disclaimer1.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formDefault.cs_disclaimer1.visible=_dataConfig[id];
                    _formDefault.cs_disclaimer1.includeInLayout=_dataConfig[id];

                    _formResponsive.cs_disclaimer1.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formResponsive.cs_disclaimer1.visible=_dataConfig[id];
                    _formResponsive.cs_disclaimer1.includeInLayout=_dataConfig[id];
                }
                if(id=='cs_disclaimer2'){
                    _formDefault.cs_disclaimer2.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formDefault.cs_disclaimer2.visible=_dataConfig[id];
                    _formDefault.cs_disclaimer2.includeInLayout=_dataConfig[id];

                    _formResponsive.cs_disclaimer2.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formResponsive.cs_disclaimer2.visible=_dataConfig[id];
                    _formResponsive.cs_disclaimer2.includeInLayout=_dataConfig[id];
                }
                if(id=='cs_customDisclaimer'){
                    _formDefault.cs_customDisclaimer.visible=_dataConfig[id].present;
                    _formDefault.cs_customDisclaimer.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formDefault.cs_customDisclaimer.includeInLayout=_dataConfig[id].present;
                    _formDefault.customDisclaimerCheckBox.label=_dataConfig[id].value;

                    _formResponsive.cs_customDisclaimer.visible=_dataConfig[id].present;
                    _formResponsive.cs_customDisclaimer.addEventListener(MouseEvent.CLICK, activeCheckBoxHandler);
                    _formResponsive.cs_customDisclaimer.includeInLayout=_dataConfig[id].present;
                    _formResponsive.customDisclaimerCheckBox.label=_dataConfig[id].value;

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

    private function activeCheckBoxHandler(event:MouseEvent):void {
        _formResponsive.CheckOutButton.enabled= (event.currentTarget as CheckBox).selected
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
    private function NewFieldResponsive(id:String,name:String):Object{
        /***
         <s:VGroup width="50%">
         <s:Label text="Name" width="100%"/>
         <s:TextInput id="id" width="100%" skinClass="skins.SkinTextInputResponsive" />
         </s:VGroup>
         ***/
        var vGroup:VGroup=new VGroup();
        vGroup.percentWidth=50
        var lblInput:Label=new Label();
        lblInput.text=name;
        lblInput.percentWidth=100;
        lblInput.setStyle('fontSize','11');
        lblInput.setStyle('fontWeight','bold');

        var textInput:TextInput=new TextInput();
        textInput.id=id;
        textInput.percentWidth=100;
        textInput.setStyle('skinClass',skins.SkinTextInputResponsive);
        vGroup.addElement(lblInput);
        vGroup.addElement(textInput);
        return {groupItem:vGroup,textInput:textInput};
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
        _formResponsive.expiryInput.expiryInput.addEventListener(KeyboardEvent.KEY_DOWN,changeResponsiveHandler);
        _formResponsive.expiryInput.expiryInput.addEventListener(KeyboardEvent.KEY_UP,changeResponsiveHandler);

        _formResponsive.emailInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
        _formResponsive.addressInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
        _formResponsive.cityInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
        //_formResponsive.stateInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
        _formResponsive.zipInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);


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

        _formDefault.yearInput.addEventListener(IndexChangeEvent.CHANGE,changeDefaultHandler);
       // _formResponsive.yearInput.addEventListener(IndexChangeEvent.CHANGE,changeResponsiveHandler);
    }

    private function MoveScrollHandler(event:FocusEvent):void {
        trace(event.currentTarget);
        var hgroup:HGroup=((event.currentTarget as TextInput).owner as VGroup).owner as HGroup;
        var index:int=hgroup.owner.getChildIndex(hgroup);
        trace(index)
        _app.formResponsiveScroller.viewport.verticalScrollPosition=index*30;
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
        //_formResponsive.monthInput.selectedIndex = _formDefault.monthInput.selectedIndex;
        //_formResponsive.yearInput.selectedIndex =  _formDefault.yearInput.selectedIndex;
    }

    private function changeResponsiveHandler(event:Object):void {
        _cart.cc_expYear=_formResponsive.expiryInput.year;
        _cart.cc_expMonth=_formResponsive.expiryInput.month;
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
        //_formDefault.monthInput.selectedIndex = _formResponsive.monthInput.selectedIndex;
        //_formDefault.yearInput.selectedIndex = _formResponsive.yearInput.selectedIndex;
    }


    public function get titleButton():String {
        return _titleButton;
    }

    public function set titleButton(value:String):void {
        _titleButton = value;
    }
}
}
