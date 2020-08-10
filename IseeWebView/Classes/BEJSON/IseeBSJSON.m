//
//  BSJSON.m
//  SCWCYClient
//
//  Created by apple on 14-5-26.
//  Copyright (c) 2014年 SunnadaSoft. All rights reserved.
//

#import "IseeBSJSON.h"

@interface IseeBSJSON ()

@property(nonatomic) NSMutableArray *keys;
@property(nonatomic) NSMutableArray *vals;


//序列化帮助
-(NSString*)serializationHelper;


//键的索引，如果没有则添加
-(NSInteger)keyIndex:(id<NSCopying>)aKey;




@end

@implementation IseeBSJSON

#pragma mark -- Overwritte Method

-(instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _keys = [[NSMutableArray alloc] init];
        _vals = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSString*)description
{
    return [self serializationHelper];
}



#pragma mark -- Public Method

//初始化根据字符串
-(instancetype)initWithString:(NSString*)aString
{
    self = [self init];
    if (self != nil)
    {
        
        //检测{ 表示开始 检查key 保存到_keys中，然后到:以后，如果是" 开头则是字符串，如果是true,false则是boolean,如果是
        //{则是新的json，那么查找到匹配的}并截取放入到一个新的对象中，如果是[则表示是数组，查找到对应的]并把中间部分组合并处理
        //否则就是数字。
        
    }
    
    return self;

}

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    if (self != nil)
    {
        //遍历字典保存到数组中
        for (NSString *key in dict)
        {
            [_keys addObject:key];
            NSObject *objVal = [dict objectForKey:key];
            if ([objVal isKindOfClass:[NSDictionary class]])
            {
                [_vals addObject:[[IseeBSJSON alloc] initWithDictionary:(NSDictionary*)objVal]];
            }
            else if ([objVal isKindOfClass:[NSArray class]])
            {
                //数组里面必须是字典。。。否则无法解释
                NSMutableArray *arrObj = [[NSMutableArray alloc] init];
                
                for (NSDictionary *subDict in (NSArray*)objVal)
                {
                    [arrObj addObject:[[IseeBSJSON alloc] initWithDictionary:subDict]];
                }
                
                [_vals addObject:arrObj];
                
            }
            else
                [_vals addObject:objVal];
        }

        
    }
    
    return self;
}

-(instancetype)initWithData:(NSData*)aData encoding:(NSStringEncoding)encoding
{
    //这里要去除末尾0
    
    id tmp =  [NSJSONSerialization JSONObjectWithData:aData options:0 error:nil];
    
    if ([tmp isKindOfClass:[NSArray class]]) {
        NSLog(@"数组类型");
    }else{
        
    }
    
    NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:aData options:0 error:nil];
    if (dict == nil)
    {
        self = nil;
        return self;
    }
    return [self initWithDictionary:dict];
}

//避免由于anObject == null 导致的崩溃
-(IseeBSJSON*)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == NULL ) {
        NSLog(@"%@ == null",aKey);
        return  self;
    }
    //只支持NSString,NSNumber(int, float, double, boolean), BSJSON
    NSInteger idx = [self keyIndex:aKey];
    [_vals replaceObjectAtIndex:idx withObject:anObject];
    
    return self;
    
}

-(IseeBSJSON*)setInt:(NSInteger)anInt forKey:(id<NSCopying>)aKey
{
    return [self setObject:[NSString stringWithFormat:@"%ld",anInt] forKey:aKey];
}

-(IseeBSJSON*)setFloat:(CGFloat)anFloat forKey:(id<NSCopying>)aKey
{
    return [self setObject:[NSString stringWithFormat:@"%f",anFloat] forKey:aKey];
}

-(IseeBSJSON*)setDouble:(double)anDouble forKey:(id<NSCopying>)aKey
{
    return [self setObject:[NSString stringWithFormat:@"%f",anDouble] forKey:aKey];
}

-(IseeBSJSON*)setBoolean:(BOOL)anBool forKey:(id<NSCopying>)aKey
{
    return [self setObject:[NSString stringWithFormat:@"%d",anBool] forKey:aKey];
}

-(IseeBSJSON*)setNewBoolean:(BOOL)anBool forKey:(id<NSCopying>)aKey
{
    return [self setObject:[NSNumber numberWithInt:anBool] forKey:aKey];
}


-(id)objectForKey:(id<NSCopying>)aKey
{
    NSInteger idx = [_keys indexOfObject:aKey];
    if (idx ==  NSNotFound)
        return nil;
    else
        return [_vals objectAtIndex:idx];

}

