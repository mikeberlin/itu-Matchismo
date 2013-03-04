//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mike Berlin on 2/27/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

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
    Card *secondCard = nil;
    NSArray *cardsToMatch = nil;

    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            [self.flipHistory addObject:[NSString stringWithFormat:@"Flipped up %@", card.contents]];
            
            for (Card *nextCardToMatch in self.cards) {
                if (nextCardToMatch.isFaceUp && !nextCardToMatch.isUnplayable) {

                    if (!self.threeGameMode) {
                        cardsToMatch = @[nextCardToMatch];
                    }
                    else if (!secondCard) {
                        secondCard = nextCardToMatch;
                        continue;
                    }
                    else {
                        cardsToMatch = @[secondCard, nextCardToMatch];
                    }

                    if (cardsToMatch) {
                        int matchScore = [card match:cardsToMatch];
                        NSArray *cardsInPlay = [@[card] arrayByAddingObjectsFromArray:cardsToMatch];

                        if (matchScore) {
                            for (PlayingCard *cardToMark in cardsInPlay) {
                                cardToMark.unplayable = YES;
                            }

                            self.score += matchScore * MATCH_BONUS;
                            [self addMoveToFlipHistory:cardsInPlay withDisplayText:@"Matched %@for %d points!" withScore:matchScore * MATCH_BONUS];
                        } else {
                            for (PlayingCard *cardToMark in cardsToMatch) {
                                cardToMark.faceUp = NO;
                            }

                            self.score -= MISMATCH_PENALTY;
                            [self addMoveToFlipHistory:cardsInPlay withDisplayText:@"%@ don't match!" withScore:0];
                        }

                        break;
                    }
                }
            }

            self.score -= FLIP_COST;
        }

        card.faceUp = !card.isFaceUp;
    }
}

- (void)addMoveToFlipHistory:(NSArray *)cardsToDisplay
             withDisplayText:(NSString *)displayText
                   withScore:(int)matchScore {

    NSMutableString *cardOutput = [[NSMutableString alloc] init];

    for (int i=0; i < [cardsToDisplay count]; i++) {
        if (i == 0) {
            [cardOutput appendFormat:@"%@", ((PlayingCard *)[cardsToDisplay objectAtIndex:i]).contents];
        }
        else {
            [cardOutput appendFormat:@"and %@", ((PlayingCard *)[cardsToDisplay objectAtIndex:i]).contents];
        }
    }

    [self.flipHistory addObject:[NSString stringWithFormat:displayText, cardOutput, matchScore]];
}

@end