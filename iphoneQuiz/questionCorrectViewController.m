//
//  questionCorrectViewController.m
//  iphoneQuiz
//
//  Created by Ivan Seto on 7/13/14.
//  Copyright (c) 2014 Ivan Seto. All rights reserved.
//

#import "questionCorrectViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface questionCorrectViewController ()

@end

@implementation questionCorrectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)nextViewFunction:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query getObjectInBackgroundWithId:appDelegate.rowID block:^(PFObject *iphoneApp, NSError *error) {
        NSDate *estToday = [[NSDate date] dateByAddingTimeInterval:-60*60*5];
        NSLog(@"today %@",estToday);
        iphoneApp[@"pendingQuestions"] = @-1;
        [iphoneApp saveInBackground];
        [NSThread sleepForTimeInterval:1.5];
        if (self.gotAnswerCorrect == true){
            [iphoneApp addObject:self.questionNumber forKey:@"correctAnswerArray"];
            [iphoneApp addObject:self.JOL forKey:@"correctJOLArray"];
            [iphoneApp addObject:estToday forKey:@"correctDateArray"];
            [iphoneApp saveInBackground];
            
            //date formatter to y/m/d
            NSMutableArray *dateArray = iphoneApp[@"correctDateArray"];
            NSMutableArray *JOLArray = iphoneApp[@"correctJOLArray"];
            NSMutableArray *correctArray = iphoneApp[@"correctAnswerArray"];
            NSMutableArray *questionArray = [[NSMutableArray alloc] init];
            
            int n = 0;
            NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
            [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];
            NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
            NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
            //for datearray, if date = today, n++
            for (int i=0;i<[dateArray count];i++){
                //NSLog(@"%@",[dateComparisonFormatter stringFromDate:dateArray[i]]);
                QuestionClass *question = [[QuestionClass alloc]initWithQuestion:correctArray[i] andJOL:JOLArray[i] andDate:dateArray[i]];
                if ([[dateComparisonFormatter stringFromDate:estToday] isEqualToString:[dateComparisonFormatter stringFromDate:dateArray[i]]]){
                    //NSLog(@"same date");
                    [questionArray addObject:question];
                    //NSLog(@"question# %d",[incorrectArray[i] integerValue]);
                    //NSLog(@"JOL %d",[JOLArray[i] integerValue]);
                    //NSLog(@"%@",dateArray[i]);
                    n++;
                }
                else{
                    //NSLog(@"different date");
                    [sortedQuestionArray addObject:question.questionNumber];
                    [sortedJOLArray addObject:question.JOL];
                }
            }
            
            //sort questionArray into sortedArray by JOL
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"JOL" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            sortedArray = [questionArray sortedArrayUsingDescriptors:sortDescriptors];
            
            //NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
            //NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
            for (int i=0;i<[sortedArray count];i++){
                QuestionClass *temp = sortedArray[i];
                [sortedQuestionArray addObject:temp.questionNumber];
                [sortedJOLArray addObject:temp.JOL];
                //NSLog(@"%d",[sortedQuestionArray[i] integerValue]);
            }
            
            iphoneApp[@"correctJOLArray"] = sortedJOLArray;
            iphoneApp[@"correctAnswerArray"] = sortedQuestionArray;
            [iphoneApp saveInBackground];
            
        }
        else { //adds question# and JOL to parse.com array
            [iphoneApp addObject:self.questionNumber forKey:@"incorrectAnswerArray"];
            [iphoneApp addObject:self.JOL forKey:@"incorrectJOLArray"];
            [iphoneApp addObject:estToday forKey:@"incorrectDateArray"];
            [iphoneApp saveInBackground];
            
            //date formatter to y/m/d
            NSMutableArray *dateArray = iphoneApp[@"incorrectDateArray"];
            NSMutableArray *JOLArray = iphoneApp[@"incorrectJOLArray"];
            NSMutableArray *incorrectArray = iphoneApp[@"incorrectAnswerArray"];
            NSMutableArray *questionArray = [[NSMutableArray alloc] init];
            
            int n = 0;
            NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
            [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];
            NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
            NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
            //for datearray, if date = today, n++
            for (int i=0;i<[dateArray count];i++){
                //NSLog(@"%@",[dateComparisonFormatter stringFromDate:dateArray[i]]);
                QuestionClass *question = [[QuestionClass alloc]initWithQuestion:incorrectArray[i] andJOL:JOLArray[i] andDate:dateArray[i]];
                if ([[dateComparisonFormatter stringFromDate:estToday] isEqualToString:[dateComparisonFormatter stringFromDate:dateArray[i]]]){
                    //NSLog(@"same date");
                    [questionArray addObject:question];
                    //NSLog(@"question# %d",[incorrectArray[i] integerValue]);
                    //NSLog(@"JOL %d",[JOLArray[i] integerValue]);
                    //NSLog(@"%@",dateArray[i]);
                    n++;
                }
                else{
                    //NSLog(@"different date");
                    [sortedQuestionArray addObject:question.questionNumber];
                    [sortedJOLArray addObject:question.JOL];
                }
            }
            
            //sort questionArray into sortedArray by JOL
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"JOL" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            sortedArray = [questionArray sortedArrayUsingDescriptors:sortDescriptors];
            
            //NSMutableArray *sortedQuestionArray = [[NSMutableArray alloc] init];
            //NSMutableArray *sortedJOLArray = [[NSMutableArray alloc] init];
            for (int i=0;i<[sortedArray count];i++){
                QuestionClass *temp = sortedArray[i];
                [sortedQuestionArray addObject:temp.questionNumber];
                [sortedJOLArray addObject:temp.JOL];
                //NSLog(@"%d",[sortedQuestionArray[i] integerValue]);
            }
            
            iphoneApp[@"incorrectJOLArray"] = sortedJOLArray;
            iphoneApp[@"incorrectAnswerArray"] = sortedQuestionArray;
            [iphoneApp saveInBackground];
        }
        
        NSNumber *questionsToday = iphoneApp[@"questionsToday"];
        if ([questionsToday integerValue] == 5){
            [self performSegueWithIdentifier:@"finishSegue" sender:sender];
        }
        else {
            [self performSegueWithIdentifier:@"nextQuestionSegue" sender:sender];
        }
        [iphoneApp saveInBackground];
    }];

}

