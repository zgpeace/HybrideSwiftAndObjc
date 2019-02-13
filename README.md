# 混编Swift类和Objc类
语言: swift, 版本：4.2，XCode：10.1<br>
写作时间：2019-02-13
# 说明
Swift与Objective-C混编。笔者记录新建Swift Project，然后Swift调用Objc，最后Objc调用Swift。
新建Swift Project > HybrideSwiftAndObjc

# 1.增加Objc类
> 新建Objc类 CustomObject

弹出提示框， 增加 **Bridging Header**， 选择 **Create Bridging Header**.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190212191409690.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3pncGVhY2U=,size_16,color_FFFFFF,t_70)
系统创建一个头文件 **<#YourProjectName#>-Bridging-Header.h** ，本项目自动创建的头文件为 **HybrideSwiftAndObjc-Bridging-Header.h**. 如果选错了，或者误删掉头文件，可以新建上面规则的头文件，添加到TARGETS > Build Settings > Swift Compiler - General > Objective_C Bridging Header.

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190212192241838.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3pncGVhY2U=,size_16,color_FFFFFF,t_70)
项目不仅创建了Objc的头文件，同时创建了Swift的头文件，文件名格式**<#YourProjectName#>-Swift.h** , 在这里文件名为 **HybrideSwiftAndObjc-Swift.h**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190212192826400.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3pncGVhY2U=,size_16,color_FFFFFF,t_70)

> CustomObject.h
```swift
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomObject : NSObject

@property (strong, nonatomic) id someProperty;

- (void)someMethod;

@end

NS_ASSUME_NONNULL_END

```

> CustomObject.m

```swift
#import "CustomObject.h"

@implementation CustomObject

- (void)someMethod {
    NSLog(@"SomeMethod Run");
}

@end

```
# 引入Objc类头文件到Bridging-Header
swift类如何识别Objc类，就在于引入头文件，放到Bridging-Header，也就是文件> **YourProject-Bridging-Header.h** 。在下面头文件，引入被代用的Objc头文件。
>HybrideSwiftAndObjc-Bridging-Header.h
```swift
#import "CustomObject.h"

```
# 验证swift对象调用Objc对象
> APPDelegate.swift  新增方法
```swift
func swiftCallObjc() {
    let instanceOfCustomObject: CustomObject = CustomObject()
    instanceOfCustomObject.someProperty = "Hello World"
    print(instanceOfCustomObject.someProperty)
    instanceOfCustomObject.someMethod()
}

```
> 修改方法 didFinishLaunchingWithOptions
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    swiftCallObjc()
    
    return true
}

```
运行验证成功，控制台打印如下：
```shell
Hello World
2019-02-13 09:32:15.775243+0800 HybrideSwiftAndObjc[20391:1761308] 
SomeMethod Run

```
注意：这里APPDelegate.swift类不需要引入头文件CustomObject.h， 这就是bridging header的作用。
# Objc调用Swift
> 新建类MySwiftObject.swift
```swift
import Foundation

class MySwiftObject : NSObject {
    
    @objc var someProperty: String = "Some Initializer Val"
    
    override init() {}
    
    @objc func someFunction(someArg:AnyObject) -> String {
        let returnVal = "You sent me \(someArg)"
        return returnVal
    }
}

```
注意： Swift类中默认的属性，方法在Objc类中都是不可见的。在Swift类的属性、方法加修饰符 **@objc** 使其在Objc类中可见。 如果在Swift类中所有属性、方法在Objc类可以见，只要在Swift类的前面加上 **@objc** 即可。
类似如下：
```swift
@objc class MySwiftObject : NSObject 

```
>在Objc类中引入Swift文件

在Objc类CustomObject.m 中引入`#import "<#YourProjectName#>-Swift.h"` , 这里引入的名字如下。

```swift
#import "HybrideSwiftAndObjc-Swift.h"

```
注意： 在任何Objc类引入swift文件，都是引入上面相同的头文件。
>在Objc类中调用Swift类， 在CustomObject.m新增方法
```swift
- (void)objcCallSwift {
    MySwiftObject *myOb = [MySwiftObject new];
    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
    myOb.someProperty = @"Hello World";
    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
    
    // xcode10 expands the external arg here
    NSString * retString = [myOb someFunctionWithSomeArg:@"Arg"];
    
    NSLog(@"RetString: %@", retString);
}

```
注意：XCode10中调用方法，方法名需要拼接上参数名。
>CustomObject.h增加方法，使其为公用方法
```swift
- (void)objcCallSwift;

```
>在APPDelegate的方法swiftCallObjc()的最后增加代码
```swift
instanceOfCustomObject.objcCallSwift()

```
运行验证成功，控制台打印日志如下：
```shell
2019-02-13 09:52:47.134502+0800 HybrideSwiftAndObjc[20829:1803946] 
MyOb.someProperty: Some Initializer Val
2019-02-13 09:52:47.134812+0800 HybrideSwiftAndObjc[20829:1803946] 
MyOb.someProperty: Hello World
2019-02-13 09:52:47.135648+0800 HybrideSwiftAndObjc[20829:1803946]
RetString: You sent me Arg

```
# 总结
恭喜你，成功iOS混编Swift类和Objc类！
代码下载：
https://github.com/zgpeace/HybrideSwiftAndObjc

# 参考
https://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift
