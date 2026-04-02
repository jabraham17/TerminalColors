import TerminalColors.{style, white, rgb24};
use IO;

config const message = "What a lovely smooth gradient!";
config const width = terminalWidth();

/*
  Prints a smooth rainbow gradient across the terminal with a message in the
  middle, using truecolor (24-bit) ANSI escape codes.
*/
proc main() {
  const text = colorBar(message, width);
  writeln(text);
}

/*
  Creates a color bar with a smooth gradient across the width of the
  terminal, and the given message centered in the middle.
*/
proc colorBar(message, width) {
  var result = "";
  const msgLen = message.size;
  const leftPad = (width - msgLen) / 2;

  for i in 0..<width {
    const hue = i: real / width: real * 360.0;
    const (r, g, b) = hsvToRgb(hue, 1.0, 1.0);

    var ch = " ";
    const mi = i - leftPad;
    if mi >= 0 && mi < msgLen then
      ch = message[mi..mi];

    result += style(ch)
                .fg(white())
                .bg(rgb24(r, g, b))
                .bold()
                .finish();
  }

  return result;
}

/*
  Converts a color from HSV (Hue, Saturation, Value) to RGB (Red, Green, Blue).
*/
proc hsvToRgb(h: real, s: real, v: real) {
  const c = v * s;
  const hp = h / 60.0;
  const x = c * (1.0 - abs(hp - 2.0 * floor(hp / 2.0) - 1.0));
  const m = v - c;

  var rgb1: (real, real, real);
  if hp < 1.0      then rgb1 = (c, x, 0.0);
  else if hp < 2.0 then rgb1 = (x, c, 0.0);
  else if hp < 3.0 then rgb1 = (0.0, c, x);
  else if hp < 4.0 then rgb1 = (0.0, x, c);
  else if hp < 5.0 then rgb1 = (x, 0.0, c);
  else                  rgb1 = (c, 0.0, x);

  return (((rgb1(0) + m) * 255.0): int,
          ((rgb1(1) + m) * 255.0): int,
          ((rgb1(2) + m) * 255.0): int);
}


/*
  Compute the width of the terminal using C interop and ioctl.
*/
extern {
  #include <sys/ioctl.h>
  #include <unistd.h>

  int terminalWidth(void);
  int terminalWidth(void) {
    struct winsize w;
    if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0) {
      return w.ws_col;
    } else {
      return 80; // default width if ioctl fails
    }
  }
}
