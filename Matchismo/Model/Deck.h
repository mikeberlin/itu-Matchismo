//
//  Deck.h
//  Assignment 0
//
//  Created by Mike Berlin on 2/24/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card
          atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end