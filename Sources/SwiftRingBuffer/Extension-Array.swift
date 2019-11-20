//
//  Extension-Array.swift
//  SwiftRingBuffer
//
//  Created by Ladislas de Toldi on 29/10/2018.
//

import Foundation

extension Array {

	subscript(i: UInt) -> Element {

		get {
			return self[Int(i)]
		}

		set(from) {
			self[Int(i)] = from
		}

	}

}
