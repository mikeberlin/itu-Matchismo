//
//  PlayingCard.m
//  Assignment 0
//
//  Created by Mike Berlin on 2/24/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#define SUIT_MATCH_SCORE 1
#define RANK_MATCH_SCORE 4

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count - 1;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    BOOL isSuitMatch = YES;
    BOOL isRankMatch = YES;
    
    for (PlayingCard *testCard in otherCards) {
        if (![self.suit isEqualToString:testCard.suit]) isSuitMatch = NO;
        if (self.rank != testCard.rank) isRankMatch = NO;
        if (!isSuitMatch && !isRankMatch) break;
    }
    
    if (isRankMatch) {
        score = RANK_MATCH_SCORE * [otherCards count];
    } else if (isSuitMatch) {
        score = SUIT_MATCH_SCORE * [otherCards count];
    }

    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end