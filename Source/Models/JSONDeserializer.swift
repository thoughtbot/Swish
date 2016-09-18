import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize(_ data: Data?) -> Result<AnyObject, SwishError> {
    let json = self.parseJSON(data)

    return json.analysis(
      ifSuccess: Result<AnyObject, SwishError>.init,
      ifFailure: { .failure(.deserializationError($0)) }
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
  func parseJSON(_ data: Data?) -> Result<AnyObject, NSError> {
    guard let d = data , d.count > 0 else {
      return .success(NSNull())
    }

    return Result(
      attempt: { try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions(rawValue: 0)) }
    ).map { $0 as AnyObject }
  }
}
