//
//  ContentView.swift
//  Bullseye
//
//  Created by Diego Jurfest Ceccon on 01/08/20.
//  Copyright © 2020 ___DIEGOJURFESTCECCON___. All rights reserved.
//

import SwiftUI

// definition of a struct named ContentView, and it’s a View
struct ContentView: View {
    
    // Properties
    // ==========
    
    // Colors
    let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    // Game stats
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    var sliderValueRounded: Int {
        Int(self.sliderValue.rounded())
    } //computed property, which is a property that acts like a method
    @State var score = 0
    @State var round = 1
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    
    // User interface content and layout
    var body: some View {
        NavigationView {
            VStack {
                Spacer().navigationBarTitle("🎯 Bullseye 🎯")
                
                // Target row
                HStack {
                    Text("Put the bullseye as close as you can to:")
                        .modifier(LabelStyle())
                    Text("\(self.target)")
                        .modifier(ValueStyle())
                }
                
                Spacer()
                
                HStack {
                    Text("1")
                        .modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1.0...100.0).animation(.easeOut)
                    Text("100")
                        .modifier(LabelStyle())
                }.padding(.horizontal, 10)
                
                Spacer()
                
                // Button row
                Button(action: {
                    self.alertIsVisible = true
                }) {
                    Text("Hit me!")
                        .modifier(ButtonLargeTextStyle())
                }
                .background(Image("button").resizable().frame(width: 110, height: 55)
                .modifier(Shadow())
                )
                    .alert(isPresented: $alertIsVisible) {
                        Alert(title: Text(alertTitle()),
                              message: Text(scoringMessage()),
                              dismissButton: .default(Text("Awesome!")) {
                                self.startNewRound()
                            }
                        )
                }
                
                Spacer()
                
                // Score row
                HStack {
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack {
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("button").resizable().frame(width: 90, height: 45)
                    .modifier(Shadow()) )
                    Spacer()
                    Text("Score:")
                        .modifier(LabelStyle())
                    Text("\(score)")
                        .modifier(ValueStyle())
                    Spacer()
                    Text("Round:")
                        .modifier(LabelStyle())
                    Text("\(round)")
                        .modifier(ValueStyle())
                    Spacer()
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            // Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("button").resizable().frame(width: 90, height: 45)
                    .modifier(Shadow())
                    )
                }
                .padding(.bottom, 20)
                .padding(.trailing, 40)
                .padding(.leading, 20)
                .accentColor(midnightBlue)
            }
            .background(Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Methods
    // =======
    
    func pointsForCurrentRound() -> Int {
        let maximumScore = 100
        let points: Int
        
        if sliderTargetDifference == 0 {
            points = 200
        } else if sliderTargetDifference == 1 {
            points = 150
        } else {
            points = maximumScore - sliderTargetDifference
        }
        
        return points
    }
    
    func scoringMessage() -> String {
        return "The slider's value is \(sliderValueRounded).\n" +
            "The target value is \(target).\n" +
        "You scored \(pointsForCurrentRound()) points this round."
    }
    
    func alertTitle() -> String {
        
        let title: String
        if sliderTargetDifference == 0 {
            title = "Perfect!"
        } else if sliderTargetDifference < 5 {
            title = "You almost had it!"
        } else if sliderTargetDifference <= 10 {
            title = "Not bad." } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    func startNewGame() {
        self.score = 0
        self.round = 1
        self.resetSliderAndTarget()
    }
    
    func startNewRound() {
        self.score = score + pointsForCurrentRound()
        self.round = round + 1
        self.resetSliderAndTarget()
    }
    
    func resetSliderAndTarget() {
        self.sliderValue = 50.0
        self.target = Int.random(in: 1...100)
    }
    
    
}

// View modifiers
// ==============
struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct ButtonLargeTextStyle: ViewModifier { func body(content: Content) -> some View {
    content
        .font(Font.custom("Arial Rounded MT Bold", size: 18))
        .foregroundColor(Color.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier { func body(content: Content) -> some View {
    content
        .font(Font.custom("Arial Rounded MT Bold", size: 12))
        .foregroundColor(Color.black)
    }
}
// Preview
// =======

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
