/**
 * Created by EDINSON on 02/06/2015.
 */
package services {
import flash.events.Event;
import flash.net.URLLoader;

import models.Cart;

import models.Cart;
import models.CartItem;
import models.Video;

import mx.collections.ArrayCollection;

import util.RestService;

public class Cart {
    private var _cart:models.Cart;
    private var _video:Video;
    private var _service:RestService;
    public function Cart(video:models.Video) {
        _video=video;
        _cart=new models.Cart();
        _service = new RestService('carts');
    }
    public function Create(fnCompleted:Function=null):void{
        var params:Object=new Object();
        params.video=_video.id;
        _service.Post(params,function(e:Event):void{
            var loader:URLLoader = URLLoader(e.target);
            var r = JSON.parse(loader.data);
            _cart=new models.Cart();
            _cart.id=r._id;
            _cart.video=r.video;
            _cart.user=r.user;
            _cart.createAt=r.createAt;
            _cart.updatedAt=r.updatedAt;
            _cart.accessToken=r.accessToken;
            if(fnCompleted!=null)
                fnCompleted(_cart);
        })
    }
    public function Update(actions:ArrayCollection,addInfoForm:Boolean=false,fnCompleted:Function=null):void{
        var params:Object=new Object();
        params._id=_cart.id;
        params.createdAt=_cart.createAt;
        params.updatedAt=(new Date()).toString();
        params.video= _video.id;
        params.accessToken = _cart.accessToken;
        params.user = _cart.user;
        params.items=actions;
        params.items=new Array();
        for(var i:int=0;i<actions.length;i++){
            params.items[i]=(actions.getItemAt(i) as CartItem).card.jsonObject;
            params.items[i].quantity=(actions.getItemAt(i) as CartItem).amount;
            params.items[i].product_id=(actions.getItemAt(i) as CartItem).card.product.id;
            params.items[i].action_id=(actions.getItemAt(i) as CartItem).card.id;
            params.items[i].item_id=(actions.getItemAt(i) as CartItem).card.clientUUID;
            params.items[i]._id=params.items[i].product_id;
            delete  params.items[i]['product'];

        }
        if(addInfoForm){
            params.billing_address1=_cart.billing_address1;
            params.billing_city=_cart.billing_city;
            params.billing_firstName="";
            params.billing_lastName="";
            if(_cart.billing_firstName.length>0) {
                params.billing_firstName = _cart.billing_firstName.split(' ')[0];
                if(_cart.billing_firstName.split(' ').length>1)
                    params.billing_lastName=_cart.billing_firstName.split(' ')[1];
            }
            params.billing_state=_cart.billing_state||'';
            params.billing_zip= _cart.billing_zip||'';
            params.cc_cvv= _cart.cc_cvv||'';
            params.cc_expMonth=_cart.cc_expMonth||'';
            params.cc_expYear= _cart.cc_expYear;
            params.cc_number= _cart.cc_number;
            params.createdAt= _cart.createAt;
            params.email= _cart.email;
        }
        _service.Put(_cart.id,params,function(response:Event):void{
            var loader:URLLoader = URLLoader(response.target);
            var data:Object = JSON.parse(loader.data);
            if(fnCompleted!=null){
                fnCompleted();
            }
        });
    }

    public function get cart():models.Cart {
        return _cart;
    }

    public function set cart(value:models.Cart):void {
        _cart = value;
    }
}
}
