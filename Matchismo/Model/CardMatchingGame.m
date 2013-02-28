//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mike Berlin on 2/27/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;

@end

@implementation CardMatchingGame

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flipHistory {
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (NSString *)lastFlip {
    NSString *flip = [self.flipHistory lastObject];
    return (flip) ? flip : @"";
}

- (id)initWidthCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        self.cards = nil;
        self.flipHistory = nil;
        self.score = 0;

        for(int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card)
                self = nil;
            else
                self.cards[i] = card;
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];

    // TODO: Make this work for three cards...
    if (self.threeGameMode)
    {
    }
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            [self.flipHistory addObject:[NSString stringWithFormat:@"Flipped up %@", card.contents]];

            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        [self.flipHistory addObject:[NSString stringWithFormat:@"Matched %@ and %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS]];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        [self.flipHistory addObject:[NSString stringWithFormat:@"%@ and %@ don't match!", card.contents, otherCard.contents]];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end