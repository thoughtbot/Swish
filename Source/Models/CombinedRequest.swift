import Result

struct CombinedRequest<RequestA: Request, RequestB: Request> {
  typealias ResponseA = RequestA.ResponseObject
  typealias ResponseB = RequestB.ResponseObject

  let requestA: RequestA
  let requestB: RequestB
  let client: Client

  init(_ requestA: RequestA, _ requestB: RequestB, client: Client) {
    self.requestA = requestA
    self.requestB = requestB
    self.client = client
  }

  func perform(completionHandler: @escaping (Result<(ResponseA, ResponseB), SwishError>) -> Void) -> Cancelable {
    var start: DispatchWorkItem!

    var cancelable = CompositeCancelable()
    cancelable += { start.cancel() }

    start = DispatchWorkItem { self.start(&cancelable, completionHandler) }

    DispatchQueue.global().async(execute: start)

    return cancelable
  }

  private func start(_ cancelable: inout CompositeCancelable, _ completionHandler: @escaping (Result<(ResponseA, ResponseB), SwishError>) -> Void) {
    let initial = CombinedRequestState<RequestA.ResponseObject, RequestB.ResponseObject, SwishError>.response(.none, .none)
    let group = RequestGroup(client: client, state: initial)

    cancelable += { group.cancel() }

    group.perform(requestA) { resultA, state, cancel in
      switch (state, resultA) {
      case (.error, _):
        cancel = true
      case let (.response(_, b), .success(a)):
        state = .response(a, b)
      case let (.response, .failure(error)):
        state = .error(error)
        cancel = true
      }
    }

    group.perform(requestB) { resultB, state, cancel in
      switch (state, resultB) {
      case (.error, _):
        cancel = true
      case let (.response(a, _), .success(b)):
        state = .response(a, b)
      case let (.response, .failure(error)):
        state = .error(error)
        cancel = true
      }
    }

    group.wait { combinedResults in
      switch combinedResults {
      case let .error(error):
        completionHandler(.failure(error))

      case let .response(a?, b?):
        completionHandler(.success(a, b))

      case .response:
        fatalError("expected both requests to complete or error")
      }
    }
  }
}

private enum CombinedRequestState<A, B, Error: Swift.Error> {
  case error(Error)
  case response(A?, B?)
}
