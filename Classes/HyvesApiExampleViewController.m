//
//  HyvesApiExampleViewController.m
//  HyvesApiExample
//
//  Created by Hyves on 3/2/11.
//  Copyright (c) 2011 Hyves
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
//  EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
//  THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "HyvesApiExampleViewController.h"
#import "AuthRequestTokenAPICallHandler.h"
#import "NSDictionary+HyvesApi.h"
#import "HyvesAPICall.h"
#import "HyvesAPILayer.h"
#import "AuthorizationViewController.h"
#import "GetUserAPICallHandler.h"
#import "GetScrapsAPICallHandler.h"
#import "LogoutAPICallHandler.h"

@interface HyvesApiExampleViewController (Private)

-(void)retrieveUserData;

@end



@implementation HyvesApiExampleViewController
@synthesize oauthToken;
@synthesize oauthTokenSecret;
@synthesize tableView;
@synthesize accessToken;
@synthesize accessTokenSecret;
@synthesize expirationDate;
@synthesize userId;
@synthesize loggedInUserName;
@synthesize lastScrapBody;
@synthesize lastScrapSenderName;


#pragma mark -
#pragma mark Table View



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"AuthorizationInfoCellIdentifier";
    
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    switch (indexPath.row) 
    {
        case 0:
            cell.textLabel.text = @"Token";
            cell.detailTextLabel.text = accessToken;
            break;
        case 1:
            cell.textLabel.text = @"Secret";
            cell.detailTextLabel.text = accessTokenSecret;
            break;
        case 2:
            cell.textLabel.text = @"User ID";
            cell.detailTextLabel.text = userId;
            break;
        case 3:
            cell.textLabel.text = @"Expiration Date";
            cell.detailTextLabel.text = [expirationDate description];
            break;
        case 4:
            cell.textLabel.text = @"Display Name";
            cell.detailTextLabel.text = loggedInUserName;
            break;
        case 5:
            cell.textLabel.text = @"Last Scrap";
            cell.detailTextLabel.text = lastScrapBody;
            break;
        case 6:
            cell.textLabel.text = @"Scrap Sender";
            cell.detailTextLabel.text = lastScrapSenderName;
            break;
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark Actions

-(void)retrieveUserData
{
    // Retrieve logged in user data
    getUserApiCallHandler = [[GetUserAPICallHandler alloc] initWithUserIds:nil delegate:self];
    
    [getUserApiCallHandler execute];
}

-(void)logoutPressed:(id)aSender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;    
    
    [logoutApiCallHandler cancel];
    [logoutApiCallHandler release];
    
    logoutApiCallHandler = [[LogoutAPICallHandler alloc] initWithDelegate:self];
    [logoutApiCallHandler execute];
}

-(void)loginPressed:(id)aSender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.oauthToken = nil;
    self.oauthTokenSecret = nil;
    self.accessToken = nil;
    self.accessTokenSecret = nil;
    
    self.userId = nil;
    self.expirationDate = nil;
    
    NSMutableArray* methods = [NSMutableArray arrayWithCapacity:10];
    
    // Specify supported API methods here
    
    [methods addObject:@"users.get"];
    [methods addObject:@"users.getByUsername"];
    [methods addObject:@"users.getLoggedin"];
    [methods addObject:@"scraps.get"];
    [methods addObject:@"batch.process"];
    [methods addObject:@"media.get"];
    [methods addObject:@"users.getScraps"];
    [methods addObject:@"hubs.getScraps"];

    authorizationViewController = [[AuthorizationViewController alloc] initWithDelegate:self methods:methods];
    authorizationViewController.navigationItem.title = @"Authorization with Hyves";
    
    UINavigationController* tempNavigationController = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];
    
    [self presentModalViewController:tempNavigationController animated:YES];
    [tempNavigationController release];
}


