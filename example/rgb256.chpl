import TerminalColors.{style, rgb256};
use IO;

/*
  Prints the 256-color palette to the terminal as a test pattern.

  The first 16 colors are the basic colors, the next 216 colors are a
  6x6x6 RGB cube, and the last 24 colors are a grayscale ramp.
*/
proc main() {
  basicColors();
  writeln();
  printBlock(16);
  writeln();
  printBlock(124);
  writeln();
  grayscale();
}

/*
  Prints the 16 basic colors
*/
proc basicColors() {
  var sep = "";

  for i in 0..15 {
    write(sep, style("%3n".format(i)).bg(rgb256(i)));
    sep = " ";
  }
  writeln();
}

/*
  Prints a row of 3 blocks of 36 colors each, starting at `start`.
*/
proc printBlock(start) {
  for row in 0..5 {
    var sep = "";
    for block in 0..2 {
      for col in 0..5 {
        var i = start + block * 36 + row * 6 + col;
        write(sep, style("%3n".format(i)).bg(rgb256(i)));
        sep = " ";
      }
      sep = "   ";
    }
    writeln();
  }
}

/*
  Prints the 24 grayscale colors (232-255).
*/
proc grayscale() {
  var sep = "";

  var r = 232..255;
  for i in r {
    write(sep, style("%3n".format(i)).bg(rgb256(i)));
    sep = " ";
    if i == (r.low + r.high) / 2 {
      writeln();
      sep = "";
    }
  }
  writeln();
}
