module graphics.region;

import djehuty;

import graphics.contour;

import math.random;
import math.abs;
import math.log2;

class Region {
private:
	Contour[] _contours;

public:
	this() {
	}

	// Properties

	Contour[] contours() {
		return _contours;
	}

	void contours(Contour[] value) {
		_contours = value;
	}

	// Methods

	void addContour(Contour contour) {
		_contours ~= contour;
	}

	private struct Segment {
		Coord v0, v1;

		bool isInserted;
		int root0, root1;
		int next, prev;
	}

	private struct Trapezoid {
		int lseg = -1;
		int rseg = -1;
		Coord hi, lo;
		int u0, u1;
		int d0, d1;
		int sink;
		int usave, uside;
		int state = ST_VALID;
	}

	private struct Node {
		int nodetype;
		int segnum;
		Coord yval;
		int trnum;
		int parent;
		int left, right;
	}

	private struct MonotoneChain {
		int vnum;
		int next;
		int prev;
		int marked;
	}

	private struct VertexChain {
		Coord pt;
		int[4] vnext;
		int[4] vpos;
		int nextfree;
	}

	static const int FIRSTPT = 1;
	static const int LASTPT = 2;

	static const int ST_VALID = 1;
	static const int ST_INVALID = 2;

	static const double C_EPS = 1.0e-7;

	static const int T_X = 1;
	static const int T_Y = 2;
	static const int T_SINK = 3;

	private Node[] querytree;
	private Trapezoid[] trapezoids;
	private Segment[] segments;

	private void _initialize() {
		_generateRandomOrdering();
	}

	int[] ordering;

	private void _generateRandomOrdering() {
		int n = segments.length-1;

		ordering = new int[n+1];

		Random r = new Random();

		int[] st = new int[n+1];

		for (int i = 0; i <= n; i++) {
			st[i] = i;
		}

		for (int i = 1; i <= n; i++) {
			size_t m = cast(size_t)(cast(ulong)r.nextLong() % cast(ulong)(n + 1 - i) + cast(ulong)1);

			ordering[i] = st[i+m-1];
			if (m != 1) {
				st[i+m-1] = st[i];
			}
		}
	}

	int nextSegment = 0;
	int _chooseSegment() {
		int ret = ordering[nextSegment];
		nextSegment++;
		return ret;
	}

	int _mathN(int n, int h) {
		double v = n;
		for (int i = 0; i < h; i++) {
			v = log2(v);
		}

		return cast(int)ceil(1.0 * cast(double)n / v);
	}

	int _mathLogstarN(int n, int h) {
		return 0;
	}

	void _triangulatePolygon(int[] pointsPerContour, Coord[] vertices) {
		int sum = 0;
		foreach(element; pointsPerContour) {
			sum += element;
		}
		segments = new Segment[sum+1];

		size_t ccount = 0;
		int i = 1;
		int n = 0;
		while(ccount < pointsPerContour.length) {
			auto npoints = pointsPerContour[ccount];
			auto first = i;
			auto last = first + npoints - 1;

			for (int j = 0; j < npoints; j++, i++) {
				segments[i].v0 = vertices[i];

				if (i == last) {
					segments[i].next = first;
					segments[i].prev = i-1;
					segments[i-1].v1 = segments[i].v0;
				}
				else if (i == first) {
					segments[i].next = i+1;
					segments[i].prev = last;
					segments[last].v1 = segments[i].v0;
				}
				else {
					segments[i].next = i+1;
					segments[i].prev = i-1;
					segments[i-1].v1 = segments[i].v0;
				}
			}
			
			ccount++;
		}

		n = i-1;

		querytree = new Node[8 * (segments.length-1)];
		trapezoids = new Trapezoid[4 * (segments.length-1)];

		_generateRandomOrdering();

		_constructTrapezoids();
	}

	int q_idx;
	int tr_idx;

	private int newnode() {
		if (q_idx < querytree.length) {
			return q_idx++;
		}
		else {
			return -1;
		}
	}

	private int newtrap() {
		if (tr_idx < trapezoids.length) {
			return tr_idx++;
		}
		else {
			return -1;
		}
	}

	private Coord _max(ref Coord v0, ref Coord v1) {
		if (v0.y > v1.y + C_EPS) {
			return v0;
		}
		else if (abs(v0.y - v1.y) <= C_EPS) {
			if (v0.x > v1.x + C_EPS) {
				return v0;
			}
			else {
				return v1;
			}
		}
		else {
			return v1;
		}
	}

