#import <Foundation/Foundation.h>

#define AvatarDownloadErrorDomain @"Avatar Download Error Domain"
enum 
{
    AvatarDownloadErrorNoConnection = 1000,
};

@class AvatarDownload;

/**
 *	Receive callbacks on AvatarDownload completion.
 */
@protocol AvatarDownloadDelegate
/**
 *	The download is finished.
 *	@param download The AvatarDownload object.
 */
- (void)downloadDidFinishDownloading:(AvatarDownload *)download;
@optional
/**
 *	The download failed.
 *	@param download The AvatarDownload object.
 *	@param error The error containing failure information.
 */
- (void)download:(AvatarDownload *)download didFailWithError:(NSError *)error;
@end

/**
 *	This class will download an image from Twitter and return it once it's complete.
 */
@interface AvatarDownload : NSObject {
	NSString *twitterID;
    UIImage *image;
    id <NSObject, AvatarDownloadDelegate> delegate;
	
@private
    NSMutableData *receivedData;
    BOOL downloading;
}

/**
 *	The Twitter handle.
 */
@property (nonatomic, retain) NSString *twitterID;
/**
 *	Avatar image.
 */
@property (nonatomic, retain) UIImage *image;

/**
 *	The delegate to receives notifications.
 */
@property (nonatomic, assign) id <NSObject, AvatarDownloadDelegate> delegate;

@end
