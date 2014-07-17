//
//  AeSdkIOS.m
//  AeSdkIOS
//
//  Created by adelement on 7/16/14.
//  Copyright (c) 2014 adelement. All rights reserved.
//

#import "AeSdkIOS.h"

@implementation AeSdkIOS

-(void)aesdkios:(NSData *)msg{
    NSString *queryString = [NSString stringWithFormat:@"http://192.168.1.103:8090/"];
    NSString *did;
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_0) {
        did =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    }else{
        UIDevice *device = [UIDevice currentDevice];
        did=[[device identifierForVendor]UUIDString];
        
    }
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    NSString *smsg = [[NSString alloc] initWithData:msg encoding:NSUTF8StringEncoding];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    did, @"id",
                                    smsg, @"msg",
                                    nil];
    
    NSLog(@"msgggggg: %@", smsg);
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            //do something with error
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
        }
    }];
}


@end