	private Coord _min(ref Coord v0, ref Coord v1) {
		if (v0.y < v1.y + C_EPS) {
			return v0;
		}
		else if (abs(v0.y - v1.y) <= C_EPS) {
			// XXX: Plus C_EPS?!?
			if (v0.x < v1.x) {
				return v0;
			}
			else {
				return v1;
			}
		}
		else {
			return v1;
		}
	}

	private int _initQueryStructure(int segment) {
		int i1, i2, i3, i4, i5, i6, i7, root;
		int t1, t2, t3, t4;

		q_idx = 1;
		tr_idx = 1;

		i1 = newnode();
		querytree[i1].nodetype = T_Y;
		querytree[i1].yval = _max(segments[segment].v0, segments[segment].v1);

		root = i1;

		i2 = newnode();
		querytree[i1].right = i2;
		querytree[i2].nodetype = T_SINK;
		querytree[i2].parent = i1;

		i3 = newnode();
		querytree[i1].left = i3;
		querytree[i3].nodetype = T_Y;
		querytree[i3].yval = _min(segments[segment].v0, segments[segment].v1);
		querytree[i3].parent = i1;

		i4 = newnode();
		querytree[i3].left = i4;
		querytree[i4].nodetype = T_SINK;
		querytree[i4].parent = i3;

		i5 = newnode();
		querytree[i3].right = i5;
		querytree[i5].nodetype = T_X;
		querytree[i5].segnum = segment;
		querytree[i5].parent = i3;

		i6 = newnode();
		querytree[i5].left = i6;
		querytree[i6].nodetype = T_SINK;
		querytree[i6].parent = i5;

		i7 = newnode();
		querytree[i5].right = i7;
		querytree[i7].nodetype = T_SINK;
		querytree[i7].parent = i5;

		t1 = newtrap();
		t2 = newtrap();
		t3 = newtrap();
		t4 = newtrap();

		trapezoids[t4].lo = querytree[i1].yval;
		trapezoids[t2].hi = querytree[i1].yval;
		trapezoids[t1].hi = querytree[i1].yval;

		trapezoids[t3].hi = querytree[i3].yval;
		trapezoids[t2].lo = querytree[i3].yval;
		trapezoids[t1].lo = querytree[i3].yval;

		trapezoids[t4].hi.y = cast(double)int.max;
		trapezoids[t4].hi.x = cast(double)int.max;
		trapezoids[t3].lo.y = cast(double)int.min;
		trapezoids[t3].lo.x = cast(double)int.min;

		trapezoids[t1].rseg = segment;
		trapezoids[t2].lseg = segment;

		trapezoids[t1].u0 = t4;
		trapezoids[t2].u0 = t4;
		trapezoids[t1].d0 = t3;
		trapezoids[t2].d0 = t3;
		trapezoids[t4].d0 = t1;
		trapezoids[t3].u0 = t1;

		trapezoids[t1].sink = i6;
		trapezoids[t2].sink = i7;
		trapezoids[t3].sink = i4;
		trapezoids[t4].sink = i2;

		trapezoids[t1].state = ST_VALID;
		trapezoids[t2].state = ST_VALID;
		trapezoids[t3].state = ST_VALID;
		trapezoids[t4].state = ST_VALID;

		querytree[i2].trnum = t4;
		querytree[i4].trnum = t3;
		querytree[i6].trnum = t1;
		querytree[i7].trnum = t2;

		segments[segment].isInserted = true;

		return root;
	}

	private void _constructTrapezoids() {
		int n = segments.length-1;

		int root = _initQueryStructure(_chooseSegment());

		for (int i = 1; i <= n; i++) {
			segments[i].root0 = root;
			segments[i].root1 = root;
		}

		for (int h = 1; h <= _mathLogstarN(n); h++) {
			for (int i = _mathN(n, h - 1) + 1; i <= _mathN(n, h); i++) {
				_addSegment(_chooseSegment());
			}

			for (int i = 1; i <= n; i++) {
				_findNewRoots(i);
			}
		}

		for (int i = mathN(n, _mathLogstarN(n)) + 1; i <= n; i++) {
			_addSegment(_chooseSegment());
		}
	}

	Triangle[] tessellate() {
		if (_contours.length == 0) {
			return null;
		}

		return null;
	}
}
