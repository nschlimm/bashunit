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
standardout=true

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

# check standard out for pattern
function assertContains () {
	commands="$1"
	expectedoutregexp="$2"
	testHeadLine "Test assert contains - command: $commands - assertion: $expectedoutregexp"
	results=$(eval $commands 2>&1)
	if $standardout; then echo -e "$results"; fi 
	if echo "$results" | grep -q "$expectedoutregexp"; then
		printGreen "SUCCESS: found \"$expectedoutregexp\" in command output"
		((testsuccess++))
	else
		printRed "FAIL: not found \"$expectedoutregexp\" in command output"
		((testfail++))
	fi
}

# check standard out for pattern not expected
function assertNotContains () {
	commands="$1"
	expectedoutregexp="$2"
	testHeadLine "Test assert contains - command: $commands - assertion: not $expectedoutregexp"
	results=$(eval $commands 2>&1)
	if $standardout; then echo -e "$results"; fi 
	if ! echo "$results" | grep -q "$expectedoutregexp"; then
		printGreen "SUCCESS: not found \"$expectedoutregexp\" in command output"
		((testsuccess++))
	else
		printRed "FAIL: found \"$expectedoutregexp\" in command output"
		((testfail++))
	fi
}


# check if standard out of check command contains pattern
function assertCheckContains () {
	commands="$1"
	expectedtest="$2"
	expectedtestoutregexp="$3"
	testHeadLine "Test assert check contains - command: $commands - check: $expectedtest - assertion: $expectedtestoutregexp"
	if $standardout; then $commands; else $commands >/dev/null; fi 
	if [[ $expectedtest != "" ]]; then
	  exptest=$(eval $expectedtest)
      if $standardout; then echo -e "$exptest"; fi 
	  if echo "$exptest" | grep -q "$expectedtestoutregexp"; then
		printGreen "SUCCESS: found \"$expectedtestoutregexp\" in test output"
		((testsuccess++))
	  else
		printRed "FAIL: not found \"$expectedtestoutregexp\" in test output"
		((testfail++))
   	  fi
	fi
}

# check if standard out of check command contains pattern
function assertCheckNotContains () {
	commands="$1"
	expectedtest="$2"
	expectedtestoutregexp="$3"
	testHeadLine "Test assert check NOT contains - command: $commands - check: $expectedtest - assertion: $expectedtestoutregexp"
	if $standardout; then $commands; else $commands >/dev/null; fi 
	if [[ $expectedtest != "" ]]; then
	  exptest=$( eval $expectedtest)
      if $standardout; then echo -e "$exptest"; fi 
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
	echo
    echo "Successfull: $testsuccess"
    echo "Fails:       $testfail"
    if [[ $testfail -gt 0 ]]; then
		echo "${redbg}${blackfg}Testsuite \"$testname\" red!${reset}"
	else
		echo "${greenbg}${blackfg}Testsuite \"$testname\" green!${reset}"
	fi
}