#pragma mark -
#pragma mark View Handling

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    loginItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginPressed:)];
    logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutPressed:)];
    
    accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    accessTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenSecret"];
    userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
    
    /*
    if (accessToken != nil && accessTokenSecret != nil)
    {
        self.navigationItem.rightBarButtonItem = logoutItem;
        NSLog(@"Existing access token/secret found in user defaults.");
        
        [HyvesAPILayer sharedHyvesAPILayer].accessToken = accessToken;
        [HyvesAPILayer sharedHyvesAPILayer].accessTokenSecret = accessTokenSecret;
        
        self.navigationItem.title = @"Logged In";
        
        // No authentication needed.
        // Can retrieve user data right away.
        [self retrieveUserData];
    }
    else */
    {
        self.navigationItem.title = @"Logged Out";
        
        self.navigationItem.rightBarButtonItem = loginItem;
    }

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
 {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

// Called during low memory conditions and explicitly, from dealloc, if the view was loaded.
- (void)viewDidUnload 
{
    [authorizationViewController release];
    authorizationViewController = nil;
    
    [oauthToken release];
    oauthToken = nil;
    
    [oauthTokenSecret release];
    oauthTokenSecret = nil;
    
    self.accessToken = nil;
    self.accessTokenSecret = nil;
    
    self.userId = nil;
    self.expirationDate = nil;
    self.lastScrapBody = nil;
    self.lastScrapSenderName = nil;
    
    [tableView release];
    tableView = nil;
    
    [getUserApiCallHandler release];
    getUserApiCallHandler = nil;
    
    [logoutApiCallHandler release];
    logoutApiCallHandler = nil;
    
    [loginItem release];
    loginItem = nil;
    
    [logoutItem release];
    logoutItem = nil;
}    



- (void)dealloc 
{
    if (self.isViewLoaded)
    {
        //viewDidUnload is not called in a normal situation
        [self viewDidUnload];
    }
    
    
    [super dealloc];
}

#pragma mark -
#pragma mark HyvesAPIResponse

-(void)authorizationFailed
{
    [self dismissModalViewControllerAnimated:YES];
    
    [authorizationViewController release];
    authorizationViewController = nil;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.accessToken = nil;
    self.accessTokenSecret = nil;
    self.userId = nil;
    self.expirationDate = nil;
    
    [tableView reloadData];
    
}

-(void)handleSuccessfulAPICall:(HyvesAPICallHandler *)aAPICallHandler response:(NSDictionary *)aResponse
{
    if (aAPICallHandler == getUserApiCallHandler)
    {
        id userDataArray = [aResponse objectForKey:@"user" orThrowExceptionWithReason:@"No user tag in user response"];
        id userData = [userDataArray objectAtIndex:0 orThrowExceptionWithReason:@"No user data in user response"];
        
        loggedInUserName = [[userData objectForKey:@"displayname"] retain];
        
        [getUserApiCallHandler release];
        getUserApiCallHandler = nil;
        
        [tableView reloadData];
        
        [getScrapsApiCallHandler cancel];
        [getScrapsApiCallHandler release];
        
        getScrapsApiCallHandler = [[GetScrapsAPICallHandler alloc] initWithUserId:userId 
                                                                          orHubId:nil 
                                                                       pageNumber:1 
                                                                   resultsPerPage:1 
                                                                         delegate:self];
        
        [getScrapsApiCallHandler execute];
    }
    else if (aAPICallHandler == logoutApiCallHandler)
    {
        self.accessToken = nil;
        self.accessTokenSecret = nil;
        self.oauthToken = nil;
        self.oauthTokenSecret = nil;
        self.userId = nil;
        self.loggedInUserName = nil;
        self.lastScrapBody = nil;
        self.lastScrapSenderName = nil;
        self.expirationDate = nil;
        
        [HyvesAPILayer sharedHyvesAPILayer].accessToken = nil;
        [HyvesAPILayer sharedHyvesAPILayer].accessTokenSecret = nil;
        
        NSLog(@"Logged out. Removing access token from user defaults.");
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessTokenSecret"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"expirationDate"];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem = loginItem;
        
        self.navigationItem.title = @"Logged Out";
        
        [tableView reloadData];
    }
    else if (aAPICallHandler == getScrapsApiCallHandler)
    {
        id requestDataArray = [aResponse objectForKey:@"request" orThrowExceptionWithReason:@"request tag is missing in the batched scrap response"];
        id scrapResultData = nil;
        id userResultData = nil;
        
        for (id requestResultData in requestDataArray)
        {
            id currentResult = [requestResultData objectForKey:getScrapsApiCallHandler.scrapsResponseTag];
            if (currentResult != nil && currentResult != [NSNull null])
            {
                id scrapResultArray = [currentResult objectForKey:@"scrap" orThrowExceptionWithReason:@"missing the scrap tag in the scraps response"];
                id scrapResultElement = [scrapResultArray objectAtIndex:0];
                if (scrapResultElement != nil && scrapResultElement != [NSNull null])
                {
                    scrapResultData = scrapResultElement;
                }
            }
            
            currentResult = [requestResultData objectForKey:@"users_get_result"];
            if (currentResult != nil && currentResult != [NSNull null])
            {
                id userResultArray = [currentResult objectForKey:@"user" orThrowExceptionWithReason:@"missing the user tag in the user response"];
                id userResultElement = [userResultArray objectAtIndex:0];
                if (userResultElement != nil && userResultElement != [NSNull null])
                {
                    userResultData = userResultElement;
                }
            }
        }
        
        if (scrapResultData != nil && userResultData != nil)
        {
            self.lastScrapBody = [scrapResultData objectForKey:@"body"];
            self.lastScrapSenderName = [userResultData objectForKey:@"displayname"];
            
            [tableView reloadData];
        }
        
        [getScrapsApiCallHandler release];
        getScrapsApiCallHandler = nil;
    }
}

-(void)handleFailedAPICall:(HyvesAPICallHandler *)aAPICallHandler error:(NSError *)aError
{
    if (aAPICallHandler == getUserApiCallHandler)
    {
        NSLog(@"Get user failed with error: %@", aError);
        [getUserApiCallHandler release];
        getUserApiCallHandler = nil;
    }
    else if (aAPICallHandler == getScrapsApiCallHandler)
    {
        NSLog(@"Get scraps failed with error: %@", aError);
        [getScrapsApiCallHandler release];
        getScrapsApiCallHandler = nil;
    }
    else if (aAPICallHandler == logoutApiCallHandler)
    {
        NSLog(@"Logout failed with error: %@", aError);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [logoutApiCallHandler release];
        logoutApiCallHandler = nil;
    }
}


#pragma mark -
#pragma mark WebAuthorizationDelegate


-(void)oauthTokenReceived:(NSString*)aOauthToken secret:(NSString*)aSecret
{
    NSLog(@"OAuth token received: %@, secret: %@", aOauthToken, aSecret);
}

-(void)oauthTokenFailedWithError:(NSError*)aError
{
    NSLog(@"OAuth token failed: %@", aError);
    [self performSelector:@selector(authorizationFailed) withObject:nil afterDelay:1.0];
}

-(void)oauthTokenAuthorized
{
    NSLog(@"OAuth token authorized!");
}

-(void)oauthTokenDeclined
{
    NSLog(@"OAuth token declined!");
    [self performSelector:@selector(authorizationFailed) withObject:nil afterDelay:1.0];
}

-(void)accessTokenReceived:(NSString*)aAcessToken secret:(NSString*)aSecret userId:(NSString*)aUserId expireDate:(NSDate*)aExpireDate
{
    NSLog(@"Access token received: %@, secret: %@, userId: %@, expires: %@", aAcessToken, aSecret, aUserId, aExpireDate);
    
    // Received the access token from the server.
    // Now we can do all the API calls which the token allows.
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem = logoutItem;
    self.navigationItem.title = @"Logged In";
    
    self.accessToken = aAcessToken;
    self.accessTokenSecret = aSecret;
    
    self.userId = aUserId;
    self.expirationDate = aExpireDate;
    
    // Save the access token in user defaults.
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:accessTokenSecret forKey:@"accessTokenSecret"];
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"expirationDate"];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [authorizationViewController release];
    authorizationViewController = nil;
    
    // Show received data in the table.
    [tableView reloadData];
    
    // Retrieve user data.
    [self retrieveUserData];
    
}


-(void)accessTokenFailedWithError:(NSError*)aError
{
    NSLog(@"Access token failed with error: %@", aError);
    [self performSelector:@selector(authorizationFailed) withObject:nil afterDelay:1.0];
}






@end
