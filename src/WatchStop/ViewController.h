//
//  ViewController.h
//  WatchStop
//
//  Created by Reece Carolan on 5/3/16.
//  Copyright © 2016 Reece Carolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblView;
    
    IBOutlet UILabel *TimeLabel;
    IBOutlet UILabel *SecondsLabel;
    
    IBOutlet UIButton *StartStopButton;
    IBOutlet UIButton *ResetLapButton;
    
    IBOutlet UIImageView *BarLeft;
    IBOutlet UIImageView *BarRight;
    IBOutlet UIImageView *Background;
    
    IBOutlet UISegmentedControl *unitSelector;
    IBOutlet UISegmentedControl *lapSelector;
    
    NSMutableArray *lapTotal;
    NSMutableArray *lapPrev;
    
    NSTimer *timer;
    
    NSDate *methodStart;
    
    NSTimeInterval exTime;
    
    float prevTime;
}


@end

