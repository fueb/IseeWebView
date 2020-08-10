//
//  BSJSON.h
//  SCWCYClient
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 SunnadaSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//简单的JSON解析器，一般是小型的数组，暂时不支持数组，字典。只支持NSString, int, float,double,boolean,BSJSON, Array<BSJSON>
@interface IseeBSJSON : NSObject


//根据数据初始化BSJSON对象。。
-(instancetype)initWithData:(NSData*)aData encoding:(NSStringEncoding)encoding;


-(IseeBSJSON*)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(IseeBSJSON*)setInt:(NSInteger)anInt forKey:(id<NSCopying>)aKey;
-(IseeBSJSON*)setFloat:(CGFloat)anFloat forKey:(id<NSCopying>)aKey;
-(IseeBSJSON*)setDouble:(double)anDouble forKey:(id<NSCopying>)aKey;
-(IseeBSJSON*)setBoolean:(BOOL)anBool forKey:(id<NSCopying>)aKey;
-(IseeBSJSON*)setNewBoolean:(BOOL)anBool forKey:(id<NSCopying>)aKey;


//取值
-(id)objectForKey:(id<NSCopying>)aKey;

//序列化
-(NSData*)serialization:(NSStringEncoding)encoding;

-(NSString*)serialization;

-(NSString*)serializationHelperNew;

@end
