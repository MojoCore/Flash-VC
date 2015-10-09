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
import models.Video;

import mx.collections.ArrayCollection;

import mx.collections.ArrayCollection;

import mx.containers.ViewStack;
import mx.controls.Alert;
import mx.controls.Text;
import mx.events.ValidationResultEvent;
import mx.validators.StringValidator;
import mx.validators.Validator;


import skins.SkinTextInput;

import spark.components.CheckBox;


import spark.components.FormItem;
import spark.components.HGroup;
import spark.components.Label;
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
    static private const UITYPE_PROPERTY_TEXT="text";
    static private const UITYPE_PROPERTY_TERM="term";
    static private const  exclusionsForm:Array  = ["cs_buttonText",'cs_includeIcon','cs_customDisclaimer','cs_disclaimer2','cs_disclaimer1','cs_business_type'];
    private var fields:ArrayCollection;
    private var _states:ArrayCollection;
    private var _years:ArrayCollection;
    private var _months:ArrayCollection;
    private var _titleButton:String;
    private var _video:models.Video;
    private var _language:String="en"
    private var _validatorArr:Array;
    public function ConfigurationForm(app:Object,video:Video,cart:models.Cart,formDefault:CheckoutDefaultBox=null,formResponsive:CheckoutResponsiveBox=null) {
        _app=app;
        _video=video;
        _user=video.user;
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
        _validatorArr=new Array();

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
    private function initNewDataConfig(){
        var obj:Object=new Object();
        /*obj={
                required:['phonenumber','employer','occupation'],
                properties:{
                    phonenumber:{
                        uitype:'text',
                        label:{
                            en:'Phone Number',
                            es:'Teléfono'
                        },
                        priority:1
                    },
                    employer:{
                        uitype:'text',
                        label:{
                            en:'Employer',
                            es:'Empleador'
                        },
                        priority:2
                    },
                    corporation:{
                        uitype:'text',
                        label:{
                            en:'Corporation',
                            es:'Empresa'
                        },
                        priority:3
                    },
                    occupation:{
                        uitype:'text',
                        label:{
                            en:'Occupation',
                            es:'Ocupación'
                        },
                        priority:4
                    },
                    disclaimer1:{
                        uitype:'term',
                        label:{
                            en:'By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.',
                            es:'Termino de Aceptación 1'
                        },
                        priority:1
                    },
                    disclaimer2:{
                        uitype:'term',
                        label:{
                            en:'Term 2',
                            es:'Termino de Aceptación 2'
                        },
                        priority:2
                    }
                },
            button:{
                text:"Contribute",
                bgcolor:"#41abe7",
                color:"white"
            },
            disclaimers:{
                0:{
                    label:{
                        en:'Press {{button_text}} for replace in {{user_company}} and press other {{button_text}}. By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.'
                    }
                },
                1:{
                    label:{
                        en:'By checking this box, I certify that I am a US citizen over the age of 18, and that this contribution is from my own personal funds and not from a corporation or a political action committee.'
                    }
                }
            }

        }
        _video.formConfig=obj;*/
        _dataConfig= _video.formConfig;
    }
    public function Configure(fn:Function=null):void{
        LoadConfiguration(fn);
    }
    private function AddStaticInputValidation():void{
        _dataConfig.required.push("cc_number");
        _dataConfig.required.push("cc_cvv");
        _dataConfig.required.push("cc_expiry");
        _dataConfig.required.push("cc_name");
        _dataConfig.required.push("cc_email");
        _dataConfig.required.push("cc_address");
        _dataConfig.required.push("cc_city");
        _dataConfig.required.push("cc_state");
        _dataConfig.required.push("cc_zip");
        ConfigValidation("cc_number","Card Number",_formResponsive.cardnumberInput);
        ConfigValidation("cc_cvv","CVV",_formResponsive.cvvInput);
        ConfigValidation("cc_expiry","MM/YY",_formResponsive.expiryInput.expiryInput);
        ConfigValidation("cc_name","Name",_formResponsive.nameInput);
        ConfigValidation("cc_email","Email",_formResponsive.emailInput);
        ConfigValidation("cc_address","Address",_formResponsive.addressInput);
        ConfigValidation("cc_city","City",_formResponsive.cityInput);
        ConfigValidation("cc_state","State",_formResponsive.stateInput.textInput);
        ConfigValidation("cc_zip","ZIP",_formResponsive.zipInput);
    }
    public function LoadConfiguration(fn:Function=null){
        _formResponsive.stateInput.dataProvider=_states;
        _formDefault.stateInput.dataProvider=_states;
        _formDefault.monthInput.dataProvider=_months;
        _formDefault.yearInput.dataProvider=_years;
        _service.Get(_user+'?getSettings=1',function(event:Event):void{
            var loader:URLLoader=URLLoader(event.target);
            _dataConfig=JSON.parse(loader.data);

            //ConfigureForm();
            initNewDataConfig();
            AddStaticInputValidation();
            NewConfigureForm();

            if(fn!=null){
                fn();
            }
        });

    }

    public function NewConfigureForm():void{
        ConfigAnimation();
        AddListeners();
        ConfigButton();
        ConfigProperties();
        ConfigTerms();
        ConfigDisclaimers();

    }
    private function ConfigButton():void{
        if(_dataConfig.button){
            var bgColor:String=_dataConfig.button.bgcolor;
            //Alert.show(_dataConfig.button.bgcolor)
            if(_dataConfig.button.bgcolor=="orange"){
                bgColor='#ffa100';
            }
            if(_dataConfig.button.bgcolor=="blue"){
                bgColor='#3da8ee';
            }

            _titleButton=_dataConfig.button.text;
            _formResponsive.CheckOutButton.label=_dataConfig.button.text;
            _formDefault.CheckOutButton.label=_dataConfig.button.text;

            _formResponsive.CheckOutButton.setStyle("color",bgColor);
            _formResponsive.CheckOutButton.setStyle("accentColor",_dataConfig.button.color);

            _formDefault.CheckOutButton.setStyle("color",bgColor);
            _formDefault.CheckOutButton.setStyle("accentColor",_dataConfig.button.color);

            var nameTab:String=''

            if(_video.campaign_type=="product"){
                nameTab='CHECKOUT';
            }else{
                nameTab='CONTRIBUTE';
            }
            _app.btnTabCheckout.title=nameTab;
        }

    }
    private function ConfigProperties():void{
        var countFields:int=1;//custom fields init after address
        var _existFormItem:Boolean=true;
        var formItem:FormItem;
        var formItemResponsive:HGroup;
        var key:String;
        var total:int=0;
        var i:int=0;
        var positionForm:int=3;
        var addHeight:int=0;
        var heightRowProperties:int=30;
        var properties:ArrayCollection=new ArrayCollection();

        for (var id:String in _dataConfig.properties){

            if(_dataConfig.properties[id].uitype!=UITYPE_PROPERTY_TERM){
                properties.addItem({key:id,order: _dataConfig.properties[id].priority});
                total++;
            }

        }
        JsonUtil.arrayCollectionSort(properties,'order',true);

        formItem = _formDefault.finishStaticFieldItems;
        formItemResponsive=_formResponsive.finishStaticFieldItems;
        if(_dataConfig.hasOwnProperty("properties")){
            for(var index:int=0;index<total;index++){
                key=properties.getItemAt(index).key;
                i++;
                addHeight += heightRowProperties;
                countFields++;
                if(!_existFormItem) {
                    formItem = NewFormItem();
                    formItemResponsive = NewFormItemResponsive();
                    _existFormItem = true;
                }
                var textInput:TextInput = NewField(key,_dataConfig.properties[key].label[_language]);
                var textInputR:Object = NewFieldResponsive(key,_dataConfig.properties[key].label[_language]);


                textInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicDefaultHandler);
                textInput.addEventListener(KeyboardEvent.KEY_UP,changeDynamicDefaultHandler);
                textInputR.textInput.addEventListener(KeyboardEvent.KEY_DOWN,changeDynamicResponsiveHandler);
                textInputR.textInput.addEventListener(KeyboardEvent.KEY_UP,changeDynamicResponsiveHandler);
                textInputR.textInput.addEventListener(FocusEvent.FOCUS_IN, MoveScrollHandler);
                _dataConfig.properties[key].field={
                    input:textInput,
                    inputResponsive:textInputR.textInput
                };

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
            if (countFields >0) {
                _formDefault.CheckOutForm.addElementAt(formItem, positionForm);
                _formResponsive.CheckOutForm.addElementAt(formItemResponsive, positionForm);

            }
            (_app.CheckoutViewStack as ViewStack).height=_formDefault.height+addHeight;
            (_app.CheckoutViewStack as ViewStack).y=-(_formDefault.height+addHeight);

        }


    }
    private function ConfigTerms():void{
        var key:String;
        var total:int=0;
        var terms:ArrayCollection=new ArrayCollection();
        var container:VGroup=_formResponsive.ContainerTerms;
        for (var id:String in _dataConfig.properties){

            if(_dataConfig.properties[id].uitype==UITYPE_PROPERTY_TERM){
                terms.addItem({key:id,order: _dataConfig.properties[id].priority});
                total++;
            }

        }
        JsonUtil.arrayCollectionSort(terms,'order',true);
        if(_dataConfig.hasOwnProperty("properties")) {
            for (var index:int = 0; index < total; index++) {
                key=terms.getItemAt(index).key;
                var termCompomnent:HGroup=NewTerm(key,_dataConfig.properties[key].label[_language]);
                container.addElement(termCompomnent);
            }
        }
    }
    private function ConfigDisclaimers():void{
        var total:int=0;
        var key:String;
        var container:VGroup=_formResponsive.ContainerDisclaimers;

        var disclaimers:ArrayCollection=new ArrayCollection();
        for (var id:String in _dataConfig.disclaimers){
            total++;
            disclaimers.addItem({key:id,order: Number(id)});
        }
        JsonUtil.arrayCollectionSort(disclaimers,'order',true);

        if(_dataConfig.hasOwnProperty("disclaimers")){
            for (var id:String in _dataConfig.disclaimers){
                var text:String=_dataConfig.disclaimers[id].label[_language];
                if(_dataConfig.disclaimers[id].boxed){
                    _formResponsive.DisclaimerBoxed.htmlText=text;
                    _formResponsive.containerBoxDisclaimer.visible=true;
                }else{
                    var disclaimer=NewDisclaimer(text);
                    container.addElement(disclaimer);

                }


        }
        }
    }
    private function ReplaceAllExpressions(text:String):String {
        var expressions:Array=['user_company','button_text'];
        var obj:Object={
            user_company:'My Company',
            button_text: 'ButtonName'
        };

        for(var i:int=0;i<expressions.length;i++){
            text=ReplaceText(expressions[i],text,obj[expressions[i]]);
        }
        return text;
    }

    private function ReplaceText(tagName:String,text:String,value:String):String{
        //var rxStr:String = '/\{\{"+tagName+"\}\}/g';
        var start:RegExp=/{{/
        var end:RegExp=/}}/
        var regex:RegExp = new RegExp(start.source+tagName+end.source,"g");
        trace(regex.toString());
        text = text.replace(regex,value);
        return text;
    }

    private var validators:ArrayCollection=new ArrayCollection();
    private function ConfigValidation(id:String,name:String,input:TextInput):void{
        var validator:StringValidator;
        var disclaimers:ArrayCollection=new ArrayCollection();
        for (var i:int=0;i<_dataConfig.required.length;i++){
            if(id==_dataConfig.required[i]){
                validator=new StringValidator();
                validator.requiredFieldError=name+" is required!";
                validator.required=true;
                validator.property='text';
                validator.triggerEvent="focusOut";
                validator.source=input;
                validators.addItem(validator);

            }

        }
        _validatorArr.push(validator);
        JsonUtil.arrayCollectionSort(disclaimers,'order',true);
    }

    public function validateForm():Boolean {
        var validatorErrorArray:Array = Validator.validateAll(_validatorArr);;
        var isValidForm:Boolean = validatorErrorArray.length == 0;
        if (isValidForm) {
            return true;
        } else {
            var err:ValidationResultEvent;
            var errorMessageArray:Array = [];
            for each (err in validatorErrorArray) {
                errorMessageArray.push(err.message);
            }
            Alert.show(errorMessageArray.join("\n"), "Invalid form...", Alert.OK);
        }
        return false;
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
        lblInput.setStyle('fontSize','13');

        var textInput:TextInput=new TextInput();
        textInput.id=id;
        textInput.percentWidth=100;
        textInput.setStyle('skinClass',skins.SkinTextInputResponsive);
        vGroup.addElement(lblInput);
        vGroup.addElement(textInput);

        ConfigValidation(id,name,textInput);
        return {groupItem:vGroup,textInput:textInput};
    }
    private function NewDisclaimer(description:String):Text{
        var disclaimer:Text=new Text();
        disclaimer.percentWidth=100;
        disclaimer.setStyle('fontSize','10');
        disclaimer.setStyle('paddingTop','5');
        disclaimer.setStyle('color','#666666');
        disclaimer.setStyle('textAlign','justify');
        disclaimer.htmlText=description;
        return disclaimer;
    }

    private function NewTerm(id:String,description:String):HGroup{
        var group:HGroup=new HGroup();
        var check:CheckBox=new CheckBox();
        var label:Label=new Label();

        group.percentWidth=100;
        check.id=id;
        check.selected=false;
        label.text=description;
        label.percentWidth=100;
        label.setStyle('fontSize','10');
        label.setStyle('paddingTop','5');
        label.setStyle('color','#666666');
        label.setStyle('textAlign','justify');
        group.addElement(check);
        group.addElement(label);
        check.addEventListener(Event.CHANGE,changeDynamicTermResponsiveHandler )
       return group;

    }

    private function changeDynamicTermResponsiveHandler(event:Event):void {
        var input:CheckBox=(event.currentTarget as CheckBox);
        _cart.customProperties[input.id]=input.selected;
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
        _app.formResponsiveScroller.viewport.verticalScrollPosition=index*50;
    }
    private function changeDynamicDefaultHandler(event:KeyboardEvent):void{

        /*var input:TextInput=(event.currentTarget as TextInput);
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
        }*/
    }
    private function changeDynamicResponsiveHandler(event:KeyboardEvent):void{
        var input:TextInput=(event.currentTarget as TextInput);
        _cart.customProperties[input.id]=input.text;

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

    public function get language():String {
        return _language;
    }

    public function set language(value:String):void {
        _language = value;
    }
}
}
