//
//  AvatarDownload.m
//  IgniteTools
//
//  Created by Joseph Flasher on 6/7/11.
//  Copyright 2011 Ars Sollertia. All rights reserved.
//

#import "AvatarDownload.h"

/**
 *	Holder for private data.
 */
@interface AvatarDownload()
@property (nonatomic, retain) NSMutableData *receivedData;
@end

@implementation AvatarDownload

@synthesize twitterID, image, delegate, receivedData;

#pragma mark -

- (void)dealloc 
{
    [twitterID release];
    [image release];
    delegate = nil;
    [receivedData release];
    [super dealloc];
}

- (UIImage *)image
{
    if (image == nil && !downloading)
    {
        if (twitterID != nil && [twitterID length] > 0)
        {
			twitterID = [twitterID stringByReplacingOccurrencesOfString:@"@" withString:@""];
			NSString *url = [NSString stringWithFormat:@"http://img.tweetimag.es/i/%@_b", twitterID];
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            NSURLConnection *con = [[NSURLConnection alloc]
                                    initWithRequest:req
                                    delegate:self
                                    startImmediately:NO];
            [con scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
            [con start];
            
            
            
            if (con) 
            {
                NSMutableData *data = [[NSMutableData alloc] init];
                self.receivedData = data;
                [data release];
            } 
            else 
            {
                NSError *error = [NSError errorWithDomain:AvatarDownloadErrorDomain 
                                                     code:AvatarDownloadErrorNoConnection 
                                                 userInfo:nil];
                if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
                    [delegate download:self didFailWithError:error];
            }   
            [req release];
            
            downloading = YES;
        }
    }
    return image;
}

#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [connection release];
    if ([delegate respondsToSelector:@selector(download:didFailWithError:)])
        [delegate download:self didFailWithError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    UIImage *dataImage = [[UIImage alloc] initWithData:receivedData];
    self.image = dataImage;
    [dataImage release];
    if ([delegate respondsToSelector:@selector(downloadDidFinishDownloading:)])
        [delegate downloadDidFinishDownloading:self];
    
    [connection release];
    self.receivedData = nil;
}

@end
