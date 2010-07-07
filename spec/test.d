module spec.test;

import djehuty;

import spec.modulespecification;
import spec.packagespecification;
import spec.itemspecification;
import spec.specification;

class Test {
private:

	void _run(Test original, string padding = "") {
		if (_ps !is null) {
			// Run all packages and modules in package specification
			foreach(PackageSpecification ps; _ps) {
				Test test = new Test(ps);
				test._run(original, padding ~ "  ");
			}

			foreach(ModuleSpecification ms; _ps) {
				Test test = new Test(ms);
				test._run(original, padding ~ "  ");
			}
		}
		else if (_ms !is null) {
			// Run all items in module specification
			foreach(ItemSpecification item; _ms) {
				Test test = new Test(item);
				test._run(original, padding ~ "  ");
			}
		}
		else if (_item !is null) {
			if (_feature !is null) {
				if (_item.test(_feature)) {
					original._numSuccess++;
				}
				else {
					original._numFail++;
				}
			}
			else {
				// Run all requirements in item specification
				foreach(item; _item) {
					if (_item.test(item)) {
						original._numSuccess++;
					}
					else {
						original._numFail++;
					}
				}
			}
		}
		else {
			// Run all packages in Specification
			foreach(PackageSpecification ps; Specification) {
				Test test = new Test(ps);
				test._run(original, padding ~ "  ");
			}
		}
	}

	int _numSuccess;
	int _numFail;

	ModuleSpecification _ms;
	PackageSpecification _ps;
	ItemSpecification _item;

	string _feature;

public:

	this(PackageSpecification ps) {
		_ps = ps;
	}

	this(ModuleSpecification ms) {
		_ms = ms;
	}

	this(ItemSpecification item, string feature = null) {
		_item = item;
		_feature = feature;
	}

	this() {
	}

	bool test(string name) {
		if (_ps !is null) {
			Test test;
			PackageSpecification ps = _ps.traverse(name);
			if (ps is null) {
				ModuleSpecification ms = _ps.retrieve(name);
				if (ms is null) {
					throw new Exception("Unknown Test :" ~ name);
				}
				test = new Test(ms);
			}
			else {
				test = new Test(ps);
			}
			test.run();
		}
		else if (_ms !is null) {
			ItemSpecification item = _ms.retrieve(name);
			
			if (item is null) {
				throw new Exception("Unknown Test @" ~ name);
			}
			Test test = new Test(item);
			test.run();
		}
		else if (_item !is null) {
			return _item.test(name);
		}
		else {
			// Off of Specification
			PackageSpecification ps = Specification.traverse(name);
			if (ps is null) {
				throw new Exception("Unknown Test #" ~ name);
			}
			Test test = new Test(ps);
			test.run();
		}
		return true;
	}

	void run() {
		_run(this);
	}

	int successes() {
		return _numSuccess;
	}

	int failures() {
		return _numFail;
	}

private:
static:

	bool _inRun;
}

