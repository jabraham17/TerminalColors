use UnitTest;
use TerminalColors;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// Test intense foreground colors produce 9x escape codes
proc testIntenseFgColors(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(black(), intense=true).finish(),
    PRE + "90m" + "text" + RST);
  test.assertEqual(style("text").fg(red(), intense=true).finish(),
    PRE + "91m" + "text" + RST);
  test.assertEqual(style("text").fg(green(), intense=true).finish(),
    PRE + "92m" + "text" + RST);
  test.assertEqual(style("text").fg(yellow(), intense=true).finish(),
    PRE + "93m" + "text" + RST);
  test.assertEqual(style("text").fg(blue(), intense=true).finish(),
    PRE + "94m" + "text" + RST);
  test.assertEqual(style("text").fg(magenta(), intense=true).finish(),
    PRE + "95m" + "text" + RST);
  test.assertEqual(style("text").fg(cyan(), intense=true).finish(),
    PRE + "96m" + "text" + RST);
  test.assertEqual(style("text").fg(white(), intense=true).finish(),
    PRE + "97m" + "text" + RST);
}

// Test intense background colors produce 10x escape codes
proc testIntenseBgColors(test: borrowed Test) throws {
  test.assertEqual(style("text").bg(black(), intense=true).finish(),
    PRE + "100m" + "text" + RST);
  test.assertEqual(style("text").bg(red(), intense=true).finish(),
    PRE + "101m" + "text" + RST);
  test.assertEqual(style("text").bg(green(), intense=true).finish(),
    PRE + "102m" + "text" + RST);
  test.assertEqual(style("text").bg(yellow(), intense=true).finish(),
    PRE + "103m" + "text" + RST);
  test.assertEqual(style("text").bg(blue(), intense=true).finish(),
    PRE + "104m" + "text" + RST);
  test.assertEqual(style("text").bg(magenta(), intense=true).finish(),
    PRE + "105m" + "text" + RST);
  test.assertEqual(style("text").bg(cyan(), intense=true).finish(),
    PRE + "106m" + "text" + RST);
  test.assertEqual(style("text").bg(white(), intense=true).finish(),
    PRE + "107m" + "text" + RST);
}

// Test intense foreground with no text returns just the escape code
proc testIntenseFgNoText(test: borrowed Test) throws {
  test.assertEqual(style().fg(red(), intense=true).finish(),
    PRE + "91m");
  test.assertEqual(style().fg(blue(), intense=true).finish(),
    PRE + "94m");
}

// Test intense background with no text returns just the escape code
proc testIntenseBgNoText(test: borrowed Test) throws {
  test.assertEqual(style().bg(red(), intense=true).finish(),
    PRE + "101m");
  test.assertEqual(style().bg(blue(), intense=true).finish(),
    PRE + "104m");
}

// Test intense FG + normal BG combination
proc testIntenseFgNormalBg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red(), intense=true).bg(blue()).finish(),
    PRE + "91;44m" + "text" + RST);
}

// Test normal FG + intense BG combination
proc testNormalFgIntenseBg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).bg(blue(), intense=true).finish(),
    PRE + "31;104m" + "text" + RST);
}

// Test intense FG + intense BG combination
proc testIntenseFgIntenseBg(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red(), intense=true).bg(blue(), intense=true).finish(),
    PRE + "91;104m" + "text" + RST);
}

// Test intense FG + modifier
proc testIntenseFgWithModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red(), intense=true).bold().finish(),
    PRE + "1;91m" + "text" + RST);
  test.assertEqual(
    style("text").fg(green(), intense=true).italic().finish(),
    PRE + "3;92m" + "text" + RST);
}

// Test intense BG + modifier
proc testIntenseBgWithModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").bg(red(), intense=true).bold().finish(),
    PRE + "1;101m" + "text" + RST);
}

// Test intense FG + intense BG + modifier
proc testIntenseFgIntenseBgWithModifier(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red(), intense=true).bg(blue(), intense=true).bold().finish(),
    PRE + "1;91;104m" + "text" + RST);
}

// Test that non-intense (default) still works correctly
proc testNonIntenseDefault(test: borrowed Test) throws {
  test.assertEqual(style("text").fg(red(), intense=false).finish(),
    PRE + "31m" + "text" + RST);
  test.assertEqual(style("text").bg(red(), intense=false).finish(),
    PRE + "41m" + "text" + RST);
}

// Test overwriting intense FG with normal FG
proc testOverwriteIntenseWithNormal(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red(), intense=true).fg(blue()).finish(),
    PRE + "34m" + "text" + RST);
}

// Test overwriting normal FG with intense FG
proc testOverwriteNormalWithIntense(test: borrowed Test) throws {
  test.assertEqual(
    style("text").fg(red()).fg(blue(), intense=true).finish(),
    PRE + "94m" + "text" + RST);
}

UnitTest.main();
