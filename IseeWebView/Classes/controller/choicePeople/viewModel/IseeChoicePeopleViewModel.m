//
//  IseeChoicePeopleViewModel.m
//  IseeWebView
//
//  Created by 余友良 on 2020/10/16.
//  Copyright © 2020 dxzx. All rights reserved.
//

#import "IseeChoicePeopleViewModel.h"
#import "IseeAFNetRequest.h"
#import "IseeChoicePeopleModel.h"
#import "IseePeopleModel.h"
#import "IseeAreaModel.h"
#import "IseePeopleCell.h"
#import "IseeConfig.h"

@interface IseeChoicePeopleViewModel()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
}

@end

@implementation IseeChoicePeopleViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _peopleModel = [IseeChoicePeopleModel new];
        _peopleModel.areaList = [NSMutableArray array];
        _peopleModel.staffList = [NSMutableArray array];
        _peopleModel.areaSelectList = [NSMutableArray array];
    }
    return self;
}

#pragma mark - action
- (void)choiceArea:(UIButton *)btn
{
    if (_peopleModel == NULL || _peopleModel.defaultArea == NULL) {
        return;
    }
    [_peopleModel.areaSelectList removeAllObjects];
    [_peopleModel.areaList removeAllObjects];
    [_peopleModel.areaSelectList addObject:_peopleModel.defaultArea.name];
    [_peopleView.areaSeg setTitles:_peopleModel.areaSelectList];
    [_peopleView.areaSeg setIsShowUnderLine:YES];
    _peopleView.areaSeg.selectIndex = 0;
    _peopleModel.selectAreaId = _peopleModel.defaultArea.ids;
    if (_choiceArea !=NULL) {
        _choiceArea();
    }

}

- (void)areaCancel:(UIButton *)btn
{
    if (_areaCancel !=NULL) {
        _areaCancel();
    }
}

- (void)sureAction:(UIButton *)btn
{
    _peopleView.areaBgView.hidden = YES;
    if (_areaSure !=NULL) {
        _areaSure(_peopleModel.selectAreaId);
    }
}

#pragma mark - request
- (void)isee_findAreaWithParam:(NSMutableDictionary *)param
                     WithSuccess:(void (^)(id result))success
                         failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GETAREA];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
    for (int i = 0; i < keys.count; i++) {
        if(i == 0)
        {
            urlString = [urlString stringByAppendingFormat:@"?%@=%@",keys[i],values[i]];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",keys[i],values[i]];
        }
    }
    __weak typeof(self) wkSelf = self;
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:^(id  _Nonnull result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSArray *data = result[@"data"];
            
            if ([urlString rangeOfString:@"initId"].location != NSNotFound) {
                if (data.count > 0) {
                    NSDictionary *defaultArea = [data firstObject];
                    [wkSelf.peopleView.searchBtn setTitle:defaultArea[@"name"] forState:UIControlStateNormal];
                    IseeAreaModel *model = [[IseeAreaModel alloc]init];
                    model.ids = defaultArea[@"id"];
                    model.name = defaultArea[@"name"];
                    wkSelf.peopleModel.defaultArea = model;
                }
            }
            else
            {

                [wkSelf.peopleModel.areaList removeAllObjects];
                for (int i = 0;i < data.count;i++)
                {
                    NSDictionary *dict = data[i];
                    IseeAreaModel *model = [[IseeAreaModel alloc]init];
                    model.ids = dict[@"id"];
                    model.name = dict[@"name"];
                    [wkSelf.peopleModel.areaList addObject:model];
                    
                }
                
                [wkSelf.peopleView.areaTableView reloadData];
                
                wkSelf.peopleView.areaBgView.hidden = NO;

            }
    
        }
        
        success(result);

    } failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}
- (void)isee_findPeopleWithParam:(NSMutableDictionary *)param
                     WithSuccess:(void (^)(id result))success
                         failure:(void (^)(void))failed
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAINNAME,GETPEOPLE];
    NSArray *keys = param.allKeys;
    NSArray *values = param.allValues;
    
    for (int i = 0; i < keys.count; i++) {
        if(i == 0)
        {
            urlString = [urlString stringByAppendingFormat:@"?%@=%@",keys[i],values[i]];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",keys[i],values[i]];
        }
    }
    __weak typeof(self) wkSelf = self;
    [IseeAFNetRequest requestWithURLString:urlString parameters:param type:RequestTypePost success:^(id  _Nonnull result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 200)
        {
            NSDictionary *data = result[@"data"];
            NSArray *records = data[@"records"];
            
            if (records.count < 15) {
                wkSelf.peopleView.isPullUp_refresh = NO;
            }
            
            for (int i = 0;i < records.count;i++)
            {
                NSDictionary *dict = records[i];
                IseePeopleModel *model = [[IseePeopleModel alloc]init];
                model.latnId = [NSString stringWithFormat:@"%ld",[dict[@"latnId"] longValue]];
                model.areaId = [NSString stringWithFormat:@"%ld",[dict[@"areaId"] longValue]];
                model.staffId = [NSString stringWithFormat:@"%ld",[dict[@"staffId"] longValue]];
                model.managerId = [NSString stringWithFormat:@"%ld",[dict[@"managerId"] longValue]];
                model.staffCode = dict[@"staffCode"];
                model.staffName = dict[@"staffName"];
                if (![dict[@"relaMobile"] isKindOfClass:[NSNull class]]) {
                    model.relaMobile = dict[@"relaMobile"];
                }
                
                [wkSelf.peopleModel.staffList addObject:model];
                
            }
            
        }
        
        success(result);

    } failure:^(id error) {
        //请求失败
        
        NSLog(@"%@", error);
        failed();
    }];
}

#pragma mark - uitextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length <=0) {
        return YES;
    }
    if (_fieldGo != NULL) {
        _fieldGo(textField.text);
    }
    return YES;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return _peopleModel.areaList.count;
    }
    return _peopleModel.staffList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *method;
    if (tableView.tag == 1) {
        IseePeopleModel *tempModel = _peopleModel.staffList[indexPath.row];
        method = tempModel.staffName;
    }
    else
    {
        IseeAreaModel *tempModel = _peopleModel.areaList[indexPath.row];
        method = tempModel.name;
    }
    
    IseePeopleCell *cell = [[IseePeopleCell alloc]init];
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=[IseeConfig stringTOColor:@"#F4F6FB"];
    cell.model     = method;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        IseeAreaModel *tempModel = _peopleModel.areaList[indexPath.row];
        
        [_peopleModel.areaSelectList addObject:tempModel.name];
        [_peopleView.areaSeg setTitles:_peopleModel.areaSelectList];
        [_peopleView.areaSeg setIsShowUnderLine:YES];
        _peopleView.areaSeg.selectIndex = _peopleModel.areaSelectList.count-1;
        
        _peopleModel.selectAreaId = tempModel.ids;
        if (_choiceArea != NULL) {
            _choiceArea();
        }
    }
    else if(tableView.tag == 1)
    {
        IseePeopleModel *tempModel = _peopleModel.staffList[indexPath.row];
        if (_selectPeople!=NULL) {
            _selectPeople(tempModel);
        }
    }
}
@end
