//
//  SlideLookupAccountVC.m
//  Blocpad
//
//  Created by hugh
//
//

#import <QuartzCore/QuartzCore.h>
#import "SlideLookupAccountVC.h"
#import "SQLiteDB.h"
#import "SBJson.h"

#import "TraccsContract.h"
#import "VolumeRebateModel.h"
#import "GrowthRebateModel.h"
#import "CCTableViewCell.h"
#import "TraccsAPIClient.h"
#import "Reachability.h"

@interface SlideLookupAccountVC ()

@end

@implementation SlideLookupAccountVC

@synthesize tableData;
@synthesize ccSearchBar;

@synthesize theSearchBar;
@synthesize theTableView;
@synthesize loadingIcon;
@synthesize connection = _connection;

static NSString* kTimestampFormat =  @"Last Updated:\n%@";
static NSString* kASPPriceLookupURL = @"http://cementbloc.s3.amazonaws.com/camcalc/asp-price.js";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.theTableView.hidden = YES;
        selectedIndex = -1;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timestampLabel.hidden = YES;
    //    NSLog(@"%s", __FUNCTION__);
    
    CGRect searchFrame = CGRectMake(230, 104, 544, 44);
    ccSearchBar = [[CCSearchBar alloc] initWithFrame:searchFrame];
    ccSearchBar.delegate = self;
    [self.view addSubview:ccSearchBar];
    
    self.tableData =[[NSMutableArray alloc]init];
    
    if ([DataModel sharedInstance].accountData != nil) {
        NSString *acctName = [[DataModel sharedInstance].accountData objectForKey:@"groupName"];
        ccSearchBar.text = acctName;
        
    }
    
    CurrentContract *contract = [[CurrentContract alloc] init];
    [DataModel sharedInstance].contract = contract;
    [DataModel sharedInstance].contract.aspPrice = 899.91;
    [DataModel sharedInstance].contract.aspMarkup = [DataModel sharedInstance].contract.aspPrice * 1.03;
    
    VolumeRebateModel *volumeModel = [[VolumeRebateModel alloc] init];
    [volumeModel load];
    [DataModel sharedInstance].volumeModel = volumeModel;
    
    GrowthRebateModel *growthModel = [[GrowthRebateModel alloc] init];
    [growthModel load];
    [DataModel sharedInstance].growthModel = growthModel;
    
    
    // http://stackoverflow.com/questions/8307422/double-tap-on-uitableviewcell
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.theTableView addGestureRecognizer:doubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoadingNotificationHandler:)
                                                 name:@"finishLoadingNotification"
                                               object:nil];
    NSLog(@"viewDidLoad: needsLookup = %@", [DataModel sharedInstance].needsLookup ? @"YES" : @"NO");
    ccSearchBar.userInteractionEnabled = NO;

    if ([DataModel sharedInstance].needsLookup == YES) {
        [self startLoadingAnimation];

        // allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.celgclinicrebateservice.com"];

        reach.reachableBlock = ^(Reachability*reach)
        {
            
            TraccsAPIClient *apiClient = [[TraccsAPIClient alloc]init];
            apiClient.testmode = NO;
            [apiClient checkForUpdate];

//            [self performSelector:@selector(refreshData:) withObject:self afterDelay:2];
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            [self stopLoadingAnimation];
        };
        
        // start the notifier which will cause the reachability object to retain itself!
        [reach startNotifier];
    } else {
        [self stopLoadingAnimation];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - Data lookups 

- (void)apiLookupASP
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    double savedPrice = [prefs doubleForKey:@"aspPrice"];
    NSLog(@"Found saved asp price %f", savedPrice);

    
    // NSLog(@"url = %@", urlString);
    
    NSURL *URL = [NSURL URLWithString:kASPPriceLookupURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request setHTTPMethod:@"GET"];

    NSHTTPURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict;
    
    dict = (NSDictionary *) [jsonParser objectWithData:data];;
    BOOL isOk = NO;
    if (dict != nil) {
        NSDictionary *object = [dict objectForKey:@"asp"];
        if (object != nil) {
            NSNumber *nval = (NSNumber *) object;
            aspPrice = nval.doubleValue;
            
            NSLog(@"ASP Price is %f", aspPrice);
            [DataModel sharedInstance].contract.aspPrice = aspPrice;
            [DataModel sharedInstance].contract.aspMarkup = [DataModel sharedInstance].contract.aspPrice * 1.03;
            
            [prefs setDouble:aspPrice forKey:@"aspPrice"];
            isOk = YES;
            
        }
    }
    if (!isOk) {
        if (savedPrice > 1) {
            NSLog(@"Data save not successful. Using default asp");
            [DataModel sharedInstance].contract.aspPrice = savedPrice;
            [DataModel sharedInstance].contract.aspMarkup = [DataModel sharedInstance].contract.aspPrice * 1.03;
            isOk = YES;
        }
    }
    if (!isOk) {
        NSLog(@"Data save not successful. Using default asp");
        [DataModel sharedInstance].contract.aspPrice = 899.91;
        [DataModel sharedInstance].contract.aspMarkup = [DataModel sharedInstance].contract.aspPrice * 1.03;
        
    }

    
}

