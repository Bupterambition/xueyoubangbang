//
//  JsonToModel.m
//  Json2ModelDemo
//
//  Created by Cailiang on 14-7-24.
//  Copyright (c) 2014年 Home. All rights reserved.
//

#import "JsonToModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, JsonToModelDataType)
{
    JsonToModelDataTypeObject    = 0,
    JsonToModelDataTypeBOOL      = 1,
    JsonToModelDataTypeInteger   = 2,
    JsonToModelDataTypeFloat     = 3,
    JsonToModelDataTypeDouble    = 4,
    JsonToModelDataTypeLong      = 5,
};

@implementation JsonToModel

+ (NSDictionary *)dictionaryFromObject:(id)object
{
    if (object == nil) {
        return nil;
    }
    
    NSMutableDictionary *propertyAndValues = [[NSMutableDictionary alloc] init];
    
    @try {
        NSString *className = NSStringFromClass([object class]);
        id classObject = objc_getClass([className UTF8String]);
        
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(classObject, &count);
        
        for (int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id propertyValue = nil;
            id valueObject = [object valueForKey:propertyName];
            if ([valueObject isKindOfClass:[NSDictionary class]])
            {
                propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
            } else if ([valueObject isKindOfClass:[NSArray class]])
            {
                propertyValue = [NSArray arrayWithArray:valueObject];
            } else
            {
                propertyValue = [NSString stringWithFormat:@"%@",[object valueForKey:propertyName]];
            }
            
            [propertyAndValues setObject:propertyValue forKey:propertyName];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return [propertyAndValues copy];
    }
}

+ (NSArray *)propertiesFromObject:(id)object
{
    if (object == nil) {
        return nil;
    }
    
    NSMutableArray *propertiesArray = [[NSMutableArray alloc] init];
    
    @try {
        NSString *className = NSStringFromClass([object class]);
        id classObject = objc_getClass([className UTF8String]);
        
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(classObject, &count);
        
        for (int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            [propertiesArray addObject:propertyName];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return [propertiesArray copy];
    }
}

+ (id)objectFromDictionary:(NSDictionary *)dictionary className:(NSString *)name
{
    if (dictionary == nil || name == nil || name.length == 0) {
        return nil;
    }
    
    id object = [[NSClassFromString(name) alloc]init];
    
    @try {
        id classObject = objc_getClass([name UTF8String]);
        
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(classObject, &count);
        Ivar * ivars = class_copyIvarList(classObject, nil);
        
        for (int i = 0; i < count; i ++)
        {
            NSString *memberName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            const char *type = ivar_getTypeEncoding(ivars[i]);
            NSString *dataType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
            
//            NSLog(@"Data %@ type: %@",memberName,dataType);
            
            JsonToModelDataType rtype = JsonToModelDataTypeObject;
            if ([dataType hasPrefix:@"c"])
            {
                // BOOL
                rtype = JsonToModelDataTypeBOOL;
            } else if ([dataType hasPrefix:@"i"])
            {
                // int
                rtype = JsonToModelDataTypeInteger;
            } else if ([dataType hasPrefix:@"f"])
            {
                // float
                rtype = JsonToModelDataTypeFloat;
            } else if ([dataType hasPrefix:@"d"])
            {
                // double
                rtype = JsonToModelDataTypeDouble;
            } else if ([dataType hasPrefix:@"l"])
            {
                // long
                rtype = JsonToModelDataTypeLong;
            }
            
            for (int j = 0; j < count; j ++)
            {
                objc_property_t property = properties[j];
                NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                NSRange range = [memberName rangeOfString:propertyName];
                if (range.location == NSNotFound) {
                    continue;
                } else {
                    if ([propertyName isEqualToString:@"class_type"]) {
                        NSLog(@"%@",[dictionary objectForKey:propertyName]);
                    }
                    id propertyValue = [dictionary objectForKey:propertyName];
                    
                    switch (rtype) {
                        case JsonToModelDataTypeBOOL:
                        {
                            BOOL temp = [[NSString stringWithFormat:@"%@",propertyValue] boolValue];
                            propertyValue = [NSNumber numberWithBool:temp];
                        }
                            break;
                        case JsonToModelDataTypeInteger:
                        {
                            int temp = [[NSString stringWithFormat:@"%@",propertyValue] intValue];
                            propertyValue = [NSNumber numberWithInt:temp];
                        }
                            break;
                        case JsonToModelDataTypeFloat:
                        {
                            float temp = [[NSString stringWithFormat:@"%@",propertyValue] floatValue];
                            propertyValue = [NSNumber numberWithFloat:temp];
                        }
                            break;
                        case JsonToModelDataTypeDouble:
                        {
                            double temp = [[NSString stringWithFormat:@"%@",propertyValue] doubleValue];
                            propertyValue = [NSNumber numberWithDouble:temp];
                        }
                            break;
                        case JsonToModelDataTypeLong:
                        {
                            long long temp = [[NSString stringWithFormat:@"%@",propertyValue] longLongValue];
                            propertyValue = [NSNumber numberWithLongLong:temp];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    [object setValue:propertyValue forKey:memberName];
                    
                    break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }@finally {
        return object;
    }
}

@end
