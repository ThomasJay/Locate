//
//  AppDelegate.m
//  Locate
//
//  Created by Tom Jay on 9/9/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NSString * const BeaconUUIDKey = @"4F52D93B-18DA-4E81-B512-1FBF5ED4626F";

@interface AppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end



@implementation AppDelegate


-(void) setupiBeacons {
    
    // Initialize location manager and set ourselves as the delegate
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if (self.locationManager == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Manager is nil" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
        return;
        
    }
    
    self.locationManager.delegate = self;
    
    
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUIDKey];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.stomjay.beacons"];
    
    
    // Tell location manager to start monitoring for the beacon region coming or going
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    
    // Incase we are in a region already!!!
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    [self.locationManager startUpdatingLocation];
    
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    [self.locationManager startUpdatingLocation];

    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self performSelector:@selector(setupiBeacons) withObject:nil afterDelay:2.1];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Beacon location code

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    
    NSLog(@"didEnterRegion Started");
    
    
    // We entered a region, now start looking for our target beacons!
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    
    NSLog(@"didExitRegion Started");
    
    // Exited the region
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    
    
    if (beacons == nil || [beacons count] == 0) {
        return;
    }
    
    
    NSMutableArray *beaconsFound = [NSMutableArray array];
    
    
    for (CLBeacon *beacon in beacons) {
        
        NSMutableDictionary *beaconDict = [NSMutableDictionary dictionary];
        
        
        // You can retrieve the beacon data from its properties
        NSString *uuid = beacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
        

//        NSLog(@"rssi=%ld", (long)beacon.rssi);
        
        CLProximity proximity = beacon.proximity;
        
        NSString *proximityString = @"";
        
        if (proximity == CLProximityUnknown) {
            proximityString = @"Unknown";
        }
        
        if (proximity == CLProximityImmediate) {
            proximityString = @"Immediate";
        }
        
        if (proximity == CLProximityNear) {
            proximityString = @"Near";
        }
        
        if (proximity == CLProximityFar) {
            proximityString = @"Far";
        }
        
        CLLocationAccuracy accuracy = beacon.accuracy;
        
        
        
//        NSLog(@"Raw accuracy=%f", accuracy);
        
        if (accuracy < 0) {
            accuracy = accuracy * -1.0;
        }
        
        double distanceInFeet = accuracy * 3.28084;
        
//        NSString *distanceInFeetString = [NSString stringWithFormat:@"%.2f", distanceInFeet];
        
//        NSLog(@"Adjusted accuracy=%f", accuracy);
//        NSLog(@"distanceInFeetString=%@", distanceInFeetString);
//        NSLog(@"proximityString=%@", proximityString);
        
        int distanceInFeedInt = distanceInFeet;
        
        
        beaconDict[@"uuid"] = uuid;
        beaconDict[@"major"] = major;
        beaconDict[@"minor"] = minor;
        
        
        int rssi = (int)beacon.rssi;
        
        beaconDict[@"rssi"] = [NSNumber numberWithInt:rssi];
        beaconDict[@"distanceInFeet"] = [NSNumber numberWithInt:distanceInFeedInt];
        
        
        // If the rssi value is 0 then dont consider this a valid beacon ping
        if (beacon.rssi != 0) {
            [beaconsFound addObject:beaconDict];
        }
        
        
    }
    
    NSMutableDictionary *userInfoDictionary = [NSMutableDictionary dictionary];
    [userInfoDictionary setValue:beaconsFound forKey:@"beaconsFound"];

    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"RANGEDBEACONS" object:nil userInfo:userInfoDictionary];
                   });

    
    
}




@end