-(NSString*)stringForKey:(id<NSCopying>)aKey
{
    return [[self objectForKey:aKey] description];
}


-(NSData*)serialization:(NSStringEncoding)encoding
{
    return [[self serializationHelper] dataUsingEncoding:encoding];
}

-(NSString*)serialization
{
    return [self serializationHelper];
}

#pragma mark -- Private Method

-(NSString*)serializationHelperNew
{
    NSMutableString *result =  [[NSMutableString alloc] init];
    
    [result appendString:@"{"];
    
    //先不考虑包含特殊字符的情况
    for (NSInteger i = 0; i < _keys.count; i++)
    {
        NSString *strKey = [_keys objectAtIndex:i];
        NSObject *objVal = [_vals objectAtIndex:i];
        
        if (i != 0)
            [result appendString:@","];
        
        //[result appendFormat:@"\"%@\":", strKey];
        [result appendFormat:@"\\\"%@\\\":", strKey];
        
        //添加value
        if ([objVal isKindOfClass:[NSString class]])
        {
            [result appendFormat:@"\\\"%@\\\"", (NSString*)objVal];
        }
        else if ([objVal isKindOfClass:[NSNumber class]])
        {
            //如果是boolean型则特殊处理。。。
            NSNumber *num = (NSNumber*)objVal;
            const char *ctype = num.objCType;
            if (*ctype == 'B')
                [result appendFormat:@"%@", num.boolValue ? @"true" : @"false"];
            else
                [result appendFormat:@"%@",objVal];
        }
        else if ([objVal isKindOfClass:[IseeBSJSON class]])
        {
            [result appendString:[((IseeBSJSON*)objVal) serializationHelper]];
        }
        else if ([objVal isKindOfClass:[NSNull class]])
        {
            [result appendString:@"null"];
        }
        else if ([objVal isKindOfClass:[NSArray class]])
        {
            [result appendString:@"["];
            NSArray *arr = (NSArray*)objVal;
            
            for (int j = 0; j < arr.count; j++)
            {
                if (j != 0)
                    [result appendString:@","];
                
                [result appendFormat:@"%@", [arr objectAtIndex:j]];
            }
            
            [result appendString:@"]"];
            
        }
        else
        {
            //崩溃！！
            NSAssert(0, @"error");
        }
    }
    
    [result appendString:@"}"];
    NSLog(@"%@",result);
    return result;
}


-(NSString*)serializationHelper
{
    NSMutableString *result =  [[NSMutableString alloc] init];
    
    [result appendString:@"{"];
    
    //先不考虑包含特殊字符的情况
    for (NSInteger i = 0; i < _keys.count; i++)
    {
        NSString *strKey = [_keys objectAtIndex:i];
        NSObject *objVal = [_vals objectAtIndex:i];
        
        if (i != 0)
            [result appendString:@","];
        
        [result appendFormat:@"\"%@\":", strKey];
        
        //添加value
        if ([objVal isKindOfClass:[NSString class]])
        {
            [result appendFormat:@"\"%@\"", (NSString*)objVal];
        }
        else if ([objVal isKindOfClass:[NSNumber class]])
        {
            //如果是boolean型则特殊处理。。。
            NSNumber *num = (NSNumber*)objVal;
            const char *ctype = num.objCType;
            if (*ctype == 'B')
                [result appendFormat:@"%@", num.boolValue ? @"true" : @"false"];
            else
                [result appendFormat:@"%@",objVal];
        }
        else if ([objVal isKindOfClass:[IseeBSJSON class]])
        {
            [result appendString:[((IseeBSJSON*)objVal) serializationHelper]];
        }
        else if ([objVal isKindOfClass:[NSNull class]])
        {
            [result appendString:@"null"];
        }
        else if ([objVal isKindOfClass:[NSArray class]])
        {
            [result appendString:@"["];
            NSArray *arr = (NSArray*)objVal;
            
            for (int j = 0; j < arr.count; j++)
            {
                if (j != 0)
                    [result appendString:@","];
                
                [result appendFormat:@"%@", [arr objectAtIndex:j]];
            }
            
            [result appendString:@"]"];
            
        }
        else
        {
            //崩溃！！
            NSAssert(0, @"error");
        }
    }
    
    [result appendString:@"}"];
    NSLog(@"%@",result);
    return result;
}


-(NSInteger)keyIndex:(id<NSCopying>)aKey
{
    NSInteger idx = [_keys indexOfObject:aKey];
    if (idx ==  NSNotFound)
    {
        [_keys addObject:aKey];
        [_vals addObject:[NSNull null]];
        idx  = _keys.count - 1;
    }

    return idx;
    
}
@end
