import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize(_ data: Data) -> Result<Any, SwishError> {
    let json = parseJSON(data)

    return json.analysis(
      ifSuccess: Result.init(value:),
      ifFailure: { .failure(.deserializationError($0.error)) }
    )
  }
}

extension JSON: Parser {
  public typealias Representation = JSON

  public static func parse(_ j: Any) -> Result<JSON, SwishError> {
    return Result(JSON(j))
  }
}

private extension JSONDeserializer {
  func parseJSON(_ data: Data) -> Result<Any, AnyError> {
    guard data.count > 0 else {
      return .success(NSNull())
    }

    return Result(
      attempt: { try JSONSerialization.jsonObject(with: data) }
    )
  }
}
