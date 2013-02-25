//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mike Berlin on 2/24/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *myDeck;
@end

@implementation CardGameViewController

- (PlayingCardDeck *)myDeck
{
    if (_myDeck == nil) _myDeck = [[PlayingCardDeck alloc] init];
    return _myDeck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;

    if (sender.selected)
    {
        PlayingCard *nextCard = [[PlayingCard alloc] init];
        nextCard = (PlayingCard *)[self.myDeck drawRandomCard];

        [sender setTitle:nextCard.contents forState:UIControlStateSelected];
    }

    self.flipCount++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end