- (IBAction)b1:(id)sender {
    self.JOL = @1;
    self.b1.alpha = 1;
    self.b2.alpha = .3;
    self.b3.alpha = .3;
    self.b4.alpha = .3;
    self.b5.alpha = .3;
    [self nextViewFunction:(id)sender];
}
- (IBAction)b2:(id)sender {
    self.JOL = @2;
    self.b1.alpha = .3;
    self.b2.alpha = 1;
    self.b3.alpha = .3;
    self.b4.alpha = .3;
    self.b5.alpha = .3;
    [self nextViewFunction:(id)sender];
}
- (IBAction)b3:(id)sender {
    self.JOL = @3;
    self.b1.alpha = .3;
    self.b2.alpha = .3;
    self.b3.alpha = 1;
    self.b4.alpha = .3;
    self.b5.alpha = .3;
    [self nextViewFunction:(id)sender];
}
- (IBAction)b4:(id)sender {
    self.JOL = @4;
    self.b1.alpha = .3;
    self.b2.alpha = .3;
    self.b3.alpha = .3;
    self.b4.alpha = 1;
    self.b5.alpha = .3;
    [self nextViewFunction:(id)sender];
}
- (IBAction)b5:(id)sender {
    self.JOL = @5;
    self.b1.alpha = .3;
    self.b2.alpha = .3;
    self.b3.alpha = .3;
    self.b4.alpha = .3;
    self.b5.alpha = 1;
    [self nextViewFunction:(id)sender];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"iPhoneQuizApp"];
    [query getObjectInBackgroundWithId:appDelegate.rowID block:^(PFObject *iphoneApp, NSError *error) {
        NSNumber *questionsToday = iphoneApp[@"questionsToday"];
        int intQuestionsToday = [questionsToday integerValue];
        intQuestionsToday++;
        questionsToday = [NSNumber numberWithInteger: intQuestionsToday];
        iphoneApp[@"questionsToday"] = questionsToday;
        [iphoneApp saveInBackground];
        self.questionProgressBar.progress = [questionsToday integerValue];
        self.progressLabel.text = [NSString stringWithFormat:@"%i of 5 questions answered",[questionsToday integerValue]];
    }];
    
    if (self.gotAnswerCorrect == true){
        self.correctWrongLabel.text = @"Correct";
        self.checkCrossImageView.image = [UIImage imageNamed:@"checkmark.png"];
    }
    else{
        self.correctWrongLabel.text = @"Wrong";
        self.checkCrossImageView.image = [UIImage imageNamed:@"xmark.png"];
    }
    self.answerTextView.text = self.correctAnswerString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
