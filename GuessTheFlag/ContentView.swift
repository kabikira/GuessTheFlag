//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by koala panda on 2023/01/05.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.heavy))
            .foregroundColor(.cyan)
            .padding()
    }
}
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var totalScore = 0
    
    @State private var topCount = 0
    @State private var fullCount = false
    
    var FlagImage: some View {
        VStack {
            Text("Tap the flag of")
                .foregroundColor(.white)
                .font(.subheadline.weight(.heavy))
            Text(countries[correctAnswer])
                .foregroundStyle(.secondary)
                .font(.largeTitle.weight(.semibold))
            
            ForEach(0..<3) { number in
                Button {
                    // flag was tapped
                    flagTapped(number)
                } label: {
                    Image(countries[number])
                        .renderingMode(.original)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                    
                }
            }
        }
    }
    
    func resetGame() {
        totalScore = 0
        topCount = 0
        askQuestion()
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            totalScore += 10
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        topCount += 1
        if topCount >= 8 {
            fullCount = true
        } else {
            showingScore = true
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    FlagImage
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(totalScore)")
        }
        
        .alert("End of Game! Your score: \(totalScore)", isPresented: $fullCount) {
            Button("Done", action: resetGame)
        } message: {
            Text("Game will be reset")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
