#import "WebServiceClass.h"
#import "SBJson.h"

@implementation WebServiceClass

- (id)init
{
    self = [super init];
    return self;
}

-(NSData *)callWebService:(NSString *)stringRequest
{
    NSLog(@"%s", __FUNCTION__);
    
    userName = @"thebloc8"; // Assign the userName here
    passWord = @"b5x4$c2!"; // Assign the password here
        
    NSString *Credentials = [NSString stringWithFormat:@"Basic %@:%@",userName,passWord];
    
    NSData *result = [self callWebServer:stringRequest UserData:Credentials];
    return result;
}

-(NSData *)callWebServer:(NSString *)stringRequest UserData:(NSString *)userCredentials
{
    NSLog(@"%s", __FUNCTION__);
    NSString *soapMessage = [NSString stringWithFormat:@
                             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                             "<SOAP-ENV:Envelope \n"
                             "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                             "xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" \n"
                             "xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\" \n"
                             "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                             "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                             "<SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"];
    
    NSString *urlString= [NSString stringWithFormat:@"%@%@",kCRMUrlRequest,stringRequest];
    NSLog(@"url=%@", urlString);
    
    NSURL *url=[NSURL URLWithString:urlString];//encoding:STRING_ENCODING_IN_THE_SERVER
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue:@"1.0" forHTTPHeaderField:@"DataServiceVersion"];
    [theRequest addValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
    [theRequest addValue:@"2.0" forHTTPHeaderField:@"MaxDataServiceVersion"];
    [theRequest addValue:userCredentials forHTTPHeaderField:@"Authorization"]; 
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    return data;
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
////    NSError *error = nil;
//    NSDictionary *dict;
//
////    id jsonObject = [jsonParser objectWithData:data];
//    
//    dict = (NSDictionary *) [jsonParser objectWithData:data];;
//
//    if (dict != nil) {
//        NSLog(@"dict = %@", dict);
//        NSDictionary *object = [dict objectForKey:@"d"];
//        if (object != nil) {
//            NSLog(@"object = %@", object);
//        }
//    }
//    
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
//
//    return jsonString;
//
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s", __FUNCTION__);
	[responseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s", __FUNCTION__);
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __FUNCTION__);
    
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"url=%@", responseString);

    
    if ([responseString rangeOfString:@"Exception" options:NSCaseInsensitiveSearch].length>0)
    {
        NSLog(@"Connection failed");
        return;
    }
    
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
    
//	  [self callWebService:@"TraccsServiceGetContractsByCalculationId?calcID=117&$format=json"];
//    [self callWebService:@"TraccsServiceGetRebateHistory?&$format=json"];
//    [self callWebService:@"TraccsServiceGetVialHistoryByCalculationId?calcID=117&$format=json"];
//    [self callWebService:@"TraccsServiceGetCurrentCalculationId?calcID=117&$format=json"];
//    [self callWebService:@"TraccsServiceGetCalculation?$format=json"];

}

-(void)dealloc
{
}
@end
