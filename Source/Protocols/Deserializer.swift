import Result
import Foundation

public protocol Deserializer {
  func deserialize(_ data: Data?) -> Result<AnyObject, SwishError>
}
