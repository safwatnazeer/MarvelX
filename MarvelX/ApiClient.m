//
//  ApiClient.m
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import "ApiClient.h"
#import <UIKit/UIKit.h>


@implementation ApiClient

-(id) init{

    if (self = [super init])
    {
        self.session = [NSURLSession sharedSession];
    }
    return self;
    
}

-(void) testblock:(void (^)(NSString * _Nullable))myblock {
    
    //[myblock testblock:@"xx"];
    myblock(@"ff");
}

-(NSString *) prepareFullURLString:(NSString*) urlString {
 
    NSString *ts = @"1";
    NSString *publicKey =@"47bd8154ce5ac06f820619a3fe25c62c";
    NSString *privateKey = @"aa464e507ec50ced2c2d362f03ffbb3b8df4c057";
    NSString *hashString = [[NSString alloc] initWithFormat:@"%@%@%@",ts,privateKey,publicKey ];
    NSString *hash = [hashString md5];
    NSString *urlStringPrepared = [[NSString alloc] initWithFormat:@"%@ts=%@&apikey=%@&hash=%@",urlString, ts, publicKey, hash ];
    
    return urlStringPrepared;

}

-(void)downloadJson:(NSString * _Nullable)targetUrlString withCompletionHandler:(void (^ _Nullable) (NSDictionary* _Nullable)) completionHandler
{
    NSString *preparedURLString = [self prepareFullURLString:targetUrlString];
    NSURL *url = [NSURL URLWithString:preparedURLString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != nil ) {
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *) response;
            if (HTTPResponse.statusCode == 200) {
                
                NSData *responseData = [[NSData alloc] initWithContentsOfURL:location];
                if (responseData != nil) {
                    @try {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                        if (dict == nil) NSLog(@"Data could not be converted to json dictionary");
                        else completionHandler(dict);
                    }
                    @catch (NSException *e){
                        NSLog(@"Exception during json serialization: %@", e);
                    }
                
                } else NSLog(@"No data returned");

            } else NSLog(@"HTTP response was not successful, error code:%li" , (long)HTTPResponse.statusCode);
        
        } else NSLog(@"Missing HTTP response");
        
    } ];
    
    [task resume];
}

-(void)downloadImage:(NSString * _Nullable)urlString withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler
{
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != nil ) {
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *) response;
            if (HTTPResponse.statusCode == 200) {
                
                NSData *responseData = [[NSData alloc] initWithContentsOfURL:location];
                if (responseData != nil) {
                    @try {
                        NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
                        UIImage *image = [[UIImage alloc] initWithData:imageData];
                        if (image == nil) NSLog(@"Data could not be converted to image ");
                        else completionHandler(image);
                    }
                    @catch (NSException *e){
                        NSLog(@"Exception during image creation: %@", e);
                    }
                    
                } else NSLog(@"No data returned");
                
            } else NSLog(@"HTTP response was not successful, error code:%li" , (long)HTTPResponse.statusCode);
            
        } else NSLog(@"Missing HTTP response");
        
    }];
    
    [task resume];
}

@end


