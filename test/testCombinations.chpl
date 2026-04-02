use UnitTest;
use TerminalColors;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// FG + BG combination
proc testFgAndBg(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red()).bg(blue()).finish(),
    PRE + "31;44m" + "text" + RST);
  test.assertEqual(style("text").fg(green()).bg(yellow()).finish(),
    PRE + "32;43m" + "text" + RST);
  test.assertEqual(style("text").fg(cyan()).bg(magenta()).finish(),
    PRE + "36;45m" + "text" + RST);
}

// FG + single modifier
proc testFgAndModifier(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red()).bold().finish(),
    PRE + "1;31m" + "text" + RST);
  test.assertEqual(style("text").fg(blue()).italic().finish(),
    PRE + "3;34m" + "text" + RST);
  test.assertEqual(style("text").fg(green()).underline().finish(),
    PRE + "4;32m" + "text" + RST);
}

// BG + single modifier
proc testBgAndModifier(test: borrowed Test) throws {
  test.assertEqual(style("text").bg(red()).bold().finish(),
    PRE + "1;41m" + "text" + RST);
  test.assertEqual(style("text").bg(blue()).italic().finish(),
    PRE + "3;44m" + "text" + RST);
}

// FG + BG + single modifier
proc testFgBgAndModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).bg(blue()).bold().finish(),
    PRE + "1;31;44m" + "text" + RST);
  test.assertEqual(
    style("text").fg(green()).bg(yellow()).underline().finish(),
    PRE + "4;32;43m" + "text" + RST);
}

// FG + BG + multiple modifiers
proc testFgBgAndMultipleModifiers(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).bg(blue()).bold().italic().finish(),
    PRE + "1;3;31;44m" + "text" + RST);
  test.assertEqual(
    style("text").fg(cyan()).bg(white()).underline().strikethrough().finish(),
    PRE + "4;9;36;47m" + "text" + RST);
}

// RGB256 FG + standard BG
proc testRgb256FgStandardBg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb256(42)).bg(red()).finish(),
    PRE + "38;5;42;41m" + "text" + RST);
}

// Standard FG + RGB256 BG
proc testStandardFgRgb256Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).bg(rgb256(100)).finish(),
    PRE + "31;48;5;100m" + "text" + RST);
}

// RGB256 FG + RGB256 BG
proc testRgb256FgRgb256Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb256(42)).bg(rgb256(200)).finish(),
    PRE + "38;5;42;48;5;200m" + "text" + RST);
}

// RGB24 FG + standard BG
proc testRgb24FgStandardBg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb24(10, 20, 30)).bg(green()).finish(),
    PRE + "38;2;10;20;30;42m" + "text" + RST);
}

// Standard FG + RGB24 BG
proc testStandardFgRgb24Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).bg(rgb24(10, 20, 30)).finish(),
    PRE + "31;48;2;10;20;30m" + "text" + RST);
}

// RGB24 FG + RGB24 BG
proc testRgb24FgRgb24Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb24(1, 2, 3)).bg(rgb24(4, 5, 6)).finish(),
    PRE + "38;2;1;2;3;48;2;4;5;6m" + "text" + RST);
}

// RGB256 FG + RGB24 BG
proc testRgb256FgRgb24Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb256(42)).bg(rgb24(10, 20, 30)).finish(),
    PRE + "38;5;42;48;2;10;20;30m" + "text" + RST);
}

// RGB24 FG + RGB256 BG
proc testRgb24FgRgb256Bg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb24(10, 20, 30)).bg(rgb256(100)).finish(),
    PRE + "38;2;10;20;30;48;5;100m" + "text" + RST);
}

// RGB256 + modifier
proc testRgb256WithModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb256(42)).bold().finish(),
    PRE + "1;38;5;42m" + "text" + RST);
}

// RGB24 + modifier
proc testRgb24WithModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb24(10, 20, 30)).italic().finish(),
    PRE + "3;38;2;10;20;30m" + "text" + RST);
}

// RGB256 FG + RGB24 BG + bold + italic
proc testRgb256Rgb24BoldItalic(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(rgb256(42)).bg(rgb24(1, 2, 3)).bold().italic().finish(),
    PRE + "1;3;38;5;42;48;2;1;2;3m" + "text" + RST);
}

// Color factory with text, then chain more styling
proc testColorFactoryThenChain(test: borrowed Test) throws {
  // red("text") creates styledText with fg=red, then add bold
  test.assertEqual(red("text").bold().finish(),
    PRE + "1;31m" + "text" + RST);
  // blue("text") then add bg and italic
  test.assertEqual(blue("text").bg(yellow()).italic().finish(),
    PRE + "3;34;43m" + "text" + RST);
}

// Modifier factory with text, then chain color
proc testModifierFactoryThenChainColor(test: borrowed Test) throws {
  // bold("text") creates styledText with bold, then add fg
  test.assertEqual(bold("text").fg(red()).finish(),
    PRE + "1;31m" + "text" + RST);
  // italic("text") then add fg and bg
  test.assertEqual(italic("text").fg(green()).bg(blue()).finish(),
    PRE + "3;32;44m" + "text" + RST);
}

// Test using .add() with combined modifier
proc testAddCombinedModifier(test: borrowed Test) throws {
  var m = bold() + italic();
  test.assertEqual(style("text").add(m).finish(),
    PRE + "1;3m" + "text" + RST);
}

// Color factory chain: color("text").bg().bold().underline()
proc testFullChainFromColorFactory(test: borrowed Test) throws {
  test.assertEqual(
    red("hello").bg(white()).bold().underline().finish(),
    PRE + "1;4;31;47m" + "hello" + RST);
}

// Modifier factory chain: modifier("text").fg().bg()
proc testFullChainFromModifierFactory(test: borrowed Test) throws {
  test.assertEqual(
    bold("hello").fg(cyan()).bg(magenta()).finish(),
    PRE + "1;36;45m" + "hello" + RST);
}

// All black colors: FG black + BG black + bold
proc testAllBlack(test: borrowed Test) throws {
  test.assertEqual(
    style("x").fg(black()).bg(black()).bold().finish(),
    PRE + "1;30;40m" + "x" + RST);
}

// Order of chaining should not matter for FG/BG
proc testChainOrderDoesNotMatter(test: borrowed Test) throws {
  var a = style("text").fg(red()).bg(blue()).bold().finish();
  var b = style("text").bold().bg(blue()).fg(red()).finish();
  var c = style("text").bg(blue()).bold().fg(red()).finish();
  test.assertEqual(a, b);
  test.assertEqual(b, c);
}

UnitTest.main();
