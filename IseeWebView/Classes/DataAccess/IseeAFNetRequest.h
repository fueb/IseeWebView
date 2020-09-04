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
#define SSOLOGINURL         @"/loginInfo/devLogin/ssoLogin"
#define LOGINURL            @"/loginInfo/devLogin/rollBackToSuperAdministrator"
#define HOMEMENU            @"/custInfoApp/api/toolConfig/getToolList"
#define MYTASK              @"/custInfoApp/api/indexCustomerManager/getMyTask"
#define QUERYSENDORDER      @"/custInfoApp/api/sendOrder/querySendOrderAllInfos"
#define KEYPOINT            @"/custInfoApp/api/indexCustomerManager/getKeyPoint"
#define CUSTOMLOST            @"/custInfoApp/api/customLostControlMain/getManagerCustomLost"
#define MYBULE              @"/custInfoApp/api/blueOcean/getBlueCustMsg"
#define FINDCUST            @"/custInfoApp/api/indexManager/findCust"
#define FINDCRM             @"/custInfoApp/api/indexManager/getCrmCustList"
#define FINDVIP             @"/custInfoApp/api//indexManager/findVip"
#define FINDPROD            @"/custInfoApp/api/indexManager/findProd"
#define FINDPRODUCT         @"/custInfoApp/api/indexManager/findProduct"
#define FINDBLUEOCEAN       @"/indexManager/findBlueOcean"
#define GETDEALCOUNT        @"/custInfoApp/api/jobDeal/getDealCount"
//weburl
//走访任务
#define VISITLISTWEBURL     @"/visitList"
//欠费催缴
#define WORKORDERWEBURL     @"/workOrderReminder/Index"
//电路到期
#define CIRCUITWEBURL                  @"/workOrderReminder/circuitExpiration"
//宽带到期
#define BROADBANDWEBURL                    @"/workOrderReminder/broadbandExpiration"

//我的
#define MYWEBURL        @"/mine"
//消息
#define MESSAGEWEBURL   @"/message"
//工具
#define TOOLWEBURL      @"/tools"
//沙盘
#define SANDTABLE       @"/sandTable/Index"

//客户流失管理
#define FLUWEBURL       @"/customerFluctuation"

//装维工单
#define InstallationWorkorderWEBURL      @"/tools/InstallationWorkorder"
//套餐使用量查询
#define packageUsageWEBURL               @"/tools/packageUsage"
//套餐使用量详情
#define packageUsageDetailWEBURL      @"/tools/packageUsage/packageUsageDetail"
//套餐优惠查询
#define packageOfferWEBURL           @"/tools/packageOffer"
//客户积分查询
#define customerPointsWEBURL         @"/tools/customerPoints"
//虚拟网信息
#define vpnInformationWEBURL         @"/tools/vpnInformation"
//客户账单
#define customerBillWEBURL           @"/tools/customerBill"
//消费余额
#define customerOverageWEBURL        @"/tools/customerOverage"
//用户欠费
#define customerArrearsWEBURL        @"/tools/customerArrears"
//电子发票
#define invoiceQueryWEBURL           @"/tools/invoiceQuery"
//缴费日志
#define paymentLogWEBURL             @"/tools/paymentLog"
//联系人管理
#define contactManagementWEBURL      @"/contactManagement/Index"
//综合查询
#define integratedQueryWEBURL        @"/integratedQuery/Index"
//政企视图
#define enterpriseNewViewWEBURL      @"/enterpriseNewView/Index"
//crm视图
#define CRMCUSTViewWEBURL            @"/crmCustView/Index"
//蓝海视图
#define BLUEViewWEBURL               @"/blueOceanClientView"
//故障单
#define MALFUCTIONQUERYWEBURL        @"/crmCustView/malfuctionQuery"
//投诉单查询
#define COMPLAINTQUERYWEBURL         @"/crmCustView/complaintQuery"
//订单查询
#define ORDERQUERYWEBURL             @"/tools/orderQuery"
//资产查询
#define ASSETSQUERYWEBURL            @"/tools/clientAssetsQuery"
@end
