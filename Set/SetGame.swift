//
//  SetGame.swift
//  Set
//
//  Created by KaBanks on 3/23/23.
//

import Foundation
import SwiftUI

struct SetGame {
    private let numberOfSetCardsInANewGame = 12
    private var deck = SetCardDeck()

    var discardDeck = [SetCard]()
    var cardsInPlay = [SetCard]()
    var score = 0

    // This is so the view can access the deck size
    func deckSize() -> Int {
        self.deck.count()
    }

    mutating func discard(index: Int) {
        var card = cardsInPlay.remove(at: index)
        card.isMatched = false
        card.isMisMatched = false
        card.isSelected = false

        self.discardDeck.append(card)
    }

    mutating func addThreeCards() {
        let selectedCards = self.cardsInPlay.filter({ $0.isSelected })

        if selectedCards.count <= 3 && !isValidPair(selectedCards) {
            for _ in 0..<3 {
                if let setCard = self.deck.dealCard() {
                    cardsInPlay.append(setCard)
                }
            }
        } else {
            for card in selectedCards {
                if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                    // Discard cards and replace them
                    if let newCard = self.deck.dealCard() {
                        var oldCard = cardsInPlay[chosenIndex]
                        oldCard.isMatched = false
                        oldCard.isMisMatched = false
                        oldCard.isSelected = false

                        self.discardDeck.append(oldCard)
                        cardsInPlay[chosenIndex] = newCard
                    }
                }
            }
        }
    }

    mutating func selectCard(_ card: SetCard) {

        var selectedCards = self.cardsInPlay.filter({ $0.isSelected })

        // Only allow toggling to happen if 2 or less cards are selected
        if selectedCards.count <= 2 {
            if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                self.cardsInPlay[chosenIndex].isSelected = !self.cardsInPlay[chosenIndex].isSelected

                // Update the value for selectedCards after toggling the 3ed card
                selectedCards = self.cardsInPlay.filter({ $0.isSelected })

                // If the 3 selected cards are a pair set them as matched
                // and increment the score, else set them as mismatched
                if selectedCards.count == 3 {
                    if isValidPair(selectedCards) {
                        score += 1
                        setCardsAsMatched(selectedCards)
                    } else {
                        setCardsAsMisMatched(selectedCards)
                    }
                }
            }
        } else {
            if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                // Do not allow deselecting cards if it is already selected and
                // 3 cards are currently selected
                if !self.cardsInPlay[chosenIndex].isSelected {
                    if isValidPair(selectedCards) {
                        for card in selectedCards {
                            if let selectedCardIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                                discard(index: selectedCardIndex)
                            }
                        }
                    }
                    // Reset all the cards
                    unselectAllCards()
                    if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                        self.cardsInPlay[chosenIndex].isSelected = !self.cardsInPlay[chosenIndex].isSelected
                    }
                }
            }
        }
    }

    mutating func unselectAllCards() {
        for (index, _) in self.cardsInPlay.enumerated() {
            self.cardsInPlay[index].isSelected = false
            self.cardsInPlay[index].isMisMatched = false
        }
    }

    mutating func setCardsAsMatched(_ cards: [SetCard]) {
        for card in cards {
            if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                self.cardsInPlay[chosenIndex].isMatched = true
            }
        }
    }

    mutating func setCardsAsMisMatched(_ cards: [SetCard]) {
        for card in cards {
            if let chosenIndex = self.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                self.cardsInPlay[chosenIndex].isMisMatched = true
            }
        }
    }

    func isValidPair(_ cards: [SetCard]) -> Bool {
        // A valid pair must have 3 cards
        if cards.count != 3 { return false }

        let card1 = cards[0]
        let card2 = cards[1]
        let card3 = cards[2]

        // I tried for a good 10min trying to think of another way to do this logic
        // in a more cleaner way, but I could't. Comparing 3 items to each other is
        // tough, so I just left it as is. This is spaghetti code, but it works
        //
        // Basically each attribute must all be the same or all different for a valid pair

        if (!((card1.count == card2.count) && (card2.count == card3.count) ||
                (card1.count != card2.count) && (card1.count != card3.count) && (card2.count != card3.count))) {
            return false
        }

        if (!((card1.shape == card2.shape) && (card2.shape == card3.shape) ||
                (card1.shape != card2.shape) && (card1.shape != card3.shape) && (card2.shape != card3.shape))) {
            return false
        }

        if (!((card1.shade == card2.shade) && (card2.shade == card3.shade) ||
                (card1.shade != card2.shade) && (card1.shade != card3.shade) && (card2.shade != card3.shade))) {
            return false
        }

        if (!((card1.color == card2.color) && (card2.color == card3.color) ||
                (card1.color != card2.color) && (card1.color != card3.color) && (card2.color != card3.color))) {
            return false
        }

        return true
    }

    mutating func reset() {
        // Set self to a new instance of itself to reset the struct
        // https://stackoverflow.com/a/33841215
        self = SetGame()
    }

    init() {
        self.deck = SetCardDeck()

        for _ in 0..<numberOfSetCardsInANewGame {
            if let setCard = self.deck.dealCard() {
                cardsInPlay.append(setCard)
            }
        }
    }

}
