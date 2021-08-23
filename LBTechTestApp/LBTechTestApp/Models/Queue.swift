//
//  Queue.swift
//  memorize
//
//  Created by John goodstadt on 31/12/2020.
//  Copyright © 2020 John Goodstadt. All rights reserved.
//

import Foundation

public struct Queue<T> {
  private var elements: [T] = []

	public mutating func enqueue(_ value: T) {
	elements.append(value)
	}

	public mutating func dequeue() -> T? {
		guard !elements.isEmpty else {
		  return nil
		}
		return elements.removeFirst()
	}

	public mutating func clear() {
		elements.removeAll()
	}

	public func isNotEmpty() -> Bool{
		return elements.isNotEmpty()
	}
	public func isEmpty() -> Bool{
		return elements.isEmpty
	}

	public var count: Int {
		return elements.count
	}
	public var getElements: [T] {
		return elements
	}
	
	public mutating func addAll(_ list:[T]) {
		elements.append(contentsOf: list)
	}

	public var peek: T? {
		return head
	}
	
	public var head: T? {
		return elements.first
	}

	public var tail: T? {
		return elements.last
	}
}
