//
//  SetGameView.swift
//  Set
//
//  Created by KaBanks on 3/23/23.
//

import SwiftUI

struct SetGameView: View {

    @State var game = SetGame()
    @State private var dealt = Set<Int>()

    @Namespace private var dealingNamespace

    private func deal(_ card: SetCard) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: SetCard) -> Bool {
        !dealt.contains(card.id)
    }

    private func dealAnimation(for card: SetCard, customIndex: Int? = nil) -> Animation {
        if let customIndex = customIndex {
            let delay = Double(customIndex) * (CardConstants.totalDealDuration / Double(game.cardsInPlay.count))
            return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
        }

        var delay = 0.0
        if let index = game.cardsInPlay.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cardsInPlay.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    var body: some View {
        VStack {
            Text("Set!").font(.title).bold()
            Text("Score: \(game.score)").font(.title2).bold()
            AspectVGrid(items: Array(game.cardsInPlay), aspectRatio: 2/3) { card in
                cardView(for: card)
            }
            deckView
        }.padding()
    }

    var deckView: some View {
        HStack {
            // Discard Deck
            ZStack {
                ForEach(game.discardDeck) { card in
                    Card(setCard: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                }
            }
            .frame(width: CardConstants.undealtWidth,
                   height: CardConstants.undealtHeight)

            Spacer()

            Button(action: {
                game.reset()
                dealt.removeAll()
            }) {
                VStack {
                    Image(systemName: "shuffle.circle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                    Text("New Game")
                        .foregroundColor(.red)
                }
            }.disabled(dealt.count == 0).opacity(dealt.count == 0 ? 0.5 : 1)

            Spacer()

            // Card Deck
            ZStack {
                ForEach(game.cardsInPlay) { card in
                    Card(setCard: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                        .onTapGesture {
                            withAnimation {
                                game.selectCard(card)
                            }
                        }
                }
                if game.deckSize() > 0 {
                    RoundedRectangle(cornerRadius: 10).fill().foregroundColor(.red)
                }
            }
            .frame(width: CardConstants.undealtWidth,
                   height: CardConstants.undealtHeight)
            .onTapGesture {
                // For new game
                if dealt.count == 0 {
                    for card in game.cardsInPlay {
                        withAnimation(dealAnimation(for: card)) {
                            deal(card)
                        }
                    }
                } else {
                    withAnimation {
                        game.addThreeCards()
                    }
                    var index = 0
                    for card in game.cardsInPlay.filter({ !dealt.contains($0.id) }) {
                        withAnimation(dealAnimation(for: card, customIndex: index)) {
                            deal(card)
                        }
                        index += 1
                    }
                }
            }
        }.padding(.horizontal)
    }

    @ViewBuilder
    private func cardView(for card: SetCard) -> some View {
        if isUndealt(card) {
            Rectangle().opacity(0)
        } else {
            Card(setCard: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .onTapGesture {
                    withAnimation {
                        game.selectCard(card)
                    }
                }
        }
    }

    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 150
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct Card: View {
    var setCard: SetCard

    var strokeColor: Color {
        if setCard.isSelected && !setCard.isMatched && !setCard.isMisMatched {
            return Color.blue
        } else if setCard.isSelected && setCard.isMatched && !setCard.isMisMatched {
            return Color.green
        } else if setCard.isSelected && !setCard.isMatched && setCard.isMisMatched {
            return Color.red
        } else {
            return Color.black
        }
    }

    let scaleAnimation = Animation
        .easeInOut(duration: 0.5)
        .repeatForever(autoreverses: true)

    let wiggleAnimation = Animation
        .linear(duration: 0.15)
        .repeatForever(autoreverses: true)

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .padding(5)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 4)
                    .foregroundColor(strokeColor)
                    .padding(5)

                switch setCard.shade {
                    case .outlined:
                        getPath(for: setCard, in: geometry.frame(in: .local))
                            .stroke(setCard.getCardColor(), lineWidth: 4)
                    case .filled:
                        getPath(for: setCard, in: geometry.frame(in: .local))
                            .fill(setCard.getCardColor())
                    case .striped:
                        getPath(for: setCard, in: geometry.frame(in: .local))
                            .stroke(setCard.getCardColor(), lineWidth: 3)
                            .clipShape(getPath(for: setCard, in: geometry.frame(in: .local)))
                }

                Text("✅")
                    .scaleEffect(setCard.isMatched ? 1.5 : 1)
                    .animation(scaleAnimation, value: setCard.isMatched)
                    .opacity(setCard.isMatched ? 1 : 0)
                    .font(.system(size: geometry.size.width / 2))

                Text("❌")
                    .rotationEffect(setCard.isMisMatched ? .degrees(-5) : .degrees(5))
                    .animation(wiggleAnimation, value: setCard.isMisMatched)
                    .font(.system(size: geometry.size.width / 2))
                    .opacity(setCard.isMisMatched ? 1 : 0)
            }
        }
    }
}

private func getPath(for setCard: SetCard, in rect: CGRect) -> Path {
    var path: Path
    switch setCard.shape {
        case .diamond:
            path = Diamond().path(in: rect)
        case .oval:
            path = Oval().path(in: rect)
        case .squiggle:
            path = Squiggle().path(in: rect)
    }

    path = replicatePath(path, for: setCard, in: rect)

    if setCard.shade == .striped {
        path.addPath(getStripedPath(in: rect))
    }

    return path
}

private func replicatePath(_ path: Path, for setCard: SetCard, in rect: CGRect) -> Path {
    var leftTwoPathTranslation: CGPoint {
        return CGPoint(
            x: rect.width * -0.15,
            y:0.0)
    }

    var rightTwoPathTranslation: CGPoint {
        return CGPoint(
            x: rect.width * 0.15,
            y:0.0)
    }

    var leftThreePathTranslation: CGPoint {
        return CGPoint(
            x: rect.width * -0.25,
            y:0.0)
    }

    var rightThreePathTranslation: CGPoint {
        return CGPoint(
            x: rect.width * 0.25,
            y:0.0)
    }

    var replicatedPath = Path()

    if (setCard.count == 1) {
        replicatedPath = path
    } else if (setCard.count == 2) {
        let leftTransform = CGAffineTransform(translationX: leftTwoPathTranslation.x,
                                              y: leftTwoPathTranslation.y)
        let rightTransform = CGAffineTransform(translationX: rightTwoPathTranslation.x,
                                               y: rightTwoPathTranslation.y)

        replicatedPath.addPath(path, transform: leftTransform)
        replicatedPath.addPath(path, transform: rightTransform)
    } else {
        let leftTransform = CGAffineTransform(translationX: leftThreePathTranslation.x,
                                              y: leftThreePathTranslation.y)
        let rightTransform = CGAffineTransform(translationX: rightThreePathTranslation.x,
                                               y: rightThreePathTranslation.y)

        replicatedPath.addPath(path, transform: leftTransform)
        replicatedPath.addPath(path, transform: rightTransform)
        replicatedPath.addPath(path)
    }

    return replicatedPath
}

private func getStripedPath(in rect: CGRect) -> Path {
    var stripedPath = Path()

    let dy: CGFloat = rect.height / 20.0
    var start = CGPoint(x: 0.0, y: dy)
    var end = CGPoint(x: rect.width, y: dy)

    while start.y < rect.height {
        stripedPath.move(to: start)
        stripedPath.addLine(to: end)
        start.y += dy
        end.y += dy
    }

    return stripedPath
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SetGameView().preferredColorScheme(.light)
            SetGameView().preferredColorScheme(.dark)
        }
    }
}
