#!/bin/bash

source ./../li.sh
source ~/.aliases/assert.sh

export YES=9
export NO=8

export ERROR=1
export NOERROR=0

# set up test
assert_raises "hash li 2>/dev/null" ${NOERROR} "Li is not avalable"

cmd_li="li > /dev/null"
assert "${cmd_li}; printenv LI_PATH"	"${HOME}/.aliases/"		"Check LI_PATH value"
assert "${cmd_li}; printenv LI_CONFIG"	"${HOME}/.aliases/.config"	"Check LI_CONFIG value"

if [[ -f ${HOME}/.bash_aliases ]];
then
  main_name=${HOME}/.bash_aliases
else
  main_name=${HOME}/.bashrc
fi;

assert "${cmd_li}; printenv LI_MAIN"	"${main_name}"		"Check LI_MAIN value" 

assert_raises "rm ${HOME}/.aliases/.config; ${cmd_li}; if [[ -f ${HOME}/.aliases/.config ]]; then exit ${YES}; fi; exit ${NO};"	${YES}	"Check config auto creation."

assert_raises "exit $(li noexistingcommand)"	${ERROR}	"Check status code for not exusting command."

assert_end general

# help test
assert_raises "li help"	${NOERROR}	"Li help is not avalable. 'li help'"
assert_raises "li -h"	${NOERROR}	"Li help is not avalable. 'li -h'"

assert_end help

# upgrate
assert_raises "li upgrade"	${NOERROR}	"Li upgrade is not avalable. 'li upgrade'"
assert_raises "li -g"		${NOERROR}	"Li upgrade is not avalable. 'li -g'"

assert "li upgrade a"	"Upgrade configuration no extra params."	"Check count of params"
assert "li -g a"	"Upgrade configuration no extra params."	"Checl count of params"

assert_end upgrate

# add
assert_raises "li add"	${NOERROR}	"Li add is not avalable. 'li add'"
assert_raises "li -a"	${NOERROR}	"Li add is not avalable. 'li -a'"

assert "li add"		"Add expect one extra params."	"Check count of params"
assert "li add a b"	"Add expect one extra params."	"Check count of params"

assert "li -a"		"Add expect one extra params."	"Check count of params"
assert "li -a a b"	"Add expect one extra params."	"Check count of params"

assert_end add

# install
assert_raises "li install"	${NOERROR}	"Li install is not avalable. Useing 'li install'"
assert_raises "li -i"		${NOERROR}	"Li install is not avalable. Useing 'li -i'"

assert "li install"		"Install expect two extra params."	"Check count of params"
assert "li install a"		"Install expect two extra params."	"Check count of params"
assert "li install a b c"	"Install expect two extra params."	"Check count of params"

assert "li -i"		"Install expect two extra params."	"Check count of params"
assert "li -i a"	"Install expect two extra params."	"Check count of params"
assert "li -i a b c"	"Install expect two extra params."	"Check count of params"

cmd_install="li remove tests > /dev/null; li install tests https://raw.githubusercontent.com/banadiga/li-aliases/master/test/demo-li-test.sh"

assert "${cmd_install}"		"Alias 'tests' installed."	"Result of installing"

assert_raises "${cmd_install} > /dev/null; hash demo_li_test 2>/dev/null"	${NOERROR}	"Execute installed aliases"

assert "${cmd_install} > /dev/null; li install tests https://raw.githubusercontent.com/banadiga/li-aliases/master/test/demo-li-test.sh"	"Alias 'tests' already instaled."	"Install installed"

assert_raises "${cmd_install} > /dev/null; if [[ -f ${HOME}/.aliases/tests.sh ]]; then exit ${YES}; fi; exit ${NO};"	${YES}	"Check installing"

assert_end install

# update
assert_raises "li update"	${NOERROR}	"Li update is not avalable. 'li update'"
assert_raises "li -u"		${NOERROR}	"Li update is not avalable. 'li -u'"

assert_end update

# remove
assert_raises "li remove"	${NOERROR}	"Li remove is not avalable. 'li remove'"
assert_raises "li -r"		${NOERROR}	"Li remove is not avalable. 'li -r'"

assert "li remove"	"Remove expect one extra params."	"Check count of params"
assert "li remove a b"	"Remove expect one extra params."	"Check count of params"

assert "li -r"		"Remove expect one extra params."	"Check count of params"
assert "li -r a b"	"Remove expect one extra params." 	"Check count of params"

cmd_remove="li remove tests > /dev/null; li install tests https://raw.githubusercontent.com/banadiga/li-aliases/master/test/demo-li-test.sh > /dev/null; li remove tests" #TODO use test file

assert "${cmd_remove}"	"File '${HOME}/.aliases/tests.sh' removed.\n'tests' removed.\nNode: to full removing aliases please reload terminal."	"Result of removeing"

# unalias demo_li_test

assert "li remove test"	"Alias 'test' not instaled.\nUse command to install: li -a test"	"Remove not installed"

assert_raises "${cmd_remove} > /dev/null; exit `alias | grep demo_li_test | wc -l`"	${NOERROR}	"Execute test removed aliases"
assert_raises "${cmd_remove} > /dev/null; if [[ ! -f ${HOME}/.aliases/tests.sh ]]; then exit ${YES}; fi; exit ${NO};"	${YES}	"Check removing"

assert_end remove

# list
assert_raises "li list"	${NOERROR}	"Li list is not avalable. 'li list'"
assert_raises "li -l"	${NOERROR}	"Li list is not avalable. 'li -l'"

assert_end list
