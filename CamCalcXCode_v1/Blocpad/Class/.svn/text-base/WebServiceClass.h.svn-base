#import <Foundation/Foundation.h>

#define kCRMUrlRequest @"https://www.celgclinicrebateservice.com/TRACCSService.svc/"

@interface WebServiceClass : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *responseData;
    NSURLConnection  *_connection;
    NSString *userName;
    NSString *passWord;
}
-(NSData *)callWebService:(NSString *)stringRequest;

@end
