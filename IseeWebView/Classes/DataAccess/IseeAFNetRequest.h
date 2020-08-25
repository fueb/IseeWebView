//
//  AFNetRequest.h
//  FXYIM
//
//  Created by strong on 17/3/1.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger,RequestType) {
    /**
     *  get请求
     */
    RequestTypeGet = 0,
    /**
     *  post请求
     */
    RequestTypePost
};

@interface IseeAFNetRequest : NSObject
@property (nonatomic,strong)NSURLSessionDataTask *requestTask;
+ (void)showHUD:(UIView *)view;
+ (void)removeHUD;
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(RequestType)type
                     success:(void (^)(id result))success
                     failure:(void (^)(id error))failure;

//验证验证码URL（获取验证码后面拼接?phone=@phone@&app_id=CP2016012&check_exists=true"）let URL_STRING = "http://app.yypt.dcorepay.com/app/" //正式domain name
/*
 let URL_ALI_PAY = "\(URL_STRING)aliPay.action"; //支付宝条码/声波支付
 let URL_ALI_PRECATE = "\(URL_STRING)aliPrecreate.action"; //支付宝交易预创建
 let URL_ALI_ORDER_QUERY = "\(URL_STRING)orderQuery.action";//支付宝订单查询
 let URL_ALI_REFUND = "\(URL_STRING)alirefund.action";      //支付宝退款
 let URL_ALI_REFUND_QUERY = "\(URL_STRING)refundQuery.action";
 let URL_ALI_REVERSE = "\(URL_STRING)reverse.action";
 let URL_ALI_QUERY_ORDER_BY_STATUS = "\(URL_STRING)queryOrderByStatus.action";
 let URL_ALI_CANCELORDER = "\(URL_STRING)aliCancelOrder.action";     //撤销支付宝订单
 */

#define DOMAINNAME @"http://115.233.6.88:9090"       //域名
#define WEBHOST     @"http://115.233.6.88:9090/custInfoApp"

#define isText NO

//数据url

#define LOGINURL            @"/loginInfo/devLogin/rollBackToSuperAdministrator"
#define HOMEMENU            @"/custInfoApp/api/toolConfig/getToolList"
#define MYTASK              @"/custInfoApp/api/indexCustomerManager/getMyTask"
#define QUERYSENDORDER      @"/custInfoApp/api/sendOrder/querySendOrderAllInfos"
#define KEYPOINT            @"/custInfoApp/api/indexCustomerManager/getKeyPoint"
#define CUSTOMLOST            @"/custInfoApp/api/customLostControlMain/getManagerCustomLost"
#define MYBULE              @"/custInfoApp/api/blueOcean/getBlueCustMsg"
#define FINDCUST            @"/custInfoApp/api/indexManager/findCust"
#define FINDPROD            @"/custInfoApp/api/indexManager/findProd"
#define FINDPRODUCT         @"/custInfoApp/api/indexManager/findProduct"
//weburl

#define VISITLISTWEBURL     @"/visitList"

#define MYWEBURL        @"/mine"
#define MESSAGEWEBURL   @"/message"
#define TOOLWEBURL      @"/tools"

#define InstallationWorkorderWEBURL      @"/tools/InstallationWorkorder"
#define packageUsageWEBURL               @"/tools/packageUsage"
#define packageUsageDetailWEBURL      @"/tools/packageUsage/packageUsageDetail"
#define packageOfferWEBURL           @"/tools/packageOffer"
#define customerPointsWEBURL         @"/tools/customerPoints"
#define vpnInformationWEBURL         @"/tools/vpnInformation"
#define customerBillWEBURL           @"/tools/customerBill"
#define customerOverageWEBURL        @"/tools/customerOverage"
#define customerArrearsWEBURL        @"/tools/customerArrears"
#define invoiceQueryWEBURL           @"/tools/invoiceQuery"
#define paymentLogWEBURL             @"/tools/paymentLog"
#define contactManagementWEBURL      @"/contactManagement/Index"
#define integratedQueryWEBURL      @"/integratedQuery/Index"
#define enterpriseNewViewWEBURL      @"/enterpriseNewView/income"
@end
