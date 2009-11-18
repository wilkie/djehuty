/*
 * fibonacci.d
 *
 * This is an implementation of a Fibonacci Heap.
 *
 * Worst Case: (amortized)
 * Insert: 			O(1)
 * Access: 			O(1)
 * Delete: 			O(log n)
 * Decrease Key:	O(1)
 * Merge:			O(1)
 *
 * Author: Dave Wilkinson
 * Originated: November 8th, 2009
 * References: Fredman M. L. & Tarjan R. E. (1987). Fibonacci heaps and 
 *   their uses in improved network optimization algorithms. Journal of 
 *   the ACM 34(3), 596-615.
 *
 */

module utils.fibonacci;

import core.util;

import utils.heap;

class FibonacciHeap(T, bool minHeap = true) : HeapInterface!(T, minHeap) {

	this() {
	}

	template add(R) {
		void add(R item) {
			Node rootNode = new Node();
			static if (IsArray!(R)) {
				rootNode.data = item.dup;
			}
			else {
				rootNode.data = cast(T)item;
			}

			rootNode.parent = null;
			rootNode.left = rootNode;
			rootNode.right = rootNode;
			rootNode.child = null;

			if (_length == 0) {
				_min = rootNode;
			}
			else {
				rootNode.left = _min.left;
				rootNode.right = _min;
				_min.left.right = rootNode;
				_min.left = rootNode;

				_min = _minData(rootNode, _min);
			}

			_length++;
		}
	}

	T remove() { // delete_min operation
		T ret;
		if (_length == 0) {
			// XXX: Throw Tree Exception
			return ret;
		}

		// Grab value
		ret = _min.data;

		_length--;

		// Unlink the min from the root cycle
		if (_length == 0) {
			// Empty list
			_min = null;
			_marked = 0;
			_maxrank = 0;
			return ret;
		}
		// Join _min's children to the root list
		Node curChild = _min.child;
		if (curChild !is null) {
			do {
				_min.left.right = curChild;
				curChild.left = _min.left;
				_min.left = curChild;
				Node tmp = curChild.right;
				curChild.right = _min;

				curChild = tmp;
			} while(curChild !is _min.child);
		}

		// Remove _min from the root list
		_min.left.right = _min.right;
		_min.right.left = _min.left;
		
		Node startNode = _min.right;

		_min = startNode;

		// Link trees with equal rank
		if (_length == 0) { return ret; }

		Node[] nodeList = new Node[_length + 2];
		
		// loop through each root

		// place the root in the list indexed by its rank
		// if there is already a root there, link them, rooted
		// by the minimum value.

		// Attempt then to place the new root into the next slot.
		
		Node curRoot = startNode;

		do {
			Node nextNode = curRoot.right;

			// Check the list for a spot that is already filled
			// This means two roots have the same rank
			// We will link those together, making one the child
			// of the other, where the new root is the minimum
			// value (for a MinHeap)
			while (nodeList[curRoot.rank] !is null) {
				// Link the two roots
				Node coRoot = nodeList[curRoot.rank];

				nodeList[curRoot.rank] = null;

				Node newRoot = _minData(coRoot, curRoot);
				if (newRoot is coRoot) {
					coRoot = curRoot;
				}

				// Make sure start node is still true
				if (coRoot is startNode && nextNode !is startNode) {
					startNode = coRoot.right;
				}

				// remove coRoot as a root
				coRoot.left.right = coRoot.right;
				coRoot.right.left = coRoot.left;

				// place coRoot as newRoot's child
				// updata newRoot's rank
				coRoot.parent = newRoot;
				if (newRoot.child is null) {
					// The new root has no prior children
					newRoot.child = coRoot;
					coRoot.left = coRoot;
					coRoot.right = coRoot;
				}
				else {
					// The new root has to insert a new child node.
					coRoot.left = newRoot.child;
					coRoot.right = newRoot.child.right;
					newRoot.child.right.left = coRoot;
					newRoot.child.right = coRoot;
				}
				// Increase the rank of the new root
				newRoot.rank++;

				// Note the maximum rank of the heap.
				if (_maxrank < newRoot.rank) {
					_maxrank = newRoot.rank;
				}
				curRoot = newRoot;

				// In the next round, the algorithm will attempt
				// to re-add this root to the list with the updated
				// rank.
			}

			nodeList[curRoot.rank] = curRoot;

			_min = _minData(curRoot, _min);

			curRoot = nextNode;
		} while (curRoot !is startNode);

		return ret;
	}

	T peek() {
		return _min.data;
	}

	void clear() {
		_length = 0;
		_marked = 0;
		_min = null;
	}

	size_t length() {
		return _length;
	}

	bool empty() {
		return _length == 0;
	}

protected:

	// Each node stores a value which can derive the degree
	// and then pointers to allow the trees to be doubly-linked
	// in a cycle.
	class Node {
		Node left;
		Node right;

		Node child;
		Node parent;

		T data;

		size_t rank;
		bool marked;
	}

	size_t _length;
	size_t _marked;
	size_t _maxrank;

	// The minimum value is stored with a pointer to the node with
	// the minimum degree.
	Node _min;

	Node _minData(Node x, Node y) {
		static if (minHeap == true) {
			if (x.data < y.data) {
				return x;
			}
		}
		else {
			if (x.data > y.data) {
				return x;
			}
		}
		return y;
	}

	void _merge(FibonacciHeap!(T, minHeap) heap) {
		if (_min is null) {
			_min = heap._min;
			_marked = heap._marked;
			_length = heap._length;
			_maxrank = heap._maxrank;
			return;
		}

		Node head1, head2, tail1, tail2;

		_min.right.left = heap._min.left;
		heap._min.left.right = _min.right;

		_min.right = heap._min;
		heap._min.left = _min;

		// cut the lists
		Node min1, min2;
		min1 = _min;
		min2 = heap._min;

		// choose the new minimum:
		_min = _minData(min1, min2);
		
		_length += heap._length;
		_marked += heap._marked;
		if (heap._maxrank > _maxrank) {
			_maxrank = heap._maxrank;
		}

		heap.clear();
	}
}
