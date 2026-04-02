use UnitTest;
use TerminalColors;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// Test standalone color factory functions produce correct escape codes
proc testStandaloneColorFinish(test: borrowed Test) throws {
  test.assertEqual(black().finish(), PRE + "30m");
  test.assertEqual(red().finish(), PRE + "31m");
  test.assertEqual(green().finish(), PRE + "32m");
  test.assertEqual(yellow().finish(), PRE + "33m");
  test.assertEqual(blue().finish(), PRE + "34m");
  test.assertEqual(magenta().finish(), PRE + "35m");
  test.assertEqual(cyan().finish(), PRE + "36m");
  test.assertEqual(white().finish(), PRE + "37m");
}

// Test that rgb256 colors produce correct escape codes
proc testRgb256ColorFinish(test: borrowed Test) throws {
  test.assertEqual(rgb256(0).finish(), PRE + "38;5;0m");
  test.assertEqual(rgb256(42).finish(), PRE + "38;5;42m");
  test.assertEqual(rgb256(127).finish(), PRE + "38;5;127m");
  test.assertEqual(rgb256(255).finish(), PRE + "38;5;255m");
}

// Test that rgb24 (truecolor) colors produce correct escape codes
proc testRgb24ColorFinish(test: borrowed Test) throws {
  test.assertEqual(rgb24(0, 0, 0).finish(), PRE + "38;2;0;0;0m");
  test.assertEqual(rgb24(255, 255, 255).finish(), PRE + "38;2;255;255;255m");
  test.assertEqual(rgb24(100, 200, 50).finish(), PRE + "38;2;100;200;50m");
  test.assertEqual(rgb24(31, 63, 127).finish(), PRE + "38;2;31;63;127m");
}

// Test color factory functions with text produce correct styled output
proc testColorWithText(test: borrowed Test) throws {
  test.assertEqual(black("hello").finish(), PRE + "30m" + "hello" + RST);
  test.assertEqual(red("hello").finish(), PRE + "31m" + "hello" + RST);
  test.assertEqual(green("hello").finish(), PRE + "32m" + "hello" + RST);
  test.assertEqual(yellow("hello").finish(), PRE + "33m" + "hello" + RST);
  test.assertEqual(blue("hello").finish(), PRE + "34m" + "hello" + RST);
  test.assertEqual(magenta("hello").finish(), PRE + "35m" + "hello" + RST);
  test.assertEqual(cyan("hello").finish(), PRE + "36m" + "hello" + RST);
  test.assertEqual(white("hello").finish(), PRE + "37m" + "hello" + RST);
}

// Test rgb256 with text
proc testRgb256WithText(test: borrowed Test) throws {
  test.assertEqual(rgb256(42, "hello").finish(),
    PRE + "38;5;42m" + "hello" + RST);
  test.assertEqual(rgb256(0, "test").finish(),
    PRE + "38;5;0m" + "test" + RST);
  test.assertEqual(rgb256(255, "end").finish(),
    PRE + "38;5;255m" + "end" + RST);
}

// Test rgb24 with text
proc testRgb24WithText(test: borrowed Test) throws {
  test.assertEqual(rgb24(100, 200, 50, "hello").finish(),
    PRE + "38;2;100;200;50m" + "hello" + RST);
  test.assertEqual(rgb24(0, 0, 0, "dark").finish(),
    PRE + "38;2;0;0;0m" + "dark" + RST);
  test.assertEqual(rgb24(255, 255, 255, "light").finish(),
    PRE + "38;2;255;255;255m" + "light" + RST);
}

// Test that default color produces no visible selector
proc testDefaultColorIsNormal(test: borrowed Test) throws {
  test.assertTrue(style().finish() == PRE + "m");
}

UnitTest.main();
