//
//  SeaHttpInterface.h

//

//网络定义的数据
#ifndef Sea_SeaHttpInterface_h
#define Sea_SeaHttpInterface_h

///网络不好请求失败提示信息
static NSString *const SeaAlertMsgWhenBadNetwork = @"网络状态不佳，";

///网络请求方法
static NSString *const SeaHttpRequestMethodPost = @"POST";

//http请求失败错误码
typedef NS_ENUM(NSInteger, SeaHttpErrorCode)
{
    ///没有错误
    SeaHttpErrorCodeNoError = 0,
    
    ///api错误
    SeaHttpErrorCodeApiError = 1,
};


#endif
