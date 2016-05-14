import Result
import Foundation

public protocol Deserializer {
  func deserialize(data: NSData?) -> Result<AnyObject, SwishError>
}
