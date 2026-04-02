use UnitTest;
use TerminalColors;
use IO;

param ESC = "\x1b";
param PRE = ESC + "[";
param RST = PRE + "0m";

// Helper: write a value to a memory file and read back as string
proc writeAndRead(val): string throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    w.write(val);
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  return result;
}

// Test writing a red styledText to a memory file
proc testWriteRedText(test: borrowed Test) throws {
  var result = writeAndRead(red("hello"));
  test.assertEqual(result, PRE + "31m" + "hello" + RST);
}

// Test writing a bold styledText to a memory file
proc testWriteBoldText(test: borrowed Test) throws {
  var result = writeAndRead(bold("hello"));
  test.assertEqual(result, PRE + "1m" + "hello" + RST);
}

// Test writing styled text with FG + BG + modifier
proc testWriteComplexStyled(test: borrowed Test) throws {
  var styled = style("text").fg(red()).bg(blue()).bold();
  var result = writeAndRead(styled);
  test.assertEqual(result, PRE + "1;31;44m" + "text" + RST);
}

// Test writing a standalone color to a memory file
proc testWriteStandaloneColor(test: borrowed Test) throws {
  var result = writeAndRead(red());
  test.assertEqual(result, PRE + "31m");
}

// Test writing a standalone modifier to a memory file
proc testWriteStandaloneModifier(test: borrowed Test) throws {
  var result = writeAndRead(bold());
  test.assertEqual(result, PRE + "1m");
}

// Test that default color writes nothing
proc testWriteDefaultColorWritesNothing(test: borrowed Test) throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    var c = style().fg(black()).fg(black());
    // Overwrite with default manually
    w.write(style());
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  // style() has no text, default fg/bg, normal modifier -> just "\x1b[m"
  test.assertEqual(result, PRE + "m");
}

// Test writing multiple styled items in sequence
proc testWriteSequence(test: borrowed Test) throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    w.write(red("hello"));
    w.write(" ");
    w.write(green("world"));
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  var expected = PRE + "31m" + "hello" + RST + " "
               + PRE + "32m" + "world" + RST;
  test.assertEqual(result, expected);
}

// Test writeln with styled text (adds newline)
proc testWritelnStyled(test: borrowed Test) throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    w.writeln(blue("hi"));
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  test.assertEqual(result, PRE + "34m" + "hi" + RST + "\n");
}

// Test writing color + text + reset pattern via IO
proc testWriteColorResetPattern(test: borrowed Test) throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    w.write(red());
    w.write("hello");
    w.write(reset());
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  test.assertEqual(result, PRE + "31m" + "hello" + RST);
}

// Test writing multiple styled items with modifiers via IO
proc testWriteMultipleStyledIO(test: borrowed Test) throws {
  var f = openMemFile();
  {
    var w = f.writer(locking=false);
    w.write(red("hello").bold());
    w.write(", ");
    w.write(green("world").italic());
    w.write("!");
  }
  var r = f.reader(locking=false);
  var result: string;
  r.readAll(result);
  var expected = PRE + "1;31m" + "hello" + RST + ", "
               + PRE + "3;32m" + "world" + RST + "!";
  test.assertEqual(result, expected);
}

// Test writing with RGB256 color via IO
proc testWriteRgb256IO(test: borrowed Test) throws {
  var result = writeAndRead(rgb256(42, "test"));
  test.assertEqual(result, PRE + "38;5;42m" + "test" + RST);
}

// Test writing with RGB24 color via IO
proc testWriteRgb24IO(test: borrowed Test) throws {
  var result = writeAndRead(rgb24(100, 200, 50, "color"));
  test.assertEqual(result, PRE + "38;2;100;200;50m" + "color" + RST);
}

// Test writing complex styled text to memory and reading back
proc testWriteFullComboIO(test: borrowed Test) throws {
  var styled = style("fancy")
    .fg(rgb24(255, 128, 0))
    .bg(rgb256(17))
    .bold()
    .underline();
  var result = writeAndRead(styled);
  test.assertEqual(result,
    PRE + "1;4;38;2;255;128;0;48;5;17m" + "fancy" + RST);
}

UnitTest.main();
