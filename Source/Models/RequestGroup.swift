import Result

final class RequestGroup<State>: Cancelable {
  let client: Client
  private var state: State
  private var requests = CompositeCancelable()
  private let group = DispatchGroup()
  private let queue = DispatchQueue(label: "com.thoughtbot.swish.RequestGroup<\(State.self)>")

  init(client: Client, state: State) {
    self.client = client
    self.state = state
  }

  func perform<Request: Swish.Request>(_ request: Request, completionHandler: @escaping (_ result: Result<Request.ResponseObject, SwishError>, _ state: inout State, _ cancel: inout Bool) -> Void) {
    group.enter()

    requests += client.perform(request) { result in
      var cancel = false

      self.queue.sync {
        completionHandler(result, &self.state, &cancel)
      }

      if cancel {
        self.cancel()
      }

      self.group.leave()
    }
  }

  func cancel() {
    requests.cancel()
  }

  func wait(body: (State) -> Void) {
    group.wait()
    let state = queue.sync { self.state }
    body(state)
  }
}
