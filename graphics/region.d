module graphics.region;

import djehuty;

import graphics.contour;

import math.random;
import math.sign;
import math.log;
import math.round;

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

	static const int S_LEFT = 1;
	static const int S_RIGHT = 2;

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

	private int nextSegment = 0;
	private int _chooseSegment() {
		int ret = ordering[nextSegment];
		nextSegment++;
		return ret;
	}

	private int _mathN(int n, int h) {
		double v = n;
		for (int i = 0; i < h; i++) {
			v = Log.base2(v);
		}

		return cast(int)Round.ceiling(1.0 * cast(double)n / v);
	}

	private int _mathLogstarN(int n) {
		return 0;
	}

	/* Returns true if the corresponding endpoint of the given segment is */
	/* already inserted into the segment tree. Use the simple test of */
	/* whether the segment which shares this endpoint is already inserted */

	private bool _inserted(int segnum, int whichpt) {
		if (whichpt == FIRSTPT) {
			return segments[segments[segnum].prev].isInserted;
		}
		else {
			return segments[segments[segnum].next].isInserted;
		}
	}

	private bool _greaterThan(ref Coord v0, ref Coord v1) {
		if (v0.y > v1.y + C_EPS) {
			return true;
		}
		else if (v0.y < v1.y - C_EPS) {
			return false;
		}
		else {
			return (v0.x > v1.x);
		}
	}

	private bool _equalTo(ref Coord v0, ref Coord v1) {
		return (FP_EQUAL(v0.y, v1.y) && FP_EQUAL(v0.x, v1.x));
	}

	private bool _greaterThanEqualTo(ref Coord v0, ref Coord v1) {
		if (v0.y > v1.y + C_EPS) {
			return true;
		}
		else if (v0.y < v1.y - C_EPS) {
			return false;
		}
		else {
			return (v0.x >= v1.x);
		}
	}

	private bool _lessThan(ref Coord v0, ref Coord v1) {
		if (v0.y < v1.y - C_EPS) {
			return true;
		}
		else if (v0.y > v1.y + C_EPS) {
			return false;
		}
		else {
			return (v0.x < v1.x);
		}
	}

	/* Return TRUE if the vertex v is to the left of line segment no.
	 * segnum. Takes care of the degenerate cases when both the vertices
	 * have the same y--cood, etc.
	 */

	private bool _isLeftOf(int segnum, ref Coord v) {
		Segment *s = &segments[segnum];
		double area;

		if (_greaterThan(s.v1, s.v0)) {
			// seg. going upwards
			if (FP_EQUAL(s.v1.y, v.y)) {
				if (v.x < s.v1.x) {
					area = 1.0;
				}
				else {
					area = -1.0;
				}
			}
			else if (FP_EQUAL(s.v0.y, v.y)) {
				if (v.x < s.v0.x) {
					area = 1.0;
				}
				else {
					area = -1.0;
				}
			}
			else {
				area = (s.v1.x - s.v0.x);
				area = area * (v.y - s.v0.y);

				double tmp;
				tmp	= (s.v1.y - s.v0.y);
				tmp = tmp * (v.x - s.v0.x);

				area = area - tmp;
			}
		}
		else {				
			// v0 > v1
			if (FP_EQUAL(s.v1.y, v.y)) {
				if (v.x < s.v1.x) {
					area = 1.0;
				}
				else {
					area = -1.0;
				}
			}
			else if (FP_EQUAL(s.v0.y, v.y)) {
				if (v.x < s.v0.x) {
					area = 1.0;
				}
				else {
					area = -1.0;
				}
			}
			else {
				area = (s.v0.x - s.v1.x);
				area = area * (v.y - s.v1.y);

				double tmp;
				tmp	= (s.v0.y - s.v1.y);
				tmp = tmp * (v.x - s.v1.x);

				area = area - tmp;
			}
		}

		if (area > 0.0) {
			return true;
		}
		else {
			return false;
		}
	}

	/* This is query routine which determines which trapezoid does the 
	 * point v lie in. The return value is the trapezoid number. 
	 */

	private int _locateEndpoint(ref Coord v, ref Coord vo, int r) {
		Node *rptr = &querytree[r];

		switch (rptr.nodetype) {
			case T_SINK:
				return rptr.trnum;

			case T_Y:
				if (_greaterThan(v, rptr.yval)) {
					// Above
					return _locateEndpoint(v, vo, rptr.right);
				}
				else if (_equalTo(v, rptr.yval)) {
					// Point is already inserted
					if (_greaterThan(vo, rptr.yval)) {
						// Above
						return _locateEndpoint(v, vo, rptr.right);
					}
					else {
						return _locateEndpoint(v, vo, rptr.left);
					}
				}
				else {
					// Below
					return _locateEndpoint(v, vo, rptr.left);
				}

			case T_X:
				if (_equalTo(v, segments[rptr.segnum].v0) 
						|| _equalTo(v, segments[rptr.segnum].v1)) {
					if (FP_EQUAL(v.y, vo.y)) {
						// Horizontal Segment
						if (vo.x < v.x) {
							// Left
							return _locateEndpoint(v, vo, rptr.left);
						}
						else {
							// Right
							return _locateEndpoint(v, vo, rptr.right);
						}
					}
					else if (_isLeftOf(rptr.segnum, vo)) {
						// Left
						return _locateEndpoint(v, vo, rptr.left);
					}
					else {
						// Right
						return _locateEndpoint(v, vo, rptr.right);
					}
				}
				else if (_isLeftOf(rptr.segnum, v)) {
					// Left
					return _locateEndpoint(v, vo, rptr.left);
				}
				else {
					// Right
					return _locateEndpoint(v, vo, rptr.right);
				}

			default:

				// Error
				break;
		}
		return -1;
	}


	/* Thread in the segment into the existing trapezoidation. The 
	 * limiting trapezoids are given by tfirst and tlast (which are the
	 * trapezoids containing the two endpoints of the segment. Merges all
	 * possible trapezoids which flank this segment and have been recently
	 * divided because of its insertion
	 */

	private int _mergeTrapezoids(int segnum, int tfirst, int tlast, int side) {
		int t, tnext, cond;
		int ptnext;

		/* First merge polys on the LHS */
		t = tfirst;
		while ((t > 0) && _greaterThanEqualTo(trapezoids[t].lo, trapezoids[tlast].lo)) {
			if (side == S_LEFT) {
				tnext = trapezoids[t].d0;
				cond = tnext > 0 && trapezoids[tnext].rseg == segnum;
				if (!cond) {
					tnext = trapezoids[t].d1;
					cond = tnext > 0 && trapezoids[tnext].rseg == segnum;
				}
			}
			else {
				tnext = trapezoids[t].d0;
				cond = tnext > 0 && trapezoids[tnext].lseg == segnum;
				if (!cond) {
					tnext = trapezoids[t].d1;
					cond = tnext > 0 && trapezoids[tnext].lseg == segnum;
				}
			}

			if (cond) {
				if ((trapezoids[t].lseg == trapezoids[tnext].lseg)
						&& (trapezoids[t].rseg == trapezoids[tnext].rseg)) {

					// Good Neighbors

					// Use the upper node as the new node i.e. t

					ptnext = querytree[trapezoids[tnext].sink].parent;

					if (querytree[ptnext].left == trapezoids[tnext].sink) {
						querytree[ptnext].left = trapezoids[t].sink;
					}
					else {
						// Redirect parent

						querytree[ptnext].right = trapezoids[t].sink;	
					}


					// Change the upper neighbours of the lower trapezoids

					if ((trapezoids[t].d0 = trapezoids[tnext].d0) > 0) {
						if (trapezoids[trapezoids[t].d0].u0 == tnext) {
							trapezoids[trapezoids[t].d0].u0 = t;
						}
						else if (trapezoids[trapezoids[t].d0].u1 == tnext) {
							trapezoids[trapezoids[t].d0].u1 = t;
						}
					}

					if ((trapezoids[t].d1 = trapezoids[tnext].d1) > 0) {
						if (trapezoids[trapezoids[t].d1].u0 == tnext) {
							trapezoids[trapezoids[t].d1].u0 = t;
						}
						else if (trapezoids[trapezoids[t].d1].u1 == tnext) {
							trapezoids[trapezoids[t].d1].u1 = t;
						}
					}

					trapezoids[t].lo = trapezoids[tnext].lo;

					// Invalidate the lower trapezoid
					trapezoids[tnext].state = ST_INVALID;
				}
				else {		    
					// Not good neighbours
					t = tnext;
				}
			}
			else {		    
				t = tnext;
			}
		}

		return 0;
	}

	void _addSegment(int segment) {
		Segment s;
		Segment *so = &segments[segment];

		int tu, tl, sk, tfirst, tlast, tnext;
		int tfirstr, tlastr, tfirstl, tlastl;
		int i1, i2, t, t1, t2, tn;
		Coord tpt;
		bool tritop = false; 
		bool tribot = false;
		bool is_swapped = false;
		int tmptriseg;

		s = segments[segment];

		if (_greaterThan(s.v1, s.v0)) {
			// Get higher vertex in v0
			int tmp;

			tpt = s.v0;

			s.v0 = s.v1;
			s.v1 = tpt;

			tmp = s.root0;

			s.root0 = s.root1;
			s.root1 = tmp;

			is_swapped = true;
		}

		if ((is_swapped && !_inserted(segment, LASTPT))
				|| (!is_swapped && !_inserted(segment, FIRSTPT))) {
			int tmp_d;

			tu = _locateEndpoint(s.v0, s.v1, s.root0);

			// tl is the new lower trapezoid
			tl = newtrap();		

			trapezoids[tl].state = ST_VALID;
			trapezoids[tl] = trapezoids[tu];
			trapezoids[tu].lo.y = trapezoids[tl].hi.y = s.v0.y;
			trapezoids[tu].lo.x = trapezoids[tl].hi.x = s.v0.x;
			trapezoids[tu].d0 = tl;      
			trapezoids[tu].d1 = 0;
			trapezoids[tl].u0 = tu;
			trapezoids[tl].u1 = 0;

			tmp_d = trapezoids[tl].d0;
			if (tmp_d > 0 && trapezoids[tmp_d].u0 == tu) {
				trapezoids[tmp_d].u0 = tl;
			}

			tmp_d = trapezoids[tl].d0;
			if (tmp_d > 0 && trapezoids[tmp_d].u1 == tu) {
				trapezoids[tmp_d].u1 = tl;
			}

			tmp_d = trapezoids[tl].d1;
			if (tmp_d > 0 && trapezoids[tmp_d].u0 == tu) {
				trapezoids[tmp_d].u0 = tl;
			}

			tmp_d = trapezoids[tl].d1;
			if (tmp_d > 0 && trapezoids[tmp_d].u1 == tu) {
				trapezoids[tmp_d].u1 = tl;
			}

			/* Now update the query structure and obtain the sinks for the */
			/* two trapezoids */ 

			i1 = newnode();		/* Upper trapezoid sink */
			i2 = newnode();		/* Lower trapezoid sink */
			sk = trapezoids[tu].sink;

			querytree[sk].nodetype = T_Y;
			querytree[sk].yval = s.v0;
			querytree[sk].segnum = segment;	/* not really reqd ... maybe later */
			querytree[sk].left = i2;
			querytree[sk].right = i1;

			querytree[i1].nodetype = T_SINK;
			querytree[i1].trnum = tu;
			querytree[i1].parent = sk;

			querytree[i2].nodetype = T_SINK;
			querytree[i2].trnum = tl;
			querytree[i2].parent = sk;

			trapezoids[tu].sink = i1;
			trapezoids[tl].sink = i2;
			tfirst = tl;
		}
		else {				
			// v0 already present

			// Get the topmost intersecting trapezoid
			tfirst = _locateEndpoint(s.v0, s.v1, s.root0);
			tritop = true;
		}


		if ((is_swapped && !_inserted(segment, FIRSTPT))
				|| (!is_swapped && !_inserted(segment, LASTPT))) {

			// Insert v1 in the tree
			int tmp_d;

			tu = _locateEndpoint(s.v1, s.v0, s.root1);

			tl = newtrap();		/* tl is the new lower trapezoid */
			trapezoids[tl].state = ST_VALID;
			trapezoids[tl] = trapezoids[tu];
			trapezoids[tu].lo.y = trapezoids[tl].hi.y = s.v1.y;
			trapezoids[tu].lo.x = trapezoids[tl].hi.x = s.v1.x;
			trapezoids[tu].d0 = tl;      
			trapezoids[tu].d1 = 0;
			trapezoids[tl].u0 = tu;
			trapezoids[tl].u1 = 0;

			tmp_d = trapezoids[tl].d0;
			if (tmp_d > 0 && trapezoids[tmp_d].u0 == tu) {
				trapezoids[tmp_d].u0 = tl;
			}

			tmp_d = trapezoids[tl].d0;
			if (tmp_d > 0 && trapezoids[tmp_d].u1 == tu) {
				trapezoids[tmp_d].u1 = tl;
			}

			tmp_d = trapezoids[tl].d1;
			if (tmp_d > 0 && trapezoids[tmp_d].u0 == tu) {
				trapezoids[tmp_d].u0 = tl;
			}

			tmp_d = trapezoids[tl].d1;
			if (tmp_d > 0 && trapezoids[tmp_d].u1 == tu) {
				trapezoids[tmp_d].u1 = tl;
			}

			/* Now update the query structure and obtain the sinks for the */
			/* two trapezoids */ 

			i1 = newnode();		/* Upper trapezoid sink */
			i2 = newnode();		/* Lower trapezoid sink */
			sk = trapezoids[tu].sink;

			querytree[sk].nodetype = T_Y;
			querytree[sk].yval = s.v1;
			querytree[sk].segnum = segment;	/* not really reqd ... maybe later */
			querytree[sk].left = i2;
			querytree[sk].right = i1;

			querytree[i1].nodetype = T_SINK;
			querytree[i1].trnum = tu;
			querytree[i1].parent = sk;

			querytree[i2].nodetype = T_SINK;
			querytree[i2].trnum = tl;
			querytree[i2].parent = sk;

			trapezoids[tu].sink = i1;
			trapezoids[tl].sink = i2;
			tlast = tu;
		}
		else {
			// v1 already present

			// Get the lowermost intersecting trapezoid

			tlast = _locateEndpoint(s.v1, s.v0, s.root1);
			tribot = true;
		}

		/* Thread the segment into the query tree creating a new X-node */
		/* First, split all the trapezoids which are intersected by s into */
		/* two */

		t = tfirst;			/* topmost trapezoid */

		while ((t > 0) && _greaterThanEqualTo(trapezoids[t].lo, trapezoids[tlast].lo)) {
			// Traverse from top to bottom

			int t_sav, tn_sav;
			sk = trapezoids[t].sink;

			// left trapezoid sink
			i1 = newnode();		

			// right trapezoid sink
			i2 = newnode();		

			querytree[sk].nodetype = T_X;
			querytree[sk].segnum = segment;
			querytree[sk].left = i1;
			querytree[sk].right = i2;

			// Left trapezoid (use existing one)
			querytree[i1].nodetype = T_SINK;	
			querytree[i1].trnum = t;
			querytree[i1].parent = sk;

			// Right trapezoid (allocate new)
			querytree[i2].nodetype = T_SINK;	
			querytree[i2].trnum = tn = newtrap();
			trapezoids[tn].state = ST_VALID;
			querytree[i2].parent = sk;

			if (t == tfirst) {
				tfirstr = tn;
			}

			if (_equalTo(trapezoids[t].lo, trapezoids[tlast].lo)) {
				tlastr = tn;
			}

			trapezoids[tn] = trapezoids[t];
			trapezoids[t].sink = i1;
			trapezoids[tn].sink = i2;
			t_sav = t;
			tn_sav = tn;

			// Check for errors

			if ((trapezoids[t].d0 <= 0) && (trapezoids[t].d1 <= 0)) {
				// Error : Case cannot arise
				break;
			}
			else if ((trapezoids[t].d0 > 0) && (trapezoids[t].d1 <= 0)) {
				// Only one trapezoid below. 

				// Partition t into two and make the two resulting trapezoids
				// (t and tn) as the upper neighbours of the sole lower trapezoid

				if ((trapezoids[t].u0 > 0) && (trapezoids[t].u1 > 0)) {
					// Continuation of a chain from abv.

					if (trapezoids[t].usave > 0) {
						// three upper neighbours

						if (trapezoids[t].uside == S_LEFT) {
							// Intersects in the left

							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;
							trapezoids[trapezoids[tn].u1].d0 = tn;
						}
						else {	
							// Intersects in the right
						
							trapezoids[tn].u1 = -1;
							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = trapezoids[t].u0;
							trapezoids[t].u0 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[t].u1].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;		      
						}

						trapezoids[t].usave = trapezoids[tn].usave = 0;
					}
					else {		
						// No usave (Simple Case)

						trapezoids[tn].u0 = trapezoids[t].u1;
						trapezoids[t].u1 = -1;
						trapezoids[tn].u1 = -1;
						trapezoids[trapezoids[tn].u0].d0 = tn;
					}
				}
				else  {
					// Fresh segment or upward cusp

					int tmp_u = trapezoids[t].u0;
					int td0, td1;

					td0 = trapezoids[tmp_u].d0;
					td1 = trapezoids[tmp_u].d1;
					if (td0 > 0 && td1 > 0) {
						// Upward cusp

						if (trapezoids[td0].rseg > 0 &&	!_isLeftOf(trapezoids[td0].rseg, s.v1)) {
							// Cusp going rightwards
							trapezoids[t].u0 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[trapezoids[tn].u0].d1 = tn;
						}
						else {		
							// Cusp going leftwards
							trapezoids[tn].u0 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[trapezoids[t].u0].d0 = t;
						}
					}
					else {		
						// Fresh Segment
						trapezoids[trapezoids[t].u0].d0 = t;
						trapezoids[trapezoids[t].u0].d1 = tn;
					}	      
				}

				if (FP_EQUAL(trapezoids[t].lo.y, trapezoids[tlast].lo.y) 
						&& FP_EQUAL(trapezoids[t].lo.x, trapezoids[tlast].lo.x) 
						&& tribot) {

					// Bottom forms a triangle

					if (is_swapped)	{
						tmptriseg = segments[segment].prev;
					}
					else {
						tmptriseg = segments[segment].next;
					}

					if ((tmptriseg > 0) && _isLeftOf(tmptriseg, s.v0)) {
						// Left to Right downward cusp
						trapezoids[trapezoids[t].d0].u0 = t;
						trapezoids[tn].d0 = -1;
						trapezoids[tn].d1 = -1;
					}
					else {
						// Right to Left downward cusp
						trapezoids[trapezoids[tn].d0].u1 = tn;
						trapezoids[t].d0 = -1;
						trapezoids[t].d1 = -1;
					}
				}
				else {
					if ((trapezoids[trapezoids[t].d0].u0 > 0) && (trapezoids[trapezoids[t].d0].u1 > 0)) {
						if (trapezoids[trapezoids[t].d0].u0 == t) {
							// Passes thru Left-hand side
							trapezoids[trapezoids[t].d0].usave = trapezoids[trapezoids[t].d0].u1;
							trapezoids[trapezoids[t].d0].uside = S_LEFT;
						}
						else {
							// Passes thru Right-hand side
							trapezoids[trapezoids[t].d0].usave = trapezoids[trapezoids[t].d0].u0;
							trapezoids[trapezoids[t].d0].uside = S_RIGHT;
						}		    
					}

					trapezoids[trapezoids[t].d0].u0 = t;
					trapezoids[trapezoids[t].d0].u1 = tn;
				}

				t = trapezoids[t].d0;
			}


			else if ((trapezoids[t].d0 <= 0) && (trapezoids[t].d1 > 0)) {
				// Only one trapezoid below
				if ((trapezoids[t].u0 > 0) && (trapezoids[t].u1 > 0)) {
					// Continuation of a chain from abv.
					if (trapezoids[t].usave > 0) {
						// Three upper neighbours
						if (trapezoids[t].uside == S_LEFT) {
							// Intersects in the left
							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;
							trapezoids[trapezoids[tn].u1].d0 = tn;
						}
						else {		
							// Intersects in the right
							trapezoids[tn].u1 = -1;
							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = trapezoids[t].u0;
							trapezoids[t].u0 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[t].u1].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;		      
						}

						trapezoids[t].usave = 0;
						trapezoids[tn].usave = 0;
					}
					else {		
						// No usave (Simple Case)
						trapezoids[tn].u0 = trapezoids[t].u1;
						trapezoids[t].u1 = -1;
						trapezoids[tn].u1 = -1;
						trapezoids[trapezoids[tn].u0].d0 = tn;
					}
				}
				else {
					// Fresh segment or upward cusp
					int tmp_u = trapezoids[t].u0;
					int td0, td1;

					td0 = trapezoids[tmp_u].d0;
					td1 = trapezoids[tmp_u].d1;
					if (td0 > 0 && td1 > 0) {
						// Upward cusp

						if ((trapezoids[td0].rseg > 0) && !_isLeftOf(trapezoids[td0].rseg, s.v1)) {
							trapezoids[t].u0 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[trapezoids[tn].u0].d1 = tn;
						}
						else {
							trapezoids[tn].u0 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[trapezoids[t].u0].d0 = t;
						}
					}
					else {	
						// Fresh segment
						trapezoids[trapezoids[t].u0].d0 = t;
						trapezoids[trapezoids[t].u0].d1 = tn;
					}
				}

				if (FP_EQUAL(trapezoids[t].lo.y, trapezoids[tlast].lo.y) 
						&& FP_EQUAL(trapezoids[t].lo.x, trapezoids[tlast].lo.x) 
						&& tribot) {

					// Bottom forms a triangle
					int tmpseg;

					if (is_swapped)	{
						tmptriseg = segments[segment].prev;
					}
					else {
						tmptriseg = segments[segment].next;
					}

					if ((tmpseg > 0) && _isLeftOf(tmpseg, s.v0)) {
						// Left to Right downward cusp
						trapezoids[trapezoids[t].d1].u0 = t;
						trapezoids[tn].d0 = -1;
						trapezoids[tn].d1 = -1;
					}
					else {
						// Right to Left downward cusp
						trapezoids[trapezoids[tn].d1].u1 = tn;
						trapezoids[t].d0 = -1;
						trapezoids[t].d1 = -1;
					}
				}		
				else {
					if ((trapezoids[trapezoids[t].d1].u0 > 0) && (trapezoids[trapezoids[t].d1].u1 > 0)) {
						if (trapezoids[trapezoids[t].d1].u0 == t) {
							// Passes thru Left-hand side
							trapezoids[trapezoids[t].d1].usave = trapezoids[trapezoids[t].d1].u1;
							trapezoids[trapezoids[t].d1].uside = S_LEFT;
						}
						else {
							trapezoids[trapezoids[t].d1].usave = trapezoids[trapezoids[t].d1].u0;
							trapezoids[trapezoids[t].d1].uside = S_RIGHT;
						}		    
					}

					trapezoids[trapezoids[t].d1].u0 = t;
					trapezoids[trapezoids[t].d1].u1 = tn;
				}

				t = trapezoids[t].d1;
			}
			else {
				// Two trapezoids below.

				// Find out which one is intersected by this segment and 
				// proceed down that particular one

				int tmpseg = trapezoids[trapezoids[t].d0].rseg;

				double y0, yt;
				Coord tmppt;

				int tnext2;

				bool i_d0, i_d1;

				if (FP_EQUAL(trapezoids[t].lo.y, s.v0.y)) {
					if (trapezoids[t].lo.x > s.v0.x) {
						i_d0 = true;
					}
					else { 
						i_d1 = true;
					}
				}
				else {
					tmppt.y = y0 = trapezoids[t].lo.y;
					yt = (y0 - s.v0.y)/(s.v1.y - s.v0.y);
					tmppt.x = s.v0.x + yt * (s.v1.x - s.v0.x);

					if (_lessThan(tmppt, trapezoids[t].lo)) {
						i_d0 = true;
					}
					else {
						i_d1 = true;
					}
				}

				// Check continuity from the top so that the lower-neighbor 
				// values are properly filled for the upper trapezoid

				if ((trapezoids[t].u0 > 0) && (trapezoids[t].u1 > 0)) {
					// Continuation of a chain from abv.
					if (trapezoids[t].usave > 0) {
						// Three upper neighbors
						if (trapezoids[t].uside == S_LEFT) {
							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;
							trapezoids[trapezoids[tn].u1].d0 = tn;
						}
						else {		
							// Intersects in the right
							trapezoids[tn].u1 = -1;
							trapezoids[tn].u0 = trapezoids[t].u1;
							trapezoids[t].u1 = trapezoids[t].u0;
							trapezoids[t].u0 = trapezoids[t].usave;

							trapezoids[trapezoids[t].u0].d0 = t;
							trapezoids[trapezoids[t].u1].d0 = t;
							trapezoids[trapezoids[tn].u0].d0 = tn;		      
						}

						trapezoids[t].usave = 0;
						trapezoids[tn].usave = 0;
					}
					else {		
						// No usave (Simple Case)

						trapezoids[tn].u0 = trapezoids[t].u1;
						trapezoids[tn].u1 = -1;
						trapezoids[t].u1 = -1;
						trapezoids[trapezoids[tn].u0].d0 = tn;
					}
				}
				else {
					// Fresh segment or upward cusp

					int tmp_u = trapezoids[t].u0;
					int td0, td1;

					td0 = trapezoids[tmp_u].d0;
					td1 = trapezoids[tmp_u].d1;
					if (td0 > 0 && td1 > 0) {
						// Upward cusp
						if ((trapezoids[td0].rseg > 0) && !_isLeftOf(trapezoids[td0].rseg, s.v1)) {
							trapezoids[t].u0 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[trapezoids[tn].u0].d1 = tn;
						}
						else {
							trapezoids[tn].u0 = -1;
							trapezoids[tn].u1 = -1;
							trapezoids[t].u1 = -1;
							trapezoids[trapezoids[t].u0].d0 = t;
						}
					}
					else {	
						// Fresh segment 
						trapezoids[trapezoids[t].u0].d0 = t;
						trapezoids[trapezoids[t].u0].d1 = tn;
					}
				}

				if (FP_EQUAL(trapezoids[t].lo.y, trapezoids[tlast].lo.y) 
						&& FP_EQUAL(trapezoids[t].lo.x, trapezoids[tlast].lo.x) 
						&& tribot) {

					// This case arises only at the lowest trapezoid.. 
					// (i.e. tlast), if the lower endpoint of the segment is
					// already inserted in the structure

					trapezoids[trapezoids[t].d0].u0 = t;
					trapezoids[trapezoids[t].d0].u1 = -1;
					trapezoids[trapezoids[t].d1].u0 = tn;
					trapezoids[trapezoids[t].d1].u1 = -1;

					trapezoids[tn].d0 = trapezoids[t].d1;
					trapezoids[t].d1 = -1;
					trapezoids[tn].d1 = -1;

					tnext2 = trapezoids[t].d1;	      
				}
				else if (i_d0) {
					// Intersecting d0
					trapezoids[trapezoids[t].d0].u0 = t;
					trapezoids[trapezoids[t].d0].u1 = tn;
					trapezoids[trapezoids[t].d1].u0 = tn;
					trapezoids[trapezoids[t].d1].u1 = -1;

					// new code to determine the bottom neighbours of the
					// newly partitioned trapezoid

					trapezoids[t].d1 = -1;

					tnext2 = trapezoids[t].d0;
				}
				else {			
					// Intersecting d1
					trapezoids[trapezoids[t].d0].u0 = t;
					trapezoids[trapezoids[t].d0].u1 = -1;
					trapezoids[trapezoids[t].d1].u0 = t;
					trapezoids[trapezoids[t].d1].u1 = tn;

					// new code to determine the bottom neighbours of the
					// newly partitioned trapezoid

					trapezoids[tn].d0 = trapezoids[t].d1;
					trapezoids[tn].d1 = -1;

					tnext2 = trapezoids[t].d1;
				}	    

				t = tnext2;
			}

			trapezoids[t_sav].rseg = segment;
			trapezoids[tn_sav].lseg = segment;
		}

		// Now combine those trapezoids which share common segments. 
	
		//We can use the pointers to the parent to connect these together. 

		// This works only because all these new trapezoids have been formed
		// due to splitting by the segment, and hence have only one parent.

		tfirstl = tfirst; 
		tlastl = tlast;

		_mergeTrapezoids(segment, tfirstl, tlastl, S_LEFT);
		_mergeTrapezoids(segment, tfirstr, tlastr, S_RIGHT);

		segments[segment].isInserted = true;
	}

	void _findNewRoots(int segment) {
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

	private bool FP_EQUAL(double x, double y) {
		return Sign.abs(x - y) <= C_EPS;
	}

	private Coord _max(ref Coord v0, ref Coord v1) {
		if (v0.y > v1.y + C_EPS) {
			return v0;
		}
		else if (Sign.abs(v0.y - v1.y) <= C_EPS) {
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
		else if (Sign.abs(v0.y - v1.y) <= C_EPS) {
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

		for (int i = _mathN(n, _mathLogstarN(n)) + 1; i <= n; i++) {
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