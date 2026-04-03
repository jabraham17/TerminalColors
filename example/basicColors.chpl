use TerminalColors;

/*
  Prints the primary 8 colors in normal, bold, and dim styles.
*/
proc main() {
  printBasicColors();
  printBasicBoldColors();
  printBasicDimColors();
}

const colorNames =
  ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"];
const colors =
  [TerminalColors.black(), TerminalColors.red(), TerminalColors.green(),
   TerminalColors.yellow(), TerminalColors.blue(), TerminalColors.magenta(),
   TerminalColors.cyan(), TerminalColors.white()];

proc printBasicColors() {
  write("Basic colors:");
  for (c, name) in zip(colors, colorNames) {
    write(" ", style(name).fg(c));
  }
  writeln();
}

proc printBasicBoldColors() {
  write("Bold colors:");
  for (c, name) in zip(colors, colorNames) {
    write(" ", style(name).fg(c).bold());
  }
  writeln();
}

proc printBasicDimColors() {
  write("Dim colors:");
  for (c, name) in zip(colors, colorNames) {
    write(" ", style(name).fg(c).dim());
  }
  writeln();
}
