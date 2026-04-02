use UnitTest;
use TerminalColors;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// Test styledText + string concatenation
proc testStyledTextPlusString(test: borrowed Test) throws {
  var result = red("hello") + " world";
  test.assertEqual(result, PRE + "31m" + "hello" + RST + " world");
}

// Test string + styledText concatenation
proc testStringPlusStyledText(test: borrowed Test) throws {
  var result = "hello " + red("world");
  test.assertEqual(result, "hello " + PRE + "31m" + "world" + RST);
}

// Test multiple styledText + string concatenations
proc testMultipleStyledTextConcat(test: borrowed Test) throws {
  var result = red("hello") + " " + green("world");
  var expected = PRE + "31m" + "hello" + RST + " "
               + PRE + "32m" + "world" + RST;
  test.assertEqual(result, expected);
}

// Test three-part concatenation
proc testThreePartConcat(test: borrowed Test) throws {
  var result = red("a") + " " + green("b") + " " + blue("c");
  var expected = PRE + "31m" + "a" + RST + " "
               + PRE + "32m" + "b" + RST + " "
               + PRE + "34m" + "c" + RST;
  test.assertEqual(result, expected);
}

// Test modifiers + modifiers operator
proc testModifiersPlusModifiers(test: borrowed Test) throws {
  var m = bold() + italic();
  test.assertEqual(m.finish(), PRE + "1;3m");
}

// Test concatenating styled text with bold modifier applied
proc testStyledWithBoldConcat(test: borrowed Test) throws {
  var result = red("hello").bold() + " plain";
  test.assertEqual(result,
    PRE + "1;31m" + "hello" + RST + " plain");
}

// Test concatenating two styled texts with different fg colors and modifiers
proc testTwoStyledDifferentStyles(test: borrowed Test) throws {
  var result = red("hello").bold() + " " + blue("world").italic();
  var expected = PRE + "1;31m" + "hello" + RST + " "
               + PRE + "3;34m" + "world" + RST;
  test.assertEqual(result, expected);
}

// Test styledText with bg + string concat
proc testStyledBgPlusString(test: borrowed Test) throws {
  var result = style("hi").bg(red()) + " done";
  test.assertEqual(result, PRE + "41m" + "hi" + RST + " done");
}

// Test multiple styled segments with rgb colors
proc testMultipleRgbConcat(test: borrowed Test) throws {
  var result = rgb256(42, "a") + "-" + rgb24(10, 20, 30, "b");
  var expected = PRE + "38;5;42m" + "a" + RST + "-"
               + PRE + "38;2;10;20;30m" + "b" + RST;
  test.assertEqual(result, expected);
}

// Test finish() used explicitly for concatenation
proc testExplicitFinishConcat(test: borrowed Test) throws {
  var a = red("hello").bold().finish();
  var b = green("world").italic().finish();
  var result = a + " " + b;
  var expected = PRE + "1;31m" + "hello" + RST + " "
               + PRE + "3;32m" + "world" + RST;
  test.assertEqual(result, expected);
}

// Test that styled text without text plus string works
proc testNoTextStyledPlusString(test: borrowed Test) throws {
  var result = style().fg(red()) + "hello";
  test.assertEqual(result, PRE + "31m" + "hello");
}

// Test color + string operator (standalone color as FG prefix)
proc testColorPlusString(test: borrowed Test) throws {
  test.assertEqual(red() + "hello", PRE + "31m" + "hello");
  test.assertEqual(blue() + "world", PRE + "34m" + "world");
  test.assertEqual(green() + "ok", PRE + "32m" + "ok");
}

// Test string + color operator
proc testStringPlusColor(test: borrowed Test) throws {
  test.assertEqual("hello" + red(), "hello" + PRE + "31m");
  test.assertEqual("world" + blue(), "world" + PRE + "34m");
}

// Test modifier + string operator
proc testModifierPlusString(test: borrowed Test) throws {
  test.assertEqual(bold() + "hello", PRE + "1m" + "hello");
  test.assertEqual(italic() + "world", PRE + "3m" + "world");
  test.assertEqual(underline() + "test", PRE + "4m" + "test");
}

// Test string + modifier operator
proc testStringPlusModifier(test: borrowed Test) throws {
  test.assertEqual("hello" + bold(), "hello" + PRE + "1m");
  test.assertEqual("world" + italic(), "world" + PRE + "3m");
}

// Test color + string + reset pattern
proc testColorStringResetPattern(test: borrowed Test) throws {
  var result = red() + "hello" + reset();
  test.assertEqual(result, PRE + "31m" + "hello" + RST);
}

// Test modifier + string + reset pattern
proc testModifierStringResetPattern(test: borrowed Test) throws {
  var result = bold() + "hello" + reset();
  test.assertEqual(result, PRE + "1m" + "hello" + RST);
}

// Test color + string with all standard colors
proc testAllStandardColorsPlusString(test: borrowed Test) throws {
  test.assertEqual(black() + "x", PRE + "30m" + "x");
  test.assertEqual(red() + "x", PRE + "31m" + "x");
  test.assertEqual(green() + "x", PRE + "32m" + "x");
  test.assertEqual(yellow() + "x", PRE + "33m" + "x");
  test.assertEqual(blue() + "x", PRE + "34m" + "x");
  test.assertEqual(magenta() + "x", PRE + "35m" + "x");
  test.assertEqual(cyan() + "x", PRE + "36m" + "x");
  test.assertEqual(white() + "x", PRE + "37m" + "x");
}

// Test all standalone modifiers + string
proc testAllModifiersPlusString(test: borrowed Test) throws {
  test.assertEqual(bold() + "x", PRE + "1m" + "x");
  test.assertEqual(dim() + "x", PRE + "2m" + "x");
  test.assertEqual(italic() + "x", PRE + "3m" + "x");
  test.assertEqual(underline() + "x", PRE + "4m" + "x");
  test.assertEqual(blink() + "x", PRE + "5m" + "x");
  test.assertEqual(invert() + "x", PRE + "7m" + "x");
  test.assertEqual(hidden() + "x", PRE + "8m" + "x");
  test.assertEqual(strikethrough() + "x", PRE + "9m" + "x");
}

// Test building a styled string with manual color + reset
proc testManualColorResetStyle(test: borrowed Test) throws {
  var result = green() + "OK: " + reset() + "All good";
  test.assertEqual(result, PRE + "32m" + "OK: " + RST + "All good");
}

// Test combining color string then modifier string then reset
proc testColorModifierStringCombo(test: borrowed Test) throws {
  var result = (red() + "") + (bold() + "hello") + reset();
  test.assertEqual(result, PRE + "31m" + PRE + "1m" + "hello" + RST);
}

UnitTest.main();
