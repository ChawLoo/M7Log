#import "MlogPlugin.h"
#if __has_include(<mlog/mlog-Swift.h>)
#import <mlog/mlog-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mlog-Swift.h"
#endif

@implementation MlogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMlogPlugin registerWithRegistrar:registrar];
}
@end
