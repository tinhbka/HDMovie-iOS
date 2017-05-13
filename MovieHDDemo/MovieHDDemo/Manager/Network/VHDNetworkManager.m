//
//  VHDNetworkManager.m
//  BaseProject
//
//  Created by Tinhvv on 8/12/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDNetworkManager.h"
#import "VHDGlobal.h"
#import "StringDefine.h"

@implementation VHDNetworkManager

+ (instancetype)sharedService {
    static VHDNetworkManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[VHDNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:K_SERVER_URL]];
        
    });
    
    return _sharedClient;
}


- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // Add missing accept content types
        if (![self.responseSerializer.acceptableContentTypes containsObject:@"text/html"]) {
            NSMutableSet *acceptableTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
            [acceptableTypes addObject:@"text/html"];
            [self.responseSerializer setAcceptableContentTypes:acceptableTypes];
        }
        
        // Add missing accept content types
        if (![self.responseSerializer.acceptableContentTypes containsObject:@"application/xml"]) {
            NSMutableSet *acceptableTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
            [acceptableTypes addObject:@"application/xml"];
            [self.responseSerializer setAcceptableContentTypes:acceptableTypes];
        }
        
        if (![self.responseSerializer.acceptableContentTypes containsObject:@"text/plain"]) {
            NSMutableSet *acceptableTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
            [acceptableTypes addObject:@"text/plain"];
            [self.responseSerializer setAcceptableContentTypes:acceptableTypes];
        }
        
        if (![self.responseSerializer.acceptableContentTypes containsObject:@"application/json"]) {
            NSMutableSet *acceptableTypes = [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
            [acceptableTypes addObject:@"application/json"];
            [self.responseSerializer setAcceptableContentTypes:acceptableTypes];
        }
        
        
    }
    
    
    return self;
}


#pragma mark - Base functions

- (NSURLSessionDataTask *)callWebserviceWithPath:(NSString *)path
                                          method:(NSString *)method
                                      parameters:(NSDictionary *)parameters
                                      completion:(void (^) (VHDResponseObject *responseObject))completion {
    
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters path:path];
    
    if (request) {
        NSURLSessionDataTask* task = [self dataTaskWithRequest:request completion:completion];
        [task resume];
        
        return task;
    }
    return nil;
}

- (void)callWebserviceWithPath:(NSString *)path
                        method:(NSString *)method
                    parameters:(NSDictionary *)parameters
                     filesData:(NSArray *)filesData
                     fileNames:(NSArray *)fileNames
          fileDescriptionNames:(NSArray *)descriptionNames
                    completion:(void (^) (VHDResponseObject *responseObject))completion {
    
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters path:path filesData:filesData fileNames:fileNames fileDescriptionNames:descriptionNames];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    DLog(@"%@-%@",path,parameters);
    if (request) {
        NSURLSessionDataTask* task = [self dataTaskWithRequest:request completion:completion];
        [task resume];
    }
    else {
        completion(nil);
    }
}

- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest *)request completion:(void (^) (VHDResponseObject *responseObject))completion {
    return [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        VHDResponseObject* responseObj = [VHDResponseObject responseObjectWithResponse:(NSHTTPURLResponse*)response responseObject:responseObject error:error];
        
        if (completion) {
            completion(responseObj);
        }
    }];
}

/**
 Create request for special method, parameters and path
 @param method The HTTP method for the request
 @param parameters The parameters that will be include to the request
 @param path The url for the request
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSDictionary *)parameters
                                      path:(NSString *)path {
    // 1
    NSError *error;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                                  parameters:parameters
                                                                       error:&error];
    
    
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method parameters:(NSDictionary *)parameters path:(NSString *)path filesData:(NSArray *)filesData fileNames:(NSArray *)fileNames fileDescriptionNames:(NSArray *)descriptionNames {
    // 1
    NSError *error;
    NSMutableURLRequest *request = nil;
    
    if (filesData != nil) { // Request with data file
        if (filesData.count != fileNames.count || fileNames.count != descriptionNames.count || descriptionNames.count != filesData.count) {
            return nil;
        }
        request = [self.requestSerializer multipartFormRequestWithMethod:method
                                                               URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                              parameters:parameters
                                               constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
                                                   for (int i = 0; i < filesData.count; i++) {
                                                       [formData appendPartWithFileData:[filesData objectAtIndex:i]
                                                                                   name:[fileNames objectAtIndex:i]
                                                                               fileName:[descriptionNames objectAtIndex:i]
                                                                               mimeType:@"image/jpeg"];
                                                   }
                                               }
                                                                   error:&error];
    }
    else { // Normal request
        [self.requestSerializer requestWithMethod:method
                                        URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                       parameters:parameters
                                            error:&error];
    }
    
    
    return request;
}


#pragma mark - Auth
- (NSURLSessionDataTask *) resgisterWithEmail:(NSString *)loginId
                   password:(NSString *)password
                   nickname:(NSString *)nickName
                      email:(NSString *)email
                    comment:(NSString *)comment
                 completion:(VHDResponseBlock)completion{
    NSDictionary *params = @{
                             kUserName:loginId,
                             kPassword: password,
                             kNickName:nickName,
                             kEmail: email,
                             kComment: comment,
                             };
    
    return [self callWebserviceWithPath:kPathRegister method:kPOST parameters:params completion:completion];
}


- (NSURLSessionDataTask *)loginWithEmail:(NSString *)userName
              password:(NSString *)password
            completion:(VHDResponseBlock)completion{
    
    NSDictionary *params = @{kUserName:userName,
                             kPassword:password,
                             kSandboxMode:@SANDBOX_MODE
                             };
    return [self callWebserviceWithPath:kPathLogin method:kPOST parameters:params completion:completion];
}

- (void)getDataForHomeWithCompletion:(VHDResponseBlock)completion{
    NSString *params = [NSString stringWithFormat:@"%@%@", kPathGetHome, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

- (void) getListCategoriesWithCompletion:(VHDResponseBlock) completion{
    NSString *params = [NSString stringWithFormat:@"%@%@", kPathGetListCategory, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

- (void) getDetailForMovie:(NSString *)movieID ep:(NSString *)ep completion:(VHDResponseBlock) completion{
    NSString *params = [NSString stringWithFormat:@"movie?movieid=%@&ep=%@&sequence=0&accesstoken=null&%@", movieID, ep, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

- (void) getLinkPlayForMovie:(NSString *)movieID ep:(NSString *)ep completion:(VHDResponseBlock) completion{
    NSString *params = [NSString stringWithFormat:@"movie/play?movieid=%@&ep=%@&sequence=0&accesstoken=null&%@", movieID, ep, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

- (void) getListMovieForCategory:(NSString *)categoryID offset:(NSString *)offset completion:(VHDResponseBlock) completion{
    NSString *params = [NSString stringWithFormat:@"movie/?categoryId=%@&key=phim&%@", categoryID, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

- (void) searchWithKey:(NSString *)key completion:(VHDResponseBlock) completion{
    NSString *params = [NSString stringWithFormat:@"movie/search/?key=%@&%@", key, kSign];
    [self callWebserviceWithPath:params method:kGET parameters:nil completion:completion];
}

@end
