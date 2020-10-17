//
//  IseeChoicePeopleViewModel.h
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IseeChoicePeopleModel.h"
#import "IseeChoicePeopleView.h"
#import "IseePeopleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IseeChoicePeopleViewModel : NSObject
{
    
}
@property (nonatomic, strong) IseeChoicePeopleModel *peopleModel;
@property (nonatomic, strong) IseeChoicePeopleView *peopleView;
- (instancetype)initWithView:(IseeChoicePeopleView *)iseeChoicePeopleV;
- (void)isee_findAreaWithParam:(NSMutableDictionary *)param
                   WithSuccess:(void (^)(id result))success
                       failure:(void (^)(void))failed;
- (void)isee_findPeopleWithParam:(NSMutableDictionary *)param
                     WithSuccess:(void (^)(id result))success
                         failure:(void (^)(void))failed;

@property (nonatomic, strong) void(^fieldGo)(NSString *text);
@property (nonatomic, strong) void(^areaCancel)(void);
@property (nonatomic, strong) void(^areaSure)(NSString *ids);
@property (nonatomic, strong) void(^choiceArea)(void);
//选择人员
@property (nonatomic, strong) void(^selectPeople)(IseePeopleModel *people);

@property (nonatomic, strong) void(^showDefaultArea)(NSString *defaultArea);

- (void)choiceArea:(UIButton *)btn;
- (void)areaCancel:(UIButton *)btn;
- (void)sureAction:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
