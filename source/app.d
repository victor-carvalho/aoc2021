import std.array;
import std.stdio;

enum lastDay = 2;

string[] buildDaysList() {
	assert(__ctfe);
	import std.conv: text;

	auto app = appender!(string[]);
	app.reserve(lastDay);
	foreach (i; 1..lastDay+1) {
		app ~= text("day", i);
	}
	return app[];
}

static immutable string[] daysList = buildDaysList();

void runModule(string moduleName)() {
	import std.uni: asCapitalized;
	mixin("import puzzles.", moduleName, ": firstPuzzle, secondPuzzle;");
	stdout.writef("%s - Puzzle1 - ", moduleName.asCapitalized);
	firstPuzzle;
	stdout.writef("%s - Puzzle2 - ", moduleName.asCapitalized);
	secondPuzzle;
}

void main(string[] args) {
	import std.uni: toLower;

	auto arguments = args[1..$];
	if (arguments.empty) {
		static foreach(day; daysList) {
			runModule!day;
		}
		return;
	}
	auto arg = arguments.front.toLower;
	main: switch (arg) {
		static foreach(day; daysList) {
			case day:
				runModule!day;
				break main;
		}
		default:
			writeln("Invalid day:", arg);
	}
}
