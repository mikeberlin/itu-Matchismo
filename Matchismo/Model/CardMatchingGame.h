//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Mike Berlin on 2/27/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (id)initWidthCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *lastFlip;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@property (nonatomic) BOOL threeGameMode;

@end