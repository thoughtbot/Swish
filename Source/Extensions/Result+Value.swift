//
//  Result+Value.swift
//  Swish
//
//  Created by Samuel Goodwin on 3/26/19.
//  Copyright © 2019 thoughtbot. All rights reserved.
//

import Foundation

extension Result {
  public var value: Success? {
    switch self {
    case .failure:
      return nil
    case .success(let value):
      return value
    }
  }
  
  public var error: Failure? {
    switch self {
    case .failure(let error):
      return error
    case .success:
      return nil
    }
  }
}
