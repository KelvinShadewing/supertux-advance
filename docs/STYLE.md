# SuperTux Advance Coding Style Guidelines

## Indentation
Use tabs for indentation. This decreases file size and allows everyone to view indentation at a width they are comfortable with.

## Naming conventions
Use lower camel case for variable and function names, example: `::myFunction <- function(){...}`, `local myVariable = 1`.
Use `::` to define global variables, things that need to continue existing between files.
Use upper camel case for class names, example `::MyClass <- class`.
Use variable prefixes to indicate their purpose. Examples:
* `gm` Game mode
* `gv` Global variable
* `an` Animation
* `spr` Sprite
* `snd` Sound
* `mus` Music
* `tln` Timeline

## Brackets
Brackets go to the same line as `if`, `while`, etc. Example:
```
::func <- function() {
	// function code here
}
```