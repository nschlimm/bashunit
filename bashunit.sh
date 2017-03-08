#!/bin/sh
testsuccess=0
testfail=0
redbg=$(tput setab 1)
greenbg=$(tput setab 2)
tinverse=$(tput rev) 	   # Start reverse video
reset=`tput sgr0`
blackfg=$(tput setaf 0) 
defaultfg=$(tput setaf 9) 
defaultbg=$(tput setab 9)

function testHeadLine() {
   headline="$1"
   ncols=$(tput cols)
   if [[ ${#headline} -gt $ncols ]]; then
      headline="${headline::$(($ncols-3))}..."
   fi
   printf "${tinverse}%-${ncols}s${reset}" "$headline"
}

function printGreen () {
   headline="$1"
   echo " ${greenbg}${blackfg}$headline${reset}"
}

function printRed () {
   headline="$1"
   echo " ${redbg}${blackfg}$headline${reset}"
}

function assert () {
	commands="$1"
	expectedoutregexp="$2"
	testHeadLine "Test assert - command: $commands - assertion: $expectedoutregexp"
	results=$($commands 2>&1)
	if echo "$results" | grep -q "$expectedoutregexp"; then
		printGreen "SUCCESS: found \"$expectedoutregexp\" in command output"
		((testsuccess++))
	else
		printRed "FAIL: not found \"$expectedoutregexp\" in command output"
		((testfail++))
	fi
}

function assert_with () {
	commands="$1"
	expectedtest="$2"
	expectedtestoutregexp="$3"
	testHeadLine "Test assert with - command: $commands - test command: $expectedtest - assertion: $expectedtestoutregexp"
	results=$($commands 2>&1)
	if [[ $expectedtest != "" ]]; then
	  exptest=$($expectedtest)
	  if echo "$exptest" | grep -q "$expectedtestoutregexp"; then
		printGreen "SUCCESS: found \"$expectedtestoutregexp\" in test output"
		((testsuccess++))
	  else
		printRed "FAIL: not found \"$expectedtestoutregexp\" in test output"
		((testfail++))
   	  fi
	fi
}

function assert_with_not () {
	commands="$1"
	expectedtest="$2"
	expectedtestoutregexp="$3"
	testHeadLine "Test assert with not - command: $commands - test command: $expectedtest - assertion: not $expectedtestoutregexp"
	results=$($commands 2>&1)
	if [[ $expectedtest != "" ]]; then
	  exptest=$($expectedtest)
	  if echo "$exptest" | grep -q "$expectedtestoutregexp"; then
		printRed "FAIL: found \"$expectedtestoutregexp\" in test output"
		((testfail++))
	  else
		printGreen "SUCCESS: not found \"$expectedtestoutregexp\" in test output"
		((testsuccess++))
   	  fi
	fi
}

function testend () {
	testname="$1"
    echo "Successfull: $testsuccess"
    echo "Fails:       $testfail"
    if [[ $testfail -gt 0 ]]; then
		printRed "Testsuite \"$testname\" red!"
	else
		printGreen "Testsuite \"$testname\" green!"
	fi
}

