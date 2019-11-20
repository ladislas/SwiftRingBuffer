import XCTest
@testable import SwiftRingBuffer

final class InitTests: XCTestCase {

	func test_init_properties() {

		let rb = RingBuffer<UInt8>(size: 4)

		XCTAssertEqual(rb.size, 4)
		XCTAssertEqual(rb.buffer, [nil, nil, nil, nil])
		XCTAssertEqual(rb.status, .empty)

		XCTAssertEqual(rb.head, 0)
		XCTAssertEqual(rb.tail, 0)
		XCTAssertEqual(rb.dataLength, 0)

	}

}

final class WriteTests: XCTestCase {

	func test_write_element() {

		var rb = RingBuffer<UInt8>(size: 4)

		rb.write(0x2A)

		XCTAssertEqual(rb.dataLength, 1)
		XCTAssertEqual(rb.buffer, [0x2A, nil, nil, nil])

		rb.write(0x2B)

		XCTAssertEqual(rb.dataLength, 2)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, nil, nil])

		rb.write(0x2C)

		XCTAssertEqual(rb.dataLength, 3)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, nil])

		rb.write(0x2D)

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

	}

	func test_write_element_full_overflow() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.write(0x2A))
		XCTAssertTrue(rb.write(0x2B))
		XCTAssertTrue(rb.write(0x2C))
		XCTAssertTrue(rb.write(0x2D))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

		XCTAssertFalse(rb.write(0x2E))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

	}

	func test_write_array() {

		var rb = RingBuffer<UInt8>(size: 4)

		rb.write([0x2A, 0x2B])

		XCTAssertEqual(rb.dataLength, 2)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, nil, nil])

		rb.write([0x2C, 0x2D])

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

	}

	func test_write_array_full_overflow() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.write([0x2A, 0x2B, 0x2C, 0x2D]))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

		XCTAssertFalse(rb.write([0x2E, 0x2F]))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.buffer, [0x2A, 0x2B, 0x2C, 0x2D])

	}

	func test_write_array_with_left_size_not_enough_overflow() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertFalse(rb.write([0x2A, 0x2B, 0x2C, 0x2D, 0x2E]))

		XCTAssertEqual(rb.dataLength, 0)
		XCTAssertEqual(rb.buffer, [nil, nil, nil, nil])

	}

}

final class ReadTests: XCTestCase {

	func test_read_element() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.write([0x2A, 0x2B]))

		XCTAssertEqual(rb.dataLength, 2)
		XCTAssertEqual(rb.data, [0x2A, 0x2B])

		XCTAssertEqual(rb.read(), 0x2A)

		XCTAssertEqual(rb.dataLength, 1)
		XCTAssertEqual(rb.data, [0x2B])

		XCTAssertEqual(rb.read(), 0x2B)

		XCTAssertEqual(rb.dataLength, 0)
		XCTAssertEqual(rb.data, [UInt8]())

		XCTAssertNil(rb.read())

		XCTAssertEqual(rb.dataLength, 0)
		XCTAssertEqual(rb.data, [UInt8]())

	}

	func test_read_element_full() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.write([0x2A, 0x2B, 0x2C, 0x2D]))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.data, [0x2A, 0x2B, 0x2C, 0x2D])

		XCTAssertEqual(rb.read(), 0x2A)

		XCTAssertEqual(rb.dataLength, 3)
		XCTAssertEqual(rb.data, [0x2B, 0x2C, 0x2D])

		XCTAssertEqual(rb.read(), 0x2B)

		XCTAssertEqual(rb.dataLength, 2)
		XCTAssertEqual(rb.data, [0x2C, 0x2D])

		XCTAssertEqual(rb.read(), 0x2C)

		XCTAssertEqual(rb.dataLength, 1)
		XCTAssertEqual(rb.data, [0x2D])

		XCTAssertEqual(rb.read(), 0x2D)

		XCTAssertEqual(rb.dataLength, 0)
		XCTAssertEqual(rb.data, [UInt8]())

		XCTAssertNil(rb.read())

		XCTAssertEqual(rb.dataLength, 0)
		XCTAssertEqual(rb.data, [UInt8]())

	}

	func test_write_read_write() {

		var rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.write([0x2A, 0x2B]))

		XCTAssertEqual(rb.dataLength, 2)
		XCTAssertEqual(rb.data, [0x2A, 0x2B])

		XCTAssertEqual(rb.read(), 0x2A)

		XCTAssertEqual(rb.dataLength, 1)
		XCTAssertEqual(rb.data, [0x2B])

		XCTAssertTrue(rb.write([0x2C, 0x2D]))

		XCTAssertEqual(rb.dataLength, 3)
		XCTAssertEqual(rb.data, [0x2B, 0x2C, 0x2D])

		XCTAssertTrue(rb.write(0x2E))

		XCTAssertEqual(rb.dataLength, 4)
		XCTAssertEqual(rb.data, [0x2B, 0x2C, 0x2D, 0x2E])

	}

}

final class PeekTests: XCTestCase {



}

final class DumpClearTests: XCTestCase {



}

final class StatusTests: XCTestCase {

	func test_empty() {

		let rb = RingBuffer<UInt8>(size: 4)

		XCTAssertTrue(rb.isEmpty)
		XCTAssertFalse(rb.hasData)
		XCTAssertFalse(rb.isFull)

	}

	func test_data() {

		var rb = RingBuffer<UInt8>(size: 4)

		rb.write([0x2A, 0x2B])

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertFalse(rb.isFull)

	}

	func test_full() {

		var rb = RingBuffer<UInt8>(size: 4)

		rb.write([0x2A, 0x2B])
		rb.write([0x2C, 0x2D])

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertTrue(rb.isFull)

	}

	func test_empty_data_full() {

		var rb = RingBuffer<UInt8>(size: 4)

		rb.write([0x2A, 0x2B])
		rb.write([0x2C, 0x2D])

		let _ = rb.read()

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertFalse(rb.isFull)

		let _ = rb.read()

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertFalse(rb.isFull)

		let _ = rb.read()
		let _ = rb.read()

		XCTAssertTrue(rb.isEmpty)
		XCTAssertFalse(rb.hasData)
		XCTAssertFalse(rb.isFull)

		let _ = rb.read()

		XCTAssertTrue(rb.isEmpty)
		XCTAssertFalse(rb.hasData)
		XCTAssertFalse(rb.isFull)

		rb.write([0x2A, 0x2B])

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertFalse(rb.isFull)

		rb.write([0x2C, 0x2D])

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertTrue(rb.isFull)

		let _ = rb.read()

		XCTAssertFalse(rb.isEmpty)
		XCTAssertTrue(rb.hasData)
		XCTAssertFalse(rb.isFull)

	}

	func test_disp() {

	
	}


}

