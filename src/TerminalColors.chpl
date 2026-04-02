/*
  This module provides utilities for styling terminal output with colors and
  modifiers using ANSI escape codes.

  The primary type is :type:`styledText`, which can be used with various
  factory functions to create styled text with color and text modifiers
  (e.g., bold, italic, underline).

  :type:`color` defines various color options, including standard ANSI colors
  and RGB colors for both 256 color terminals and truecolor (24-bit) terminals.

  The :type:`modifiers` record defines a subset of widely supported ANSI text
  modifiers, which can be combined together.
*/
@chpldoc.noUsage
@chpldoc.noAutoInclude
module TerminalColors {
  import BitOps;

  @chpldoc.nodoc
  param PREFIX = "\x1b[";

  /*
    The `styledTest` type contains all of the styling information for a piece of
    text, including the text itself.

    This type should not be instantiated
    directly, instead prefer the various factory functions like
    :proc:`style`, :proc:`red`, :proc:`bold`, etc.

    For example,

    .. code-block:: chapel

       writeln(red("Hello, world!").bold().underline());
  */
  @chpldoc.hideImplType
  record styledText: writeSerializable {
    @chpldoc.nodoc
    var _text: string = "";
    @chpldoc.nodoc
    var _fg: color = color.default;
    @chpldoc.nodoc
    var _bg: color = color.default;
    @chpldoc.nodoc
    var _mod: modifiers = modifiers.normal;

    @chpldoc.nodoc
    operator +(s: styledText, m: modifiers) do return s.modify(m);
    @chpldoc.nodoc
    operator +(s: styledText, c: color) do return s.foreground(c);
    @chpldoc.nodoc
    operator +(s: styledText, str: string) do return s.finish() + str;
    @chpldoc.nodoc
    operator +(str: string, s: styledText) do return str + s.finish();

    @chpldoc.nodoc
    proc serialize(writer, ref serializer) throws {
      writer.write(this.finish());
    }
  }

  /*
    The `color` type represents a terminal color that can be applied to text.

    This type should not be instantiated directly, instead prefer the various
    factory functions like :proc:`red()`, :proc:`rgb256()`, etc.
  */
  @chpldoc.hideImplType
  record color: writeSerializable {
    @chpldoc.nodoc
    var selector: string;
    @chpldoc.nodoc
    proc type black do return new color("0");
    @chpldoc.nodoc
    proc type red do return new color("1");
    @chpldoc.nodoc
    proc type green do return new color("2");
    @chpldoc.nodoc
    proc type yellow do return new color("3");
    @chpldoc.nodoc
    proc type blue do return new color("4");
    @chpldoc.nodoc
    proc type magenta do return new color("5");
    @chpldoc.nodoc
    proc type cyan do return new color("6");
    @chpldoc.nodoc
    proc type white do return new color("7");
    @chpldoc.nodoc
    proc type default do return new color("9");
    @chpldoc.nodoc
    proc type rgb256(n: int) do return new color("8;5;" + n:string);
    @chpldoc.nodoc
    proc type rgb24(r: int, g: int, b: int) do
      return new color("8;2;" + r:string + ";" + g:string + ";" + b:string);
    @chpldoc.nodoc
    proc serialize(writer, ref serializer) throws do
      if !this.isNormal() then
        writer.write(this.finish());
    /* If the only info we have is that it is a color, assume foreground */
    @chpldoc.nodoc
    proc finish() do return PREFIX + this.getFGSelector() + "m";
    @chpldoc.nodoc
    operator +(c: color, str: string) do
      if !c.isNormal()
        then return c.finish() + str;
        else return str;
    @chpldoc.nodoc
    operator +(str: string, c: color) do
      if !c.isNormal()
        then return str + c.finish();
        else return str;

    @chpldoc.nodoc
    proc isNormal() do return this == color.default;
    @chpldoc.nodoc
    proc getFGSelector() do return "3" + selector;
    @chpldoc.nodoc
    proc getBGSelector() do return "4" + selector;
  }

