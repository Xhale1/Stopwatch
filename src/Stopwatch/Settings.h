//
//  Settings.h
//  WatchStop
//
//  Created by Reece Carolan on 10/18/14.
//
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController
{
    IBOutlet UIImageView *BG;
    
    IBOutlet UIButton *Gold;
    IBOutlet UIButton *Silver;
    IBOutlet UIButton *Gray;
    IBOutlet UIButton *Linen;
    IBOutlet UIButton *Blue;
    IBOutlet UIButton *Back;
    IBOutlet UISwitch *increments;
}

-(IBAction)Gold:(id)sender;
-(IBAction)Silver:(id)sender;
-(IBAction)BlueButton:(id)sender;
-(IBAction)Gray:(id)sender;
-(IBAction)Linen:(id)sender;
-(IBAction)GoldBG:(id)sender;
-(IBAction)Blue:(id)sender;
-(IBAction)Metal:(id)sender;
-(IBAction)Green:(id)sender;
-(IBAction)increments:(id)sender;

@end
