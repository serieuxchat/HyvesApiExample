//
//  GetScrapsAPICallHandler.m
//  Hyves
//
//  Created by Hyves, 2011
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

#import "GetScrapsAPICallHandler.h"


@implementation GetScrapsAPICallHandler

@synthesize userId;
@synthesize hubId;
@synthesize pageNumber;
@synthesize resultsPerPage;
@synthesize scrapsResponseTag;
@synthesize ascending;

-(void)dealloc
{
    [userId release];
    [hubId release];
    [scrapsResponseTag release];
    
    [super dealloc];
}


-(void)addMediaGetApiMethod
{
    NSMutableDictionary* p = [[NSMutableDictionary alloc] initWithCapacity:4];
    [p setObject:@"0(mediaid)" forKey:@"mediaid"];
    
    NSString* responseFields = @"commentscount%2Crespectscount%2Cfancylayouttag%2Cgeolocation%2Cviewscount%2Cmobileurl";
    [p setObject:responseFields forKey:@"ha_responsefields"];
    [p setObject:@"false" forKey:@"ha_fancylayout"];
    // [p setObject:@"xml" forKey:@"ha_fancylayout_format"];
    
    [self addHyvesAPIMethod:@"media.get" parameters:p];
    
    [p release];
}

-(void)addUsersGetApiMethod
{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [param setObject:@"0(userid)" forKey:@"userid"];
    NSString* responseFields = @"username%2Cusertypes%2Ccityname%2Ccountryname%2Cprofilepicture%2Cmobilenumber%2Cmobilenumberverified%2Cemailaddress%2Cprofilevisible%2Cscrapsvisible%2Cgeolocation%2Crelationtype";
    
    [param setObject:responseFields forKey:@"ha_responsefields"];
    [param setObject:@"false" forKey:@"ha_fancylayout"];
    // [param setObject:@"xml" forKey:@"ha_fancylayout_format"];
    
    [self addHyvesAPIMethod:@"users.get" parameters:param];
    
    [param release];
}


-(void)addScrapsGetApiMethod
{
    NSMutableDictionary* scrapsGetParameters = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    if (userId != nil)
    {
        [scrapsGetParameters setObject:userId forKey:@"target_userid"];
    }
    else if (hubId != nil)
    {
        [scrapsGetParameters setObject:hubId forKey:@"target_hubid"];
    }
    
    [scrapsGetParameters setObject:@"false" forKey:@"ha_fancylayout"];
    // [scrapsGetParameters setObject:@"xml" forKey:@"ha_fancylayout_format"];
    
    [scrapsGetParameters setObject:[NSString stringWithFormat:@"%d", pageNumber] forKey:@"ha_page"];
    [scrapsGetParameters setObject:[NSString stringWithFormat:@"%d", resultsPerPage] forKey:@"ha_resultsperpage"];
    
    if (ascending)
    {
        [scrapsGetParameters setObject:@"asc" forKey:@"sortorder"];
    }
    
    NSString* method = nil;
    if (userId != nil) 
    {
        method = @"users.getScraps";
        scrapsResponseTag = @"users_getScraps_result";
    }
    else if (hubId != nil)
    {
        method = @"hubs.getScraps";
        scrapsResponseTag = @"hubs_getScraps_result";
    }
    else 
    {
        NSAssert(false, @"GetScrapsAPICallHandler must have a non-nil userId or hubId");
    }
    
    
    [self addHyvesAPIMethod:method parameters:scrapsGetParameters];
    
    [scrapsGetParameters release];
    
}

-(id)initWithUserId:(NSString*)aUserId
            orHubId:(NSString*)aHubId
         pageNumber:(NSInteger)aPageNumber
     resultsPerPage:(NSInteger)aResultsPerPage
           delegate:(id<HyvesAPIResponse>)aDelegate
{
    if (self = [super initWithListener:aDelegate 
                      secureConnection:NO 
                               timeout:DEFAULT_API_CALL_TIMEOUT])
    {
        userId = [aUserId retain];
        hubId = [aHubId retain];
        pageNumber = aPageNumber;
        resultsPerPage = aResultsPerPage;
        
        [parameters setObject:@"false" forKey:@"ha_fancylayout"];
        // [parameters setObject:@"xml" forKey:@"ha_fancylayout_format"];
        // [parameters setObject:@"true" forKey:@"processflml"];
        
        [self addScrapsGetApiMethod];
        [self addUsersGetApiMethod];
        [self addMediaGetApiMethod];
    }
    
    return self;
}


@end
