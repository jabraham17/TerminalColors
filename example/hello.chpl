import TerminalColors.{
  style, reset,
  green, red, blue, cyan, yellow, magenta, white,
  bold, italic, underline, strikethrough
};

proc main() {
  writeln(green(), "Hello, ", "world!", reset());
  writeln(bold(), "Hello, ", "world!", reset());
  writeln(red("Hello, world!"));
  writeln(blue("Hello, world!").bold());
  writeln(bold("Hello, world!"));
  writeln(strikethrough("Hello, world!").fg(red()).bg(blue()));
  writeln(red("Hello") + ", " + green("world") + blue("!"));
  writeln(cyan("Hello, World!").add(italic()).underline());
  writeln(yellow("Hello, World!").dim());
  writeln(bold("Hello, World!").strikethrough());
  writeln(style("Hello, World!").fg(magenta()).blink());
  writeln(style("Hello, World!").fg(red()).invert().bg(white()));
}
