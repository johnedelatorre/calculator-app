//
//  TraccsWebService.h
//  Blocpad
//
//  Created by Hugh Lang on 4/16/13.
//
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#define kCRMUrlRequest @"https://www.celgclinicrebateservice.com/TRACCSService.svc/"

@interface TraccsWebService : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *responseData;
    NSURLConnection  *_connection;
    NSString *userName;
    NSString *passWord;
}
-(NSData *)callWebService:(NSString *)stringRequest;

@end


