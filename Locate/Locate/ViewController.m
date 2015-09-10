//
//  ViewController.m
//  Locate
//
//  Created by Tom Jay on 9/9/15.
//  Copyright (c) 2015 Tom Jay. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

@interface ViewController () {
    int slotSize;
    
    int nextSlot;
    
    int slotOffsets[5];
    
    NSString *slotKeys[5];
    
}

@property(nonatomic, strong) NSMutableArray *imageList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageList = [NSMutableArray array];
    
    int width = self.view.frame.size.width;
    
    slotSize = width / 5;
    
    
    
    slotOffsets[0] = (3 * slotSize) - (slotSize / 2);
    slotOffsets[1] = (2 * slotSize);
    slotOffsets[2] = (4 * slotSize);
    slotOffsets[3] = (1 * slotSize);
    slotOffsets[4] = 25;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    
    [center addObserver:self selector:@selector(rangedBeacons:)
               name:@"RANGEDBEACONS" object:nil];


    
}

-(void) rangedBeacons:(NSNotification*) notification {
    NSDictionary *userInfoDictionary = [notification userInfo];
    
    NSArray *beaconsFound = userInfoDictionary[@"beaconsFound"];
    
    
    
    // Remove all images;
    for (UIImageView *imageView in _imageList) {
        [imageView removeFromSuperview];
    }
    
    [_imageList removeAllObjects];
    
    
    int height = self.view.frame.size.height;

    
    for (NSDictionary *item in beaconsFound) {
        
//        NSString *uuid = item[@"uuid"];
        NSString *major = item[@"major"];
        NSString *minor = item[@"minor"];
//        NSNumber *rssi = item[@"rssi"];
        NSNumber *distanceInFeedInt = item[@"distanceInFeet"];
        
        NSString *key = [NSString stringWithFormat:@"%@-%@", major, minor];
        
        int slotNumber = 0;
        
        for (int i=0;i<5;i++) {
            NSString *slotKey = slotKeys[i];
            
            // Check if its not null to see if its the current key
            if (slotKey != nil) {
                if ([slotKey isEqual:key]) {
                    slotNumber = i;
                    break;
                }
            }
            else {
                // If we have an empty slot and have not found this key, use this slot
                slotKeys[i] = key;
                slotNumber = i;
                break;
            }
        }
        
        
        [self addImage:slotNumber signal:height - ([distanceInFeedInt intValue] * 15) major:[major intValue] minor:[minor intValue]];

        
    }
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    DrawView *drawView = [[DrawView alloc] initWithFrame:self.view.frame];
    
    drawView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:drawView];
    

}

-(void) addImage:(int) slot signal:(int) signal major:(int) major minor:(int)minor{
    
    
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(slotOffsets[slot] - 25, signal - 80, 80, 80)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.text= [NSString stringWithFormat:@"0x%04x", major];
    label.textColor=[UIColor blueColor];
    
    [containerView addSubview:label];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 20)];
    label2.text= [NSString stringWithFormat:@"0x%04x", minor];
    label2.textColor=[UIColor lightGrayColor];
    
    [containerView addSubview:label2];
    

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 35, 35, 35)];
    
    imageView.image = [UIImage imageNamed:@"beacon"];
    imageView.frame = CGRectMake(12, 35, 35, 35);
    
    
    [containerView addSubview:imageView];
    
    [self.view addSubview:containerView];
    
    [_imageList addObject:containerView];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
