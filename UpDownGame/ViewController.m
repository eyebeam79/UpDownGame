//
//  ViewController.m
//  UpDownGame
//
//  Created by SDT1 on 2014. 1. 6..
//  Copyright (c) 2014년 SDT1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
    int answer;
    int maximumTrial;
    int trial;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *userInput;

- (IBAction)checkInput:(id)sender;
- (IBAction)newGame:(id)sender;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    // 숫자 키보드로 지정
    self.userInput.keyboardType = UIKeyboardTypeNumberPad;
    
    // 키보드는 시작하자마자 올라오도록 한다.
    [self.userInput becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 초기치설정
    [self newGame:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkInput:nil];
    
    return YES;
}

// AlertView로 게임재시작여부 확인
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.firstOtherButtonIndex == buttonIndex)
    {
        [self newGame:self.gameSelector];
    }
}


// 확인버튼을 누르면 입력된 숫자값은 확인한다.
- (IBAction)checkInput:(id)sender
{
    int inputVal = [self.userInput.text intValue];
    self.userInput.text = @"";
    
    if (inputVal == answer)
    {
        self.label.text = @"정답입니다.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"정답" message:@"다시 게임하겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        
        alert.tag = 1;
        [alert show];
    }
    else
    {
        trial++;
        if (trial >= maximumTrial)
        {
            NSString *msg = [NSString stringWithFormat:@"답은 %d입니다.", answer];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"실퍠" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            
            alert.tag = 2;
            [alert show];
        }
        else
        {
            if (answer > inputVal)
            {
                self.label.text = @"Down";
            }
            else
            {
                self.label.text = @"Up";
            }
            
            self.countLabel.text = [NSString stringWithFormat:@"%d/%d", trial, maximumTrial];
            self.progress.progress = trial / (float)maximumTrial;
        }
    }

}

// 새게임
- (IBAction)newGame:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    int selectedGame = control.selectedSegmentIndex;
    int maximumRandom = 0;
    
    if (selectedGame == 0)
    {
        maximumTrial = 5;
        maximumRandom = 10;
    }
    else if(selectedGame == 1)
    {
        maximumTrial = 10;
        maximumRandom = 50;
    }
    else
    {
        maximumTrial = 20;
        maximumRandom = 100;
    }
    
    answer = arc4random() % maximumRandom + 1;
    trial = 0;
    self.progress.progress = 0.0;
    self.countLabel.text = @"";
    self.label.text = @"";
    
    NSLog(@"New Game with answer: %d", answer);
}

@end
