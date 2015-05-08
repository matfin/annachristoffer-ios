#import <Foundation/Foundation.h>
#import <Lookback/LookbackRecordingOptions.h>

@interface LookbackRecordingSession : NSObject
@property(readonly,copy) LookbackRecordingOptions *options;
- (void)stopRecording;
@end