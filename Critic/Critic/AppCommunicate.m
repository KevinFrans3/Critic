//
//  AppCommunicate.m
//  Critic
//
//  Created by Tolga Beser on 7/19/15.
//  Copyright (c) 2015 Tolga Beser. All rights reserved.
//

#import "AppCommunicate.h"
#import <OAuthConsumer.h>

@implementation AppCommunicate

-(NSDictionary *)getFoodPlaces:(NSString *)url {
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"" secret:@""];
    OAToken *token = [[OAToken alloc] initWithKey:@"" secret:@""];
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    NSURL *URL = [NSURL URLWithString:url];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request setHTTPMethod:@"GET"];
    [request prepare];
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSDictionary *retrievedData = [NSJSONSerialization JSONObjectWithData:result
                                                                  options:0
                                                                    error:NULL];
    return retrievedData;
}
@end
