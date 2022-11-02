//
//  ViewModelWrapper.swift
//  StateObjectAlternativeDemo
//
//  Created by Jacob Lattie on 11/2/22.
//

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
