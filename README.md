# StateObjectAlternative
## iOS 13 alternative for @StateObject

Project based on article from [SwiftLee](https://www.avanderlee.com/swiftui/stateobject-observedobject-differences/)

Solution `ViewModelWrapper.swift` based on forum post [here](https://stackoverflow.com/questions/66426228/stateobject-on-ios-13)

## Hierarchy of views

* ContentView
  * RandomNumberView
    * CounterView
      
The `RandomNumberView` struct must instantiate and hold onto the View Model of the `CounterView` which makes use of `@ObservedObject`.
Redraws of the parent and child view do not affect the view model since it is a `@State`. Environment object is used to pass the view model down
to the child `CounterView`.

## Demo Video

https://user-images.githubusercontent.com/90261824/199534690-03cc9166-937b-4052-a31e-c4cf07487a1a.mov

## Usage

### Solution

```swift
import Foundation
import SwiftUI

struct ViewModelWrapper<V: View, ViewModel: ObservableObject>: View {
    private let contentView: V
    @State private var contentViewModel: ViewModel

    init(contentView: @autoclosure () -> V, vm: @autoclosure () -> ViewModel) {
        self._contentViewModel = State(initialValue: vm())
        self.contentView = contentView()
    }

    var body: some View {
        contentView
            .environmentObject(contentViewModel)
    }
}
```

### Example

```swift

struct RandomNumberView: View {
    @State var randomNumber = 0

    @ObservedObject var viewModel = CounterViewModel()

    var body: some View {
        VStack {
            Text("Random number is: \(randomNumber)")
                .font(.title)
                .padding(.top)

            Button("Randomize number") {
                randomNumber = (0..<1000).randomElement()!
            }
        }.padding(.bottom)

        ViewModelWrapper(contentView:
                            VStack {
                                Text("Count is: \(viewModel.count)")
                                    .font(.title)
                            Button("Increment Counter") {
                                viewModel.incrementCounter()
                            }
                        }, vm: viewModel)
    }
}
```
