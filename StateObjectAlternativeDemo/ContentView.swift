//
//  ContentView.swift
//  StateObjectAlternativeDemo
//
//  Created by Jacob Lattie on 11/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("iOS 13 @StateObject Alternative")
                .font(.title)
                .multilineTextAlignment(.center)

            Spacer()

            RandomNumberView()

            Spacer()
        }
        .padding()
    }
}

// MARK: - Counter

struct CounterViewModel {
    var count = 0
}

struct CounterView: View {

    enum ViewState {
        case initial
        case loaded(CounterViewModel)
    }

    @State var state: ViewState = .loaded(CounterViewModel())

    var body: some View {
        switch state {
        case .initial:
            Text("Loading...")
        case let .loaded(viewModel):
            Text("Count is: \(viewModel.count)")
                .font(.title)

            Button("Increment Counter") {
                state = .loaded(.init(count: viewModel.count + 1))
            }
        }
    }
}


// MARK: - Random Number

struct RandomNumberView: View {

    @State var randomNumber = 0

    var body: some View {
        VStack {
            Text("Random number is: \(randomNumber)")
                .font(.title)
                .padding(.top)

            Button("Randomize number") {
                randomNumber = (0..<1000).randomElement()!
            }
        }.padding(.bottom)
        
        CounterView()
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Other Solutions Tried

/*
    Attempted solutions
 
 CounterView(viewModel: viewModel)
 
 struct CounterView: View {
     @State var viewModel: CounterViewModel

     var body: some View {
         VStack {
             Text("Count is: \(viewModel.count)")
                 .font(.title)
             Button("Increment Counter") {
                 viewModel.incrementCounter()
             }.environmentObject(viewModel)
         }
     }
 }
 
struct CounterView: View {
    @Binding var viewModel: CounterViewModel

    var body: some View {
        VStack {
            Text("Count is: \(viewModel.count)")
                .font(.title)
            Button("Increment Counter") {
                viewModel.incrementCounter()
            }
        }
    }
}

struct RandomNumberView: View {
  @State var randomNumber = 0

  @State var viewModel = CounterViewModel()

  var body: some View {
      VStack {
          Text("Random number is: \(randomNumber)")
              .font(.title)
              .padding(.top)

          Button("Randomize number") {
              randomNumber = (0..<1000).randomElement()!
          }
      }.padding(.bottom)

      CounterView(viewModel: $viewModel)
  }
}
*/
