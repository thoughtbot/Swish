import Argo
import Foundation
import Result

extension Result {
  @available(*, unavailable, renamed: "Result.init(_:)")
  public static func fromDecoded(_: Decoded<T>) -> Result<T, SwishError> {
    fatalError("unavailable")
  }
}
