//
//  BillModel.h
//  EPay
//
//  Created by strong on 17/5/12.
//  Copyright © 2017年 strong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IseeCustModel : NSObject
@property (nonatomic,copy) NSString *id_type_name;
@property (nonatomic,copy) NSString *orderid;
@property (nonatomic,copy) NSString *latn_id;
@property (nonatomic,copy) NSString *social_code;
@property (nonatomic,copy) NSString *ser_name;
@property (nonatomic,copy) NSString *ser_id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *ser_addr;
@property (nonatomic,copy) NSString *areaIdFj;
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *areaIdCb;
@property (nonatomic,copy) NSString *areaNameZj;
@property (nonatomic,copy) NSString *areaIdBdw;
@property (nonatomic,copy) NSString *areaNameCb;
@property (nonatomic,copy) NSString *areaIdZj;
@property (nonatomic,copy) NSString *areaNameBdw;
@property (nonatomic,copy) NSString *areaNameFj;

@property (nonatomic,copy) NSString *latName;



-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
