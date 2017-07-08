import Foundation

public protocol Cancelable {
  func cancel()
}

extension URLSessionTask: Cancelable {}

struct SimpleCancelable: Cancelable {
  private let action: () -> Void

  init(action: @escaping () -> Void) {
    self.action = action
  }

  func cancel() {
    action()
  }
}

struct CompositeCancelable: Cancelable {
  private var cancelables: [Cancelable] = []

  mutating func add(_ cancelable: Cancelable) {
    cancelables.append(cancelable)
  }

  mutating func add(_ action: @escaping () -> Void) {
    add(SimpleCancelable(action: action))
  }

  func cancel() {
    cancelables.forEach { $0.cancel() }
  }

  static func += (composite: inout CompositeCancelable, cancelable: Cancelable) {
    composite.add(cancelable)
  }

  static func += (composite: inout CompositeCancelable, action: @escaping () -> Void) {
    composite.add(action)
  }
}
