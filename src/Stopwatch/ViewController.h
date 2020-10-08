//
//  ViewController.h
//  Stopwatch
//
//  Created by Reece Carolan on 8/28/14.
//
//

#import <UIKit/UIKit.h>

BOOL Running;
BOOL Reset;
float dos;
int lapNum;
NSString *Time;
NSDate *methodStart;

@interface ViewController : UIViewController
{
    IBOutlet UILabel *hh;
    IBOutlet UILabel *mm;
    IBOutlet UILabel *ss;
    IBOutlet UILabel *ms;
    IBOutlet UILabel *ex;
    IBOutlet UILabel *ns;
    
    IBOutlet UILabel *a;
    IBOutlet UILabel *b;
    IBOutlet UILabel *c;
    IBOutlet UILabel *d;
    IBOutlet UILabel *e;
    IBOutlet UILabel *f;
    
    IBOutlet UILabel *converted;
    
    IBOutlet UIButton *stopReset;
    IBOutlet UIButton *convertToSeconds;
    IBOutlet UIButton *reset;
    IBOutlet UIButton *lap;
    IBOutlet UIButton *settings;
    
    IBOutlet UITextView *lapList;
    
    IBOutlet UIImageView *Screen;
    IBOutlet UIImageView *Box;
    IBOutlet UIImageView *BG;
    
    NSTimer *time;
    
    NSDate *methodFinish;
    
    NSTimeInterval executionTime1;
}

-(IBAction)start:(id)sender;
-(IBAction)stopReset:(id)sender;
-(IBAction)convert:(id)sender;
-(IBAction)lap:(id)sender;

@end
