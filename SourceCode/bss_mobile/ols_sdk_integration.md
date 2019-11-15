### Project location
* OLS SDK: `/somepath/ols-sdk`
* iOS project: `/somepath/iOSBankApp`
* Android project: `/somepath/AndroidBankApp`

### Prerequisite
`Flutter` for both iOS & Android
`CocoaPods ` for iOS
* Install Flutter:
[https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* Install CocoaPods for OSX
[https://guides.cocoapods.org/using/getting-started.html#toc_3](https://guides.cocoapods.org/using/getting-started.html#toc_3)

### SDK Structure:

![](https://snag.gy/DcnG9N.jpg)

* **.ios**: library for ios app, contains some Cocoapods and a helper Ruby script
* **.android**: library for android app (use for solution 1)
* ** android_lib**: Includes aar & android resource (use for solution 2)

## iOS Integration

### <a name="fenced-code-block"> iOS Bank app configuration </a>

##### if current project is not using CocoaPods, install CocoaPods:
* Open terminal, change to `somepath/iOSBankApp`
* Run command: `pod init` to creates a `Podfile` for the current project 

![https://snag.gy/f1eZWw.jpg](https://snag.gy/f1eZWw.jpg)

##### 1. Add the following lines to `Podfile`:
	
~~~~ 
flutter_application_path = '/somepath/ols-sdk/'
eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding) 	
~~~~

##### 2. Run `pod install` in the terminal.

##### 3. Open file `iOSBankApp.xcworkspace`

![https://snag.gy/06Ugmv.jpg](https://snag.gy/06Ugmv.jpg)

##### 4. Disable Bitcode for target:

Disable `ENABLE_BITCODE` flag located in target's `Build Settings->Build Options->Enable Bitcode `
 
![ https://snag.gy/4tnD9g.jpg
](https://snag.gy/4tnD9g.jpg) 

##### 5. Add a build phase for building the Dart code

Select the top-level `iOSBankApp` project in the Project navigator. Select **TARGET** `iOSBankApp` in the left part of the main view, and then select the `Build Phases` tab. Add a new build phase by clicking the + towards the top left of the main view. Select `New Run Script Phase`. Expand the new `Run Script`, just appended to the list of phases.

Paste the following into the text area just below the `Shell field`:

~~~~
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed
~~~~

Finally, drag the new build phase to just after the `Target Dependencies` phase.


![https://snag.gy/ZQqaFH.jpg
](https://snag.gy/ZQqaFH.jpg) 

Build the project using `⌘B`

### Write code to use FlutterViewController from Bank app's
##### 1. In `AppDelegate.h`: 
* Declare app delegate to be a subclass of `FlutterAppDelegate`. 
* `FlutterEngine` property, which help to register a plugin without a `FlutterViewController`.

~~~~
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

@interface AppDelegate : FlutterAppDelegate
@property (nonatomic,strong) FlutterEngine *flutterEngine;
@end

~~~~

![https://snag.gy/Dy3QxT.jpg](https://snag.gy/Dy3QxT.jpg)

##### 2. In `AppDelegate.m`:
~~~~
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // Only if you have Flutter Plugins

#include "AppDelegate.h"

@implementation AppDelegate

// This override can be omitted if you do not have any Flutter Plugins.
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.flutterEngine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
  [self.flutterEngine runWithEntrypoint:nil];
  [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
~~~~

![https://snag.gy/3F7W1Q.jpg
](https://snag.gy/3F7W1Q.jpg)

##### 3. Create new Objective-C class name `LoyaltyViewController` extend `FlutterViewController`

![https://snag.gy/FPa3LK.jpg](https://snag.gy/FPa3LK.jpg)

##### 4. In Main.storyboard create new ViewController
* Class: `LoyaltyViewController`
* Storyboard ID: `LoyaltyViewController`

![https://snag.gy/KJer06.jpg](https://snag.gy/KJer06.jpg)

#### 5. Handle click event from button Bank app's

* Open bank app: `ViewController.m`

~~~~
#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "LoyaltyViewController.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // Only if you have Flutter Plugins

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openLoyaltyApp:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoyaltyViewController *loyaltyViewController = [sb instantiateViewControllerWithIdentifier:@"loyaltyViewController"];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:loyaltyViewController];
    [GeneratedPluginRegistrant registerWithRegistry:loyaltyViewController];
    [self presentViewController:loyaltyViewController animated:true completion:nil];
}
    
@end
~~~~

##### 6.Building and running Bank app's
###### ----- Done iOS Integration -----

##  Android Integration



##### Open `terminal`
* Change to folder: `/somepath/ols-sdk/.android`
* Run command: `./gradlew flutter:assembleDebug`

This results in a `flutter-debug.aar` archive file in `.android/Flutter/build/outputs/aar/.`
### <a name="fenced-code-block"> Android Bank app's configuration </a>

#### Solution 1: use .android folder, require dart source code

Declares source compatibility within `app's build.gradle`:

~~~~
compileOptions {
  sourceCompatibility 1.8
  targetCompatibility 1.8
}
~~~~

Includes the ols-sdk as a sub-project in the Bank app's settings.gradle:

~~~~
include ':app'                                     // assumed existing content
setBinding(new Binding([gradle: this]))                                 // new
evaluate(new File(                                                      // new
  settingsDir.parentFile,                                               // new
  '/somepath/ols-sdk/.android/include_flutter.groovy'                          // new
))                                                                      // new

~~~~

Add dependency to Bank app's `app/build.gradle`

~~~~
:
dependencies {
  implementation project(':flutter')
  :
}
~~~~

#### Solution 2: use android library aar

Create `libs` foder at `/somepath/AndroidBankApp/app` if not exist and copy all `aar` file from `android_lib ` folder:

![https://snag.gy/0tmAfe.jpg
](https://snag.gy/0tmAfe.jpg)

Add this lines to `/somepath/AndroidBankApp/build.gradle`:

~~~~
 flatDir 
 	{
     dirs 'libs'
    }
~~~~

Declares aars file within `/somepath/AndroidBankApp/app/build.gradle`:

~~~~
implementation(name: 'flutter-debug', ext: 'aar')
implementation(name: 'path_provider-debug', ext: 'aar')
implementation(name: 'sqflite-debug', ext: 'aar')
~~~~

Copy `flutter_assets` from `android_lib` to Bank app's assets folder:
* 
![https://snag.gy/y2LSXu.jpg
](https://snag.gy/y2LSXu.jpg)

### <a name="fenced-code-block"> Open Loyalty view from android Bank app's code </a>

Create a button and handle click event:

~~~~
import io.flutter.facade.Flutter;
........

 FloatingActionButton fab = findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                View flutterView = Flutter.createView(MainActivity.this, getLifecycle(), null);
                FrameLayout.LayoutParams frameLayout = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                addContentView(flutterView, frameLayout);
            }
        });
~~~~

##### Building and running Bank app's
###### ----- Done Android Integration -----
