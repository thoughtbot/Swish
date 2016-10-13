import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize(_ data: Data?) -> Result<Any, SwishError> {
    let json = parseJSON(data)

    return json.analysis(
      ifSuccess: Result<Any, SwishError>.init,
      ifFailure: { .failure(.deserializationError($0)) }
    )
  }
}

extension JSON: Parser {
  public typealias Representation = JSON

  public static func parse(_ j: Any) -> Result<JSON, SwishError> {
    return Result(JSON.init(j))
  }
}

private extension JSONDeserializer {
  func parseJSON(_ data: Data?) -> Result<Any, NSError> {
    guard let d = data , d.count > 0 else {
      return .success(NSNull())
    }

    return Result(
      attempt: { try JSONSerialization.jsonObject(with: d) }
    ).map { $0 }
  }
}
