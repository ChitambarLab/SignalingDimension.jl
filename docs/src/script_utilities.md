# Script Utilities

A `ScriptUtilities` module is provided in the `./script` directory to assist with
running scripts and logging the results.
This module is treated as separate from SignalingDimension.jl because it includes
several dependencies not needed for the functionality in SignalingDimension.jl.

## Running Scripts

The scripts require a few dependencies to run. The most stable way to run these scripts
goes as follows:
* clone this project's git repo and navigate to the root directory `SignalingDimension.jl/`.
* From the project root directory, open a Julia REPL by running the `julia` command.
* Enter `Pkg` mode by entering `]` in the Julia REPL.
* In `Pkg` mode run `pkg> develop --local .` to import the local version of SignalingDimension.jl.
* In `Pkg` mode run `pkg> activate script` to load the script dependencies.
* Hit backspace to exit `Pkg` mode and return to the Julia REPL.
* Finally, run the script with `ARGS = ["--arg1", "value1", "--arg2"]; include("./script/path/to/script.jl")`.

!!! note "Note"
    The `ARGS` array contains string values of positional argument, key-value pairs,
    and flags that would be passed in the command line.
    To run the same command from the command line, one could alternatively call
    `$ julia ./script/path/to/script.jl --arg1 value1 --arg2`.
    However, care must be taken to ensure that all dependencies are properly installed.

## Printing Test Results

```@docs
print_test_results
capture_test
```
