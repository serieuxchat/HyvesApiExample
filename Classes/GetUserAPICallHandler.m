//
//  GetUserAPIHandler.m
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

#import "GetUserAPICallHandler.h"


@implementation GetUserAPICallHandler
@synthesize userIds;


-(void)dealloc
{
    [userIds release];
    
    [super dealloc];
}

-(id)initWithUserIds:(NSArray*)aUserIds delegate:(id<HyvesAPIResponse>)aDelegate
{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    NSString* method = nil;
    if (aUserIds != nil && [aUserIds count] > 0)
    {
        userIds = [aUserIds retain];
        method = @"users.get";
        [param setObject:[aUserIds componentsJoinedByString:@","] forKey:@"userid"];
    }
    else 
    {
        method = @"users.getLoggedin";
    }
    
    NSString* responseFields = @"username,usertypes,cityname,countryname,profilepicture,mobilenumber,mobilenumberverified,emailaddress,profilevisible,scrapsvisible,geolocation,relationtype";
    
    [param setObject:responseFields forKey:@"ha_responsefields"];
    
    [param setObject:@"false" forKey:@"ha_fancylayout"];
    // [param setObject:@"xml" forKey:@"ha_fancylayout_format"];
    
    if ((self = [super initWithHyvesAPIMethod:method 
                                  parameters:param 
                            secureConnection:NO 
                                    delegate:aDelegate 
                                     timeout:DEFAULT_API_CALL_TIMEOUT]))
    {
    }
    
    [param release];
    
    return self;
}




@end
