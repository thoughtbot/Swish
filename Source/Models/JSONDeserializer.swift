import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize(_ data: Data?) -> Result<AnyObject, SwishError> {
    let json = self.parseJSON(data)

    return json.analysis(
      ifSuccess: Result<AnyObject, SwishError>.init,
      ifFailure: { .Failure(.deserializationError($0)) }
    )
  }
}

extension JSON: Parser {
  public typealias Representation = JSON

  public static func parse(_ j: AnyObject) -> Result<JSON, SwishError> {
    return Result(JSON.init(j))
  }
}

private extension JSONDeserializer {
  private func parseJSON(_ data: Data?) -> Result<AnyObject, NSError> {
    guard let d = data where (d as NSData).length > 0 else {
      return .Success(NSNull())
    }

    return Result(
      try JSONSerialization
        .jsonObject(with: d, options: JSONSerialization.ReadingOptions(rawValue: 0))
    )
  }
}
