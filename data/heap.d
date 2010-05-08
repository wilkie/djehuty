/*
 * priorityqueue.d
 *
 * A simple implementation of a priority queue (a min-heap or a max-heap).
 * References are stored with an array indexed at 1. Implementation is a sorted heap.
 *
 * Author: Dave Wilkinson
 * Originated: November 7th, 2009
 *
 */

module data.heap;

import data.list;

import core.util;

enum : bool {
	MinHeap = true,
	MaxHeap = false
}

interface HeapInterface(T, bool minHeap = MinHeap) {
	template add(R) {
		void add(R item);
	}

	T remove();

	void clear();
	bool empty();

	size_t length();
}

class PriorityQueue(T, bool minHeap = MinHeap) : HeapInterface!(T, minHeap) {

	this() {
		_length = 0;
	}

	template add(R) { 
		void add(R item) {

			// determine location for data:
			size_t idx = _length + 1;

			// check for bounds
			while (idx >= _data.length) {
				_resize();
			}

			// add data:

			static if (IsArray!(R)) {
				_data[idx] = item.dup;
			}
			else {
				_data[idx] = cast(T)item;
			}

			_length++;

			// bubble data up:
			_bubbleUp(idx);
		}
	}

	T remove() {
		T ret;

		if (empty()) {
			// XXX: Throw Tree Exception
			return ret;
		}

		ret = _data[1];

		// take last item, place at root:
		_data[1] = _data[_length];
		_length--;

		// bubble data down:
		_bubbleDown(1);

		// return saved temp
		return ret;
	}

	T peek() {
		T ret;

		if (empty()) {
			// XXX: Throw Tree Exception
			return ret;
		}

		return _data[1];
	}

	bool empty() {
		return _length == 0;
	}

	void clear() {
		_length = 0;
		_data = null;
	}

	size_t length() {
		return _length;
	}

protected:

	void _bubbleUp(size_t idx) {
		if (idx <= 1) {
			// base case
			return;
		}

		// get the parent, note the array is indexed at 1
		size_t parent = idx >> 1;

		// compare
		static if (minHeap) {
			if (_data[parent] > _data[idx]) {
				_swap(parent, idx);
				_bubbleUp(parent);
			}
		}
		else {
			if (_data[parent] < _data[idx]) {
				_swap(parent, idx);
				_bubbleUp(parent);
			}
		}
	}

	void _bubbleDown(size_t idx) {
		if (idx >= _length + 1) {
			// base case
			return;
		}


		size_t idx1, idx2, bestIdx;

		idx1 = idx << 1;
		idx2 = idx1 + 1;

		if (idx1 >= _length + 1) {
			// base case
			return;
		}

		// compare idx1 and idx2
		bestIdx = idx1;

		if (idx2 <= _length) {
			static if (minHeap) {
				if (_data[idx1] > _data[idx2]) {
					bestIdx = idx2;
				}
			}		
			else {
				if (_data[idx1] < _data[idx2]) {
					bestIdx = idx2;
				}
			}
		}

		// compare idx and bestIdx
		static if (minHeap) {
			if (_data[bestIdx] < _data[idx]) {
				_swap(bestIdx, idx);
				_bubbleDown(bestIdx);
			}
		}
		else {
			if (_data[bestIdx] > _data[idx]) {
				_swap(bestIdx, idx);
				_bubbleDown(bestIdx);
			}
		}
	}

	void _swap(size_t idx1, size_t idx2) {
		T tmp = _data[idx1];
		_data[idx1] = _data[idx2];
		_data[idx2] = tmp;
	}

	void _resize() {
		T[] temp = _data;
		if (_data.length == 0) {
			_data = new T[10];
		} 
		else {
			_data = new T[_data.length * 2];
		}
		_data[0..temp.length] = temp[0..$];
	}

	size_t _length;
	T[] _data;
}
