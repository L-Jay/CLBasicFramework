#CLBasicFramework

#####CLBasicFramework API <https://l-jay.github.io/CLBasicFramework/CLBasicFramework%20API/index.html>


##CLNetwork
* 
```
[CLNetwork registerNetWorkWithBasicUrl:@"http://xxx.xxx.com/" constValue:@{@"uerId":@"id"}];
```
	* BasicUrl为项目接口的host url
	* constValue为每个请求接口都需要发送的参数，如用户的id，token等
			
	
	可以使用以下接口进行增删参数：	

  ```
  [CLNetwork addValueInConstValue:@{@"key":@"value"}];
  [CLNetwork removeValueInConstValue:@"key"];
  ```
  
  
* 

	```
	[CLNetwork registerNetWorkWithResultKeyAndSuccessValue:@{@"code":@"200"} 		messageKey:@"message" error:^(NSError *error) {
        switch (error.code) {
            case 301:
                //do something
                break;
            case 302:
                //do something
                break;
            case 400:
                //do something
                break;
            case 404:
                //do something
                break;
                
            default:
                break;
        }
    }];
	```    
	
	* ResultKey状态码的key，来获取状态码的值，可以为nil，每个接口返回的数据会多一个CLStatusCode参数，此参数返回的是接口请求NSHTTPURLResponse statusCode
	* messageKey获取接口请求结果详细描述
	* 每个请求结果如果有error，都会回调此接口，一些通用的报错可以在这统一处理，如链接超时,无法链接服务器,用户名密码错误等
	

* 	

	```
	[CLNetwork postRequestWithTypeUrl:@"login"
                         keyAndValues:@{@"username":@"name", @"password":@"123456"}
                              withTag:@"login"
                        requestResult:^(id object, NSError *error) {
                            if (error) {
                                switch (error.code) {
                                    case 201:
                                        //do something
                                        break;
                                        
                                    default:
                                        break;
                                }
                            }else {
                                NSArray *array = object;
                                // or
                                NSDictionary *dictionary = object;
                                
                                // do something
                            }
                        }];
	```
	
	* TypeUrl为请求的短连接，如登录，获取个人资料等
	* keyAndValues以字典传入
	* tag请求标签，根据这个tag可以取消请求，请求进度，上传进度
	* 返回结果object经过json解析后的id类型，NAArray、NSDictionary、NSString，如果解析失败，返回NSData，可进行二次解析或其他处理
	

* 
	```
	[CLNetwork getRequestWithUrl:@"http://xxx.xxx.com?key=value"
                         withTag:@"SomeTag"
                   requestResult:^(id object, NSError *error) {
                       if (error) {
                           switch (error.code) {
                               case 201:
                                   //do something
                                   break;
                                   
                               default:
                                   break;
                           }
                       }else {
                           NSArray *array = object;
                           // or
                           NSDictionary *dictionary = object;
                           
                           // do something
                       }
                   }];
	```
	与post请求类似，更多get请求请参考文档 <https://l-jay.github.io/CLBasicFramework/CLBasicFramework%20API/Classes/CLNetwork.html>                   
	
* 

	```
	[CLNetwork cancelRequestWithTag:@"SomeTag"];
    [CLNetwork cancelAllRequest];
	```
	取消请求
	
	
	
##CLHUD
* 
```
[CLHUD registerSucceedImage:@"successImageName" failImage:@"failImageName"];
```
 设置正确提示的图片，错误提示的图片

* 
```
[CLHUD registerBackgroundImage:@"backgroundImageName"];
```
设置hud的背景图片

* 
```
[CLHUD showActivityView];
    [CLHUD showActivityViewWithText:@"请求中"];
    [CLHUD showSucceed];
    [CLHUD showSucceedWithText:@"请求完成"];
    [CLHUD showFailed];
    [CLHUD showFailedWithText:@"请求失败"];
    [CLHUD showText:@"some text"];
    [CLHUD showImage:@"ImageName"];
```
在window上显示hud

* 
```
	[CLHUD showActivityViewInView:view];
    [CLHUD showActivityViewInView:view withText:@"请求中"];
    [view.hud showSucceed];
    [view.hud showSucceedWithText:@"请求完成"];
    [view.hud showFailed];
    [view.hud showFailedWithText:@"请求失败"];
    [view.hud showText:@"some text"];
    [view.hud showImage:@"ImageName"];
```
在view上显示hud，在view上正在显示的hud可通过view.hud直接获取hud对象

* 
```
	[CLHUD hideAnimation:YES];
    [CLHUD hideComplete:^{
        // do something
    }];
    
    [self.view.hud hideAnimation:YES];
    [self.view.hud hideComplete:^{
        // do something
    }];
```
隐藏hud
* 更多方法 <https://l-jay.github.io/CLBasicFramework/CLBasicFramework%20API/Classes/CLHUD.html>

##UIImageView(CLNetWork) Category

```
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.dontShowActivityView = YES; //是否显示activityView
    imgView.onlyWIFI = YES; //是否是在wifi下下载
    imgView.image = [UIImage imageNamed:@"defaultImage"];
    imgView.imageUrl = @"http://xxx.xxx.com/xxx.jpg";
```
UIImageView扩展，异步下载图片，给imageUrl传入图片地址，更多属性、方法 <https://l-jay.github.io/CLBasicFramework/CLBasicFramework%20API/Categories/UIImageView+CLNetWork.html>

##更多功能
<https://l-jay.github.io/CLBasicFramework/CLBasicFramework%20API/index.html>
