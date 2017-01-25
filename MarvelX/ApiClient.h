//
//  ApiClient.h
//  MarvelX
//
//  Created by Safwat Shenouda on 22/01/2017.
//  Copyright © 2017 Safwat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+md5.h"
#import <UIKit/UIKit.h>

@interface ApiClient : NSObject

@property (nonnull,nonatomic) NSURLSession *session;

-(void)downloadJson:(NSString * _Nullable)urlString withCompletionHandler:(void (^ _Nullable) (NSDictionary* _Nullable)) completionHandler ;

-(void)downloadImage:(NSString * _Nullable)urlString withCompletionHandler:(void (^ _Nullable) (UIImage* _Nullable)) completionHandler;
//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

-(void) testblock: (void (^ _Nullable )(NSString* _Nullable)) myblock;
@end
