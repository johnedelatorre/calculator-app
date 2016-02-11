//
//  SlideLookupAccountVC.h
//  Blocpad
//
//  Created by hugh
//
//

#import "SlideViewController.h"
#import "CCSearchBar.h"
#import "HelveticaNeueRomanLabel.h"
#import "TraccsCalculation.h"

@interface SlideLookupAccountVC : SlideViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate> {
    NSMutableArray *tableData;
    
    UITableView *theTableView;
    UISearchBar *theSearchBar;
    CCSearchBar *ccSearchBar;

    BOOL isLoading;
    int selectedIndex;
    double aspPrice;
    
    NSMutableData *responseData;
    NSURLConnection *connection;

}

@property(retain) NSMutableArray *tableData;

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;

@property (nonatomic, retain) IBOutlet UIImageView *loadingIcon;

@property (nonatomic, strong) IBOutlet HelveticaNeueRomanLabel *timestampLabel;

@property (nonatomic, retain) CCSearchBar *ccSearchBar;

@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@property (nonatomic,retain) NSMutableData *connectionData;
@property (nonatomic,retain) NSURLConnection *connection;

- (IBAction)previousSlide;
- (IBAction)nextSlide;
- (void)performSearch:(NSString *)searchText;

-(void) startLoadingAnimation;
-(void) stopLoadingAnimation;
- (void)apiLookupASP;
- (TraccsCalculation *)dbGetCalculation;
//- (NSString *)dbLookupASP;

@end