  /*
    The `modifiers` type represents various text modifiers that can be applied
    to styled text, such as bold, italic, underline, etc.

    This type should not be instantiated directly.
    If you just need the modifier, use a factory function like :proc:`bold()`
    or :proc:`italic()`.

    Modifiers can be combined together like ``bold() + italic()`` or
    ``bold() + underline()`` to apply multiple text modifiers.
    You can also apply these modifiers to existing styles like
    ``red("Hello") + bold() + italic()`` or
    ``red("Hello").mod(bold()).mod(italic())``.
  */
  @chpldoc.hideImplType
  record modifiers: writeSerializable {
    @chpldoc.nodoc
    var value: int;
    @chpldoc.nodoc
    proc type normal do return new modifiers(0b0);
    @chpldoc.nodoc
    proc type bold do return new modifiers(0b1);
    @chpldoc.nodoc
    proc type dim do return new modifiers(0b10);
    @chpldoc.nodoc
    proc type italic do return new modifiers(0b100);
    @chpldoc.nodoc
    proc type underline do return new modifiers(0b1000);
    @chpldoc.nodoc
    proc type blink do return new modifiers(0b10000);
    @chpldoc.nodoc
    proc type invert do return new modifiers(0b1000000);
    @chpldoc.nodoc
    proc type hidden do return new modifiers(0b10000000);
    @chpldoc.nodoc
    proc type strikethrough do return new modifiers(0b100000000);
    @chpldoc.nodoc
    proc serialize(writer, ref serializer) throws do
      if !this.isNormal() then
        writer.write(this.finish());
    @chpldoc.nodoc
    proc finish() do return PREFIX + this.getSelector() + "m";
    @chpldoc.nodoc
    operator +(m: modifiers, str: string) do
      if !m.isNormal()
        then return m.finish() + str;
        else return str;
    @chpldoc.nodoc
    operator +(str: string, m: modifiers) do
      if !m.isNormal()
        then return str + m.finish();
        else return str;
    @chpldoc.nodoc
    proc isNormal() do return value == 0;
    @chpldoc.nodoc
    proc getSelector() {
      var sep = "";
      var sel = "";
      for modifier in [this.type.bold, this.type.dim, this.type.italic,
                        this.type.underline, this.type.blink, this.type.invert,
                        this.type.hidden, this.type.strikethrough] {
        if (value & modifier.value) != 0 {
          // the value is the bit index of the bitmap, use ctz to find it
          var val = BitOps.ctz(modifier.value) + 1;
          sel += sep + val:string;
          sep = ";";
        }
      }
      return sel;
    }
    @chpldoc.nodoc
    operator +(a: modifiers, b: modifiers) do
      return new modifiers(a.value + b.value);
    @chpldoc.nodoc
    operator +=(ref a: modifiers, b: modifiers) {
      a.value |= b.value;
      return a;
    }
  }


  /*
    Creates a new :type:`styledText` with the given text. This serves as the 
    base for creating more complex styled text by applying colors and modifiers
    to it.

    For example, the following are all equivalent ways to create bold, red text
    using `style`.

    .. code-block:: chapel

       writeln(style().fg(red()).bold(), "Hello, world!", reset());
       writeln(style("Hello, world!").fg(red()).bold());
  */
  proc style(text=""): styledText do
    return new styledText(_text=text);
  /*
    Sets the foreground color (text color) of a :type:`styledText`.

    For example, to create blue text:

    .. code-block:: chapel

       writeln(style("Hello, world!").fg(blue()));
  */
  proc styledText.fg(c: color) {
    var newStyle = this;
    newStyle._fg = c;
    return newStyle;
  }
  /*
    Sets the background color of a :type:`styledText`.

    For example, to create text with a red background:

    .. code-block:: chapel

       writeln(style("Hello, world!").bg(red()));
  */
  proc styledText.bg(c: color) {
    var newStyle = this;
    newStyle._bg = c;
    return newStyle;
  }
  /*
    Adds text modifiers (e.g., bold, italic, underline) to a :type:`styledText`.

    For example, to create bold and underlined text the following are all
    equivalent:

    .. code-block:: chapel

       writeln(style("Hello, world!").mod(bold() + underline()));
       writeln(style("Hello, world!").mod(bold()).mod(underline()));
  */
  proc styledText.add(m: modifiers) {
    var newStyle = this;
    newStyle._mod = newStyle._mod + m;
    return newStyle;
  }
  /*
    This family of functions applies specific modifiers to a :type:`styledText`.
    These are convenience functions that call :proc:`add` with the appropriate
    modifier.

    For example, the following are equivalent ways to create bold text:

    .. code-block:: chapel

       writeln(style("Hello, world!").bold());
       writeln(style("Hello, world!").add(bold()));
  */
  proc styledText.bold(): styledText do return this.add(TerminalColors.bold());
  /**/
  proc styledText.dim(): styledText do return this.add(TerminalColors.dim());
  /**/
  proc styledText.italic(): styledText do
    return this.add(TerminalColors.italic());
  /**/
  proc styledText.underline(): styledText do
    return this.add(TerminalColors.underline());
  /**/
  proc styledText.blink() do return this.add(TerminalColors.blink());
  /**/
  proc styledText.invert() do return this.add(TerminalColors.invert());
  /**/
  proc styledText.hidden() do return this.add(TerminalColors.hidden());
  /**/
  proc styledText.strikethrough() do
    return this.add(TerminalColors.strikethrough());

  /*
    Returns the final styled string with all ANSI escape codes applied. This is
    called automatically when a :type:`styledText` is passed to an output
    statement like ``writeln`` or ``write``.

    For example, the following will print bold, red text to the terminal:

    .. code-block:: chapel

       writeln(red("Hello, world!").bold());

    If you need to manually get the styled string (e.g., to concatenate it with
    other strings), you can call this method directly:

    .. code-block:: chapel

       var styled = red("Hello, world!").bold().finish();
       writeln("Styled message: " + styled);
  */
  proc styledText.finish(): string {
    var s = PREFIX;
    if !_mod.isNormal() {
      s += _mod.getSelector();
    }
    if _fg != color.default {
      if !_mod.isNormal() {
        s += ";";
      }
      s += _fg.getFGSelector();
    }
    if _bg != color.default {
      if !_mod.isNormal() || _fg != color.default {
        s += ";";
      }
      s += _bg.getBGSelector();
    }
    s += "m";

    if _text != "" {
      s += _text + reset();
    }

    return s;
  }
  /*
    Returns a string that resets the terminal styling back to the default.
    This only needs to be used when manually constructing ANSI escape codes,
    when using the :type:`styledText` type and its associated factory functions
    it is unnecessary.
  */
  proc reset(): string do return PREFIX + "0m";

