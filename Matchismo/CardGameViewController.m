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
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *matchModeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (_game == nil) _game = [[CardMatchingGame alloc] initWidthCardCount:self.cardButtons.count
                                                                 usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        UIImage *bgImage = (card.isFaceUp) ? nil : [UIImage imageNamed:@"bicycleback01.jpg"];

        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setImage:bgImage forState:UIControlStateNormal];

        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;

        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        self.statusLabel.text = self.game.lastFlip;
    }

    self.flipHistorySlider.enabled = true;
    self.flipHistorySlider.maximumValue = [self.game.flipHistory count] - 1;
    self.flipHistorySlider.value = self.flipHistorySlider.maximumValue;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    self.matchModeSwitch.enabled = false;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)deal:(id)sender {
    self.game = nil;
    
    [self setFlipCount:0];
    [self updateUI];

    self.matchModeSwitch.enabled = true;
    self.matchModeSwitch.on = false;
    self.flipHistorySlider.maximumValue = 0;
    self.flipHistorySlider.value = 0;
    self.statusLabel.text = @"Good luck!";
}

- (IBAction)slideHistory:(id)sender {
    UISlider *slider = sender;
    NSInteger sliderIndex = slider.value;

    if ([self.game.flipHistory count] > 0)
        self.statusLabel.text = self.game.flipHistory[sliderIndex];
}

- (IBAction)threeMatchMode:(id)sender {
    UISwitch *threeMatchModeSwitch = sender;
    self.game.threeGameMode = threeMatchModeSwitch.on;
}


@end