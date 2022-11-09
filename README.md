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

## Possible Solutions

### Injection of a @ObservedObject

The concept of this solution is to tightly bound a reference typed `viewModel` to the parent object that makes use of the SwiftUI view you want to show.
The biggest flaw here is that if you have nested SwiftUI `View`s, you will need to pass the object reference all the way down the hierarchy.

```swift
class ClassTypedViewModel: ObservableObject {
    @Published var renderState: RenderState = .loading // Whatever data needed

    func refresh() {
        // Update state, can be called from within your View struct or from a hosting view controller like below
    }
}

class ViewController: UIViewController {
    private lazy var viewModel = ClassTypedViewModel(experienceKey: "sdui_home") // Class type
    private lazy var renderer: some View = SomeView(viewModel: viewModel).environmentObject(theme) // Reference type with class instance variable

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated: animated)
        viewModel.refresh()
    }
}
```

### Using enum Associated Values

One flaw of this method is the verbose of creating a new associated value struct for each view re draw.
Cannot use class types as they are reference types and do not trigger the @State publisher.

```swift
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
```

### Using ViewModelWrapper

Flaw of the risk of using environment objects for view models of the same type.

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
