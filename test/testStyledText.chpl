use UnitTest;
use TerminalColors;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// Test style() creates a bare styledText with no styling
proc testStyleEmpty(test: borrowed Test) throws {
  test.assertEqual(style().finish(), PRE + "m");
}

// Test style() with text only (no color or modifier)
proc testStyleTextOnly(test: borrowed Test) throws {
  test.assertEqual(style("hello").finish(), PRE + "m" + "hello" + RST);
}

// Test .fg() sets the foreground color
proc testFgSetsColor(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red()).finish(),
    PRE + "31m" + "text" + RST);
  test.assertEqual(style("text").fg(blue()).finish(),
    PRE + "34m" + "text" + RST);
}

// Test .bg() sets the background color
proc testBgSetsColor(test: borrowed Test) throws {
  test.assertEqual(style("text").bg(red()).finish(),
    PRE + "41m" + "text" + RST);
  test.assertEqual(style("text").bg(blue()).finish(),
    PRE + "44m" + "text" + RST);
  test.assertEqual(style("text").bg(green()).finish(),
    PRE + "42m" + "text" + RST);
}

// Test .fg() with rgb256
proc testFgRgb256(test: borrowed Test) throws {
  test.assertEqual(style("x").fg(rgb256(100)).finish(),
    PRE + "38;5;100m" + "x" + RST);
}

// Test .bg() with rgb256
proc testBgRgb256(test: borrowed Test) throws {
  test.assertEqual(style("x").bg(rgb256(200)).finish(),
    PRE + "48;5;200m" + "x" + RST);
}

// Test .fg() with rgb24
proc testFgRgb24(test: borrowed Test) throws {
  test.assertEqual(style("x").fg(rgb24(10, 20, 30)).finish(),
    PRE + "38;2;10;20;30m" + "x" + RST);
}

// Test .bg() with rgb24
proc testBgRgb24(test: borrowed Test) throws {
  test.assertEqual(style("x").bg(rgb24(10, 20, 30)).finish(),
    PRE + "48;2;10;20;30m" + "x" + RST);
}

// Test .add() applies a modifier
proc testAddModifier(test: borrowed Test) throws {
  test.assertEqual(style("text").add(bold()).finish(),
    PRE + "1m" + "text" + RST);
  test.assertEqual(style("text").add(italic()).finish(),
    PRE + "3m" + "text" + RST);
}

// Test .add() chains multiple modifiers
proc testAddMultipleModifiers(test: borrowed Test) throws {
  test.assertEqual(style("text").add(bold()).add(italic()).finish(),
    PRE + "1;3m" + "text" + RST);
}

// Test convenience method .bold()
proc testConvenienceBold(test: borrowed Test) throws {
  test.assertEqual(style("text").bold().finish(),
    PRE + "1m" + "text" + RST);
}

// Test convenience method .dim()
proc testConvenienceDim(test: borrowed Test) throws {
  test.assertEqual(style("text").dim().finish(),
    PRE + "2m" + "text" + RST);
}

// Test convenience method .italic()
proc testConvenienceItalic(test: borrowed Test) throws {
  test.assertEqual(style("text").italic().finish(),
    PRE + "3m" + "text" + RST);
}

// Test convenience method .underline()
proc testConvenienceUnderline(test: borrowed Test) throws {
  test.assertEqual(style("text").underline().finish(),
    PRE + "4m" + "text" + RST);
}

// Test convenience method .blink()
proc testConvenienceBlink(test: borrowed Test) throws {
  test.assertEqual(style("text").blink().finish(),
    PRE + "5m" + "text" + RST);
}

// Test convenience method .invert()
proc testConvenienceInvert(test: borrowed Test) throws {
  test.assertEqual(style("text").invert().finish(),
    PRE + "7m" + "text" + RST);
}

// Test convenience method .hidden()
proc testConvenienceHidden(test: borrowed Test) throws {
  test.assertEqual(style("text").hidden().finish(),
    PRE + "8m" + "text" + RST);
}

// Test convenience method .strikethrough()
proc testConvenienceStrikethrough(test: borrowed Test) throws {
  test.assertEqual(style("text").strikethrough().finish(),
    PRE + "9m" + "text" + RST);
}

// Test chaining .fg() and .bold()
proc testChainFgBold(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red()).bold().finish(),
    PRE + "1;31m" + "text" + RST);
}

// Test that .fg() can be overwritten by a second .fg() call
proc testFgOverwrite(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red()).fg(blue()).finish(),
    PRE + "34m" + "text" + RST);
}

// Test that .bg() can be overwritten by a second .bg() call
proc testBgOverwrite(test: borrowed Test) throws {
  test.assertEqual(style("text").bg(red()).bg(blue()).finish(),
    PRE + "44m" + "text" + RST);
}

// Test finish() with no text returns just the escape code
proc testFinishNoText(test: borrowed Test) throws {
  var result = style().fg(red()).finish();
  test.assertEqual(result, PRE + "31m");
}

// Test finish() with no text, modifier only
proc testFinishNoTextModOnly(test: borrowed Test) throws {
  var result = style().bold().finish();
  test.assertEqual(result, PRE + "1m");
}

UnitTest.main();
