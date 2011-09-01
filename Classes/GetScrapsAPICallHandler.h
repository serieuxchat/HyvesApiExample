//
//  GetScrapsAPICallHandler.h
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

#import "BatchedAPICallHandler.h"


@interface GetScrapsAPICallHandler : BatchedAPICallHandler
{
    NSString*               userId;
    NSString*               hubId;
    BOOL                    ascending;
    NSInteger               pageNumber;
    NSInteger               resultsPerPage;
    NSString*               scrapsResponseTag;
}

@property(readonly) NSString *userId;
@property(readonly) NSString *hubId;
@property(readonly) NSInteger pageNumber;
@property(readonly) NSInteger resultsPerPage;
@property(readonly) NSString* scrapsResponseTag;
@property(readonly) BOOL      ascending;


-(id)initWithUserId:(NSString*)aUserId
            orHubId:(NSString*)aHubId
         pageNumber:(NSInteger)aPageNumber
     resultsPerPage:(NSInteger)aResultsPerPage
           delegate:(id<HyvesAPIResponse>)aDelegate;


@end
