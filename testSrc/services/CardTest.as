/**
 * Created by rein on 5/13/15.
 */
package services {

import flexunit.framework.Assert;

import services.JsonUtil;

public class CardTest {

    [Test(description="it should convert valid hex css colors to flash colors")]
    public function testHexConvertColor():void {
        Assert.assertEquals(' argument "#ffffff" should return "0xffffff" ', '0xffffff', JsonUtil.ConvertColor("#ffffff"));
        Assert.assertEquals(' argument "#fff" should return "0xffffff" ', '0xffffff', JsonUtil.ConvertColor("#fff"));
        Assert.assertEquals(' argument "#gggggg" should return null ', null, JsonUtil.ConvertColor("#gggggg"));
    }

    [Test(description="it should convert valid rgb css colors to flash colors")]
    public function testRGBConvertColor():void {
        Assert.assertEquals(' argument "rgb(255,255,255)" should return "0xffffff" ', '0xffffff', JsonUtil.ConvertColor("rgb(255,255,255)"));
        Assert.assertEquals(' argument "rgb(0,0,0)" should return "0x000000" ', '0x000000', JsonUtil.ConvertColor("rgb(0,0,0)"));
        Assert.assertEquals(' argument "rgb(15,15,15)" should return "0x0f0f0f" ', '0x0f0f0f', JsonUtil.ConvertColor("rgb(15,15,15)"));
        Assert.assertEquals(' argument "foo(1,1,1)" should return null ', null, JsonUtil.ConvertColor("foo(1,1,1)"));
        Assert.assertEquals(' argument "rgb(256,256,256)" should return null ', null, JsonUtil.ConvertColor("rgb(256,256,256)"));
    }

    [Test(description="it should convert valid rgba css colors to object with flash color and alpha")]
    public function testRGBAConvertColor():void {
        Assert.assertEquals(' argument "rgba(255,255,255,0.5)" should return { color:"0xffffff", alpha:0.5 } ', { color:"0xffffff", alpha:0.5 }, JsonUtil.ConvertColor("rgba(255,255,255,0.5)"));
        Assert.assertEquals(' argument "rgba(255,255,255,-2)" should return { color:"0xffffff", alpha:0 } ', { color:"0xffffff", alpha:0 }, JsonUtil.ConvertColor("rgba(255,255,255,-2)"));
        Assert.assertEquals(' argument "rgba(255,255,255,2)" should return { color:"0xffffff", alpha:1 } ', { color:"0xffffff", alpha:1 }, JsonUtil.ConvertColor("rgba(255,255,255,2)"));
        Assert.assertEquals(' argument "rgba(255,255,255)" should return null ', null, JsonUtil.ConvertColor("rgba(255,255,255)"));
    }

}
}
