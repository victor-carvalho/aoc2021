void runModule(string moduleName)() {
	mixin("import ", moduleName, ": run; run();");
}

void main() {
	runModule!("puzzles.day1");
}
