# bashunit

A tiny test framework for bash script.

# Features

* nice report of succeeded and failed tests
* deals with all kind of bash challenges (word splitting etc.)
* can also deal with commands that do not return standard out by using check command for assertion
* easy to use with only four required methods to test effectively: `assertContains`, `assertNotContains`, `assertCheckContains`, `assertCheckNotContains`
* maximum power for your tests with minimum learning curve

# Usage

see sample [testdemo.sh](https://github.com/nschlimm/bashunit/blob/master/testdemo.sh) script
