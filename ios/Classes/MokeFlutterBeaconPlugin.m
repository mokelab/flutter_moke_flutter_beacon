#import "MokeFlutterBeaconPlugin.h"
#if __has_include(<moke_flutter_beacon/moke_flutter_beacon-Swift.h>)
#import <moke_flutter_beacon/moke_flutter_beacon-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "moke_flutter_beacon-Swift.h"
#endif

@implementation MokeFlutterBeaconPlugin
+ (void)setPluginRegistrantCallback:(FlutterPluginRegistrantCallback)callback {
    [SwiftMokeFlutterBeaconPlugin setPluginRegistrantCallback:callback];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMokeFlutterBeaconPlugin registerWithRegistrar:registrar];
}
@end
