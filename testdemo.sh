#!/bin/sh

# activate the bashunit framework
source ./bashunit.sh

# check if standard out contains the pattern 'demo'
assertContains "echo demotest" "demo"
# check that standard out does not contaun the pattern 'something'
assertNotContains "echo demotest" "something"
# command under test declares a variable, the check command checks if this variable contains the 'some' pattern now
assertCheckContains "declare testvar=somecontent" "eval echo \$testvar" "some"
# command under test declares a variable, the check command checks that the variable does not contain the 'foo' pattern now
assertCheckNotContains "declare testvar=somecontent" "eval echo \$testvar" "foo"

# now the same tests with standard out disabled
standardout=false

# check if standard out contains the pattern 'demo'
assertContains "echo demotest" "demo"
# check that standard out does not contaun the pattern 'something'
assertNotContains "echo demotest" "something"
# command under test declares a variable, the check command checks if this variable contains the 'some' pattern now
assertCheckContains "declare testvar=somecontent" "eval echo \$testvar" "some"
# command under test declares a variable, the check command checks that the variable does not contain the 'foo' pattern now
assertCheckNotContains "declare testvar=somecontent" "eval echo \$testvar" "foo"

# test report
testend "Demo suite"