  /*
    This family of functions return the standalone modifiers. These modifiers
    can be passed to the :proc:`styledText.add` method or used standalone.

    For example, the following are all equivalent ways to create bold text:

    .. code-block:: chapel

       writeln(bold() + "Hello, world!" + reset()); // this method
       writeln(style("Hello, world!").add(bold())); // this method
       writeln(style("Hello, world!").bold());
       writeln(bold("Hello, world!"));
  */
  proc bold(): modifiers do return modifiers.bold;
  /**/
  proc dim(): modifiers do return modifiers.dim;
  /**/
  proc italic(): modifiers do return modifiers.italic;
  /**/
  proc underline(): modifiers do return modifiers.underline;
  /**/
  proc blink(): modifiers do return modifiers.blink;
  /**/
  proc invert(): modifiers do return modifiers.invert;
  /**/
  proc hidden(): modifiers do return modifiers.hidden;
  /**/
  proc strikethrough(): modifiers do return modifiers.strikethrough;

  /*
    This family of functions applies specific modifiers to a string by creating
    a :type:`styledText` with the given string and applying the appropriate
    modifier. These are shortcuts for common use cases where you just want to
    apply a single modifier.

    For example, the following are all equivalent ways to create bold text:

    .. code-block:: chapel

       writeln(bold() + "Hello, world!" + reset());
       writeln(style("Hello, world!").add(bold()));
       writeln(style("Hello, world!").bold());
       writeln(bold("Hello, world!")); // this method
  */
  proc bold(text: string): styledText do return style(text=text).bold();
  /**/
  proc dim(text: string): styledText do return style(text=text).dim();
  /**/
  proc italic(text: string): styledText do return style(text=text).italic();
  /**/
  proc underline(text: string): styledText do
    return style(text=text).underline();
  /**/
  proc blink(text: string): styledText do return style(text=text).blink();
  /**/
  proc invert(text: string): styledText do return style(text=text).invert();
  /**/
  proc hidden(text: string): styledText do return style(text=text).hidden();
  /**/
  proc strikethrough(text: string): styledText do
    return style(text=text).strikethrough();

  /*
    This family of functions return the standalone colors. These can be passed
    to the :proc:`styledText.fg` or :proc:`styledText.bg` methods or used
    standalone.

    When used standalone, it is assumed that the color is a foreground color.

    For example, the following are all equivalent ways to create red text:

    .. code-block:: chapel

       writeln(red() + "Hello, world!" + reset()); // this method
       writeln(style("Hello, world!").fg(red())); // this method
       writeln(red("Hello, world!"));
  */
  proc black(): color do return color.black;
  /**/
  proc red(): color do return color.red;
  /**/
  proc green(): color do return color.green;
  /**/
  proc yellow(): color do return color.yellow;
  /**/
  proc blue(): color do return color.blue;
  /**/
  proc magenta(): color do return color.magenta;
  /**/
  proc cyan(): color do return color.cyan;
  /**/
  proc white(): color do return color.white;
  /**/
  proc rgb256(n: int): color do return color.rgb256(n);
  /**/
  proc rgb24(r: int, g: int, b: int): color do return color.rgb24(r, g, b);


  /*
    This family of functions applies specific colors to a string by creating a
    :type:`styledText` with the given string and applying the appropriate color.
    These are shortcuts for common use cases where you just want to apply a
    single color.

    These functions assume you want to set the foreground color.
    If you want to set the background color, you can use the
    :proc:`styledText.bg` method with the standalone color functions.

    For example, the following are all equivalent ways to create red text:

    .. code-block:: chapel

       writeln(red() + "Hello, world!" + reset());
       writeln(style("Hello, world!").fg(red()));
       writeln(red("Hello, world!")); // this method
  */
  proc black(text:string): styledText do
    return style(text=text).fg(black());
  /**/
  proc red(text:string): styledText do
    return style(text=text).fg(red());
  /**/
  proc green(text:string): styledText do
    return style(text=text).fg(green());
  /**/
  proc yellow(text:string): styledText do
    return style(text=text).fg(yellow());
  /**/
  proc blue(text:string): styledText do
    return style(text=text).fg(blue());
  /**/
  proc magenta(text:string): styledText do
    return style(text=text).fg(magenta());
  /**/
  proc cyan(text:string): styledText do
    return style(text=text).fg(cyan());
  /**/
  proc white(text:string): styledText do
    return style(text=text).fg(white());
  /**/
  proc rgb256(n: int, text:string): styledText do
    return style(text=text).fg(rgb256(n));
  /**/
  proc rgb24(r: int, g: int, b: int, text:string): styledText do
    return style(text=text).fg(rgb24(r, g, b));



}
