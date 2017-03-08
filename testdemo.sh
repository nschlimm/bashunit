#!/bin/sh
#!/bin/sh
source ./bashunit.sh

assertContains "echo demotest" "demo"
assertNotContains "echo demotest" "something"
# command under test declares a variable, the check command checks if this variable contains the 'some' pattern now
assertCheckContains "declare testvar=somecontent" "eval echo \$testvar" "some"
# command under test declares a variable, the check command checks that the variable does not contain the 'foo' pattern now
assertCheckNotContains "declare testvar=somecontent" "eval echo \$testvar" "foo"