- (TraccsCalculation *)dbGetCalculation {

    NSString *sql;
    sql = @"select * from calculation;";
    FMResultSet *rs = [[SQLiteDB sharedConnection] executeQuery:sql];
    TraccsCalculation *result;
    
    if ([rs next]) {
        NSDictionary *dict = [rs resultDictionary];
        result = [TraccsCalculation readFromDictionary:dict];
        return result;
    } else {
        NSLog(@">>>>>>>>>>>>> No data in calculation query!");
    }
    return nil;
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
    NSLog(@"json=%@", responseString);
    
    
    if ([responseString rangeOfString:@"Exception" options:NSCaseInsensitiveSearch].length>0)
    {
        NSLog(@"Connection failed");
        return;
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

#pragma mark - Notification
//
- (void)finishLoadingNotificationHandler:(NSNotification*)notification
{
    NSLog(@"%s", __FUNCTION__);
    [DataModel sharedInstance].needsLookup = NO;
    [self apiLookupASP];
    
    [self stopLoadingAnimation];
}

-(void) startLoadingAnimation
{
    NSLog(@"%s", __FUNCTION__);
    ccSearchBar.userInteractionEnabled = NO;
    self.timestampLabel.hidden = NO;
    self.timestampLabel.text = @"Updating...";
    
    CABasicAnimation *rotation;
    loadingIcon.hidden = NO;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI * -1)];
    rotation.duration = 1.1; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [loadingIcon.layer addAnimation:rotation forKey:@"Spin"];
    
}

