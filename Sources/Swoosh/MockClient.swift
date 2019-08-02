import Foundation
import Swish

public class MockClient: Client {
  private var mocks: [ObjectIdentifier: [RequestMatcher]] = [:]

  public init() {}

  @discardableResult
  public func perform<T>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, SwishError>) -> Void) -> URLSessionDataTask where T: Request {
    if let typeMocks = self.mocks[ObjectIdentifier(T.self)] {
      let response = typeMocks
        .compactMap { $0.match(request) }
        .first
      if let response = response {
        completionHandler(response)
      }
    }

    return URLSessionDataTask()
  }

  private func insert(_ clazz: Any.Type, _ matcher: RequestMatcher) {
    let identifier = ObjectIdentifier(clazz)
    if var existing = self.mocks[identifier] {
      existing.append(matcher)
      mocks[identifier] = existing
    } else {
      mocks[identifier] = [matcher]
    }
  }

  public func when<T>(_ clazz: T.Type, _ response: T.ResponseObject) -> MockClient where T: Request {
    let matcher = AnyRequestMatcher<T>(response: .success(response))
    insert(clazz, matcher)
    return self
  }

  public func when<T>(_ clazz: T.Type, _ response: SwishError) -> MockClient where T: Request {
    let matcher = AnyRequestMatcher<T>(response: .failure(response))
    insert(clazz, matcher)
    return self
  }

  public func when<T>(_ request: T, _ response: T.ResponseObject) -> MockClient where T: Request, T: Equatable {
    let matcher = EqRequestMatcher(request: request, response: .success(response))
    insert(T.self, matcher)
    return self
  }

  public func when<T>(_ request: T, _ response: SwishError) -> MockClient where T: Request, T: Equatable {
    let matcher = EqRequestMatcher(request: request, response: .failure(response))
    insert(T.self, matcher)
    return self
  }

  public func when<T>(_ matchFn: @escaping (T) -> T.ResponseObject?) -> MockClient where T: Request {
    let matcher = PredicateRequestMatcher { req in
      matchFn(req).map { .success($0) }
    }
    insert(T.self, matcher)
    return self
  }

  public func when<T>(_ matchFn: @escaping (T) -> SwishError?) -> MockClient where T: Request {
    let matcher = PredicateRequestMatcher { req in
      matchFn(req).map { .failure($0) }
    }
    insert(T.self, matcher)
    return self
  }

  public func when<T>(_ matchFn: @escaping (T) -> Result<T.ResponseObject, SwishError>?) -> MockClient where T: Request {
    let matcher = PredicateRequestMatcher { req in
      matchFn(req)
    }
    insert(T.self, matcher)
    return self
  }
}
