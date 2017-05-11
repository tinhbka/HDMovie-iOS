//
//  VHDResponseObject.m
//  BaseProject
//
//  Created by Tinhvv on 8/12/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDResponseObject.h"

@implementation VHDResponseObject
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"e" : @"responseCode",
                                                        @"r" : @"responseData",
                                                        }];
}

+ (VHDResponseObject *)responseObjectWithResponse:(NSHTTPURLResponse*)response
                                responseObject:(id)responseObject
                                         error:(NSError *)error{
    //    NSLog(@"Response: %@ ====> %@",operation.request.URL, operation.responseString);
    VHDResponseObject *obj = nil;
    if (responseObject) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSMutableDictionary *mInfo = [[NSMutableDictionary alloc] initWithDictionary:json];
        id resultData = [mInfo objectForKey:@"data"];
        if (resultData) {
            if ([resultData isKindOfClass:[NSArray class]]) {
                if (!((NSArray *)resultData).count) {
                    resultData = @{};
                    [mInfo setObject:resultData forKey:@"data"];
                }
            }
        }
        
        NSError *parserError = nil;
        obj = [[VHDResponseObject alloc] initWithDictionary:mInfo error:&parserError];
        obj.errorException = error ? error : parserError;
        obj.statusCode = @(response.statusCode);
    }
    return obj;
    
}
@end