-(void) stopLoadingAnimation
{
    NSLog(@"%s", __FUNCTION__);
    
    ccSearchBar.userInteractionEnabled = YES;
    
    [loadingIcon.layer removeAllAnimations];
    loadingIcon.hidden = YES;

    NSDateFormatter *longDateFormatter = [[NSDateFormatter alloc] init];
    [longDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [longDateFormatter setTimeStyle:NSDateFormatterNoStyle];

    TraccsCalculation *calculation = [self dbGetCalculation];
    NSString *dateText = calculation.calculationDate;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy"];
    NSDate *calcDate = [dateFormat dateFromString:dateText];
    NSString *longDate = [longDateFormatter stringFromDate:calcDate];
    
    NSString *dateLabel = [NSString stringWithFormat:kTimestampFormat, longDate];
    [DataModel sharedInstance].timestampText = dateLabel;
    
    self.timestampLabel.text = [DataModel sharedInstance].timestampText;
    self.timestampLabel.hidden = NO;
    
//    [DataModel sharedInstance].contract.aspPrice = calculation.vialPrice;
//    [DataModel sharedInstance].contract.aspMarkup = [DataModel sharedInstance].contract.aspPrice * 1.03;

}


#pragma mark - Tap Gestures

-(void)doubleTap:(UISwipeGestureRecognizer*)tap
{
    NSLog(@"%s", __FUNCTION__);
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        
        NSDictionary *rowData = (NSDictionary *) [tableData objectAtIndex:selectedIndex];
        [DataModel sharedInstance].accountData = rowData.mutableCopy;
        TraccsContract *traccsContract = [TraccsContract readFromDictionary:rowData];
        [DataModel sharedInstance].traccsContract = traccsContract;
        NSLog(@"Setting contractId %i", traccsContract.contractId);
        [DataModel sharedInstance].contractId = traccsContract.contractId;
        
        [_delegate gotoNextSlide];
    }
}
#pragma mark - UISearchBar
/*
 SOURCE: http://jduff.github.com/2010/03/01/building-a-searchview-with-uisearchbar-and-uitableview/
 */

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [ccSearchBar setShowsCancelButton:NO animated:YES];
    
    self.theTableView.allowsSelection = YES;
    self.theTableView.scrollEnabled = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.theTableView.hidden = NO;
    [self performSearch:searchText];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __FUNCTION__);
    ccSearchBar.text=@"";
    [DataModel sharedInstance].accountData = nil;
    
    //    [searchBar setShowsCancelButton:NO animated:YES];
    //    [searchBar resignFirstResponder];
    //    self.theTableView.allowsSelection = YES;
    //    self.theTableView.scrollEnabled = YES;
    
    self.theTableView.hidden = YES;
    selectedIndex = -1;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar {
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    NSLog(@"search text=%@", _searchBar.text);
    
    [self performSearch:_searchBar.text];
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // http://stackoverflow.com/questions/413993/loading-a-reusable-uitableviewcell-from-a-nib
    
    static NSString *CellIdentifier = @"CCTableCell";
    static NSString *CellNib = @"CCTableViewCell";
    
    CCTableViewCell *cell = (CCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    @try {
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
            cell = (CCTableViewCell *)[nib objectAtIndex:0];
        }
        
        NSDictionary *rowData = (NSDictionary *) [tableData objectAtIndex:indexPath.row];
        TraccsContract *traccsContract = [TraccsContract readFromDictionary:rowData];
        cell.rowdata = traccsContract;
        
    } @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUGX
    NSLog(@"%s", __FUNCTION__);
#endif
    
    @try {
        if (indexPath != nil) {
            NSLog(@"Selected row %i", indexPath.row);
            selectedIndex = indexPath.row;
            
            [ccSearchBar resignFirstResponder];
            
        }
    } @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
}


- (void)performSearch:(NSString *)searchText
{
    NSLog(@"%s: %@", __FUNCTION__, searchText);
    
    if (searchText.length > 0) {
        NSString *sqlTemplate = @"select * from contract where search_text like '%%%@%%' limit 20";
        
        isLoading = YES;
        
        NSString *sql = [NSString stringWithFormat:sqlTemplate, searchText];
        
        FMResultSet *rs = [[SQLiteDB sharedConnection] executeQuery:sql];
        [tableData removeAllObjects];
        
        while ([rs next]) {
            [tableData addObject:[rs resultDictionary]];
        }
        isLoading = NO;
        
        [self.theTableView reloadData];
        
    } else {
        self.theTableView.hidden = YES;
        
        selectedIndex = -1;
        [DataModel sharedInstance].accountData = nil;
    }
    
    
}


#pragma mark - IBActions
- (IBAction)previousSlide
{
    [_delegate gotoPreviousSlide];
}


- (IBAction)nextSlide
{
    NSLog(@"%s", __FUNCTION__);
    if ([DataModel sharedInstance].accountData != nil) {
        [_delegate gotoNextSlide];
    } else if (selectedIndex > -1) {
        NSLog(@"selectedIndex = %i", selectedIndex);
        NSDictionary *rowData = (NSDictionary *) [tableData objectAtIndex:selectedIndex];
        [DataModel sharedInstance].accountData = rowData.mutableCopy;
        TraccsContract *traccsContract = [TraccsContract readFromDictionary:rowData];
        [DataModel sharedInstance].traccsContract = traccsContract;
        NSLog(@"Setting contractId %i", traccsContract.contractId);
        [DataModel sharedInstance].contractId = traccsContract.contractId;
        
        [_delegate gotoNextSlide];
    }
}


@end
