//
//  IseeChoicePeopleModel.h
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IseeAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoicePeopleModel : NSObject
@property (nonatomic, strong) NSMutableArray * areaList;
@property (nonatomic, strong) NSMutableArray * areaSelectList;
@property (nonatomic, strong) NSMutableArray * staffList;
@property (nonatomic, strong) IseeAreaModel * defaultArea;
@property (nonatomic, copy) NSString * selectAreaId;
@end

NS_ASSUME_NONNULL_END
