//
//  VHDResponseObject.h
//  BaseProject
//
//  Created by Tinhvv on 8/12/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VHDResponseObject : JSONModel
@property (strong, nonatomic) NSNumber <Ignore> *statusCode;
@property (strong, nonatomic) id <Optional> responseData;
@property (strong, nonatomic) NSError <Ignore>*errorException;
@property (strong, nonatomic) NSNumber <Optional>* responseCode;


+ (VHDResponseObject *)responseObjectWithResponse:(NSHTTPURLResponse*)response
                                responseObject:(id)responseObject
                                         error:(NSError *)error;

@end
