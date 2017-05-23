# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source Facebook definitions
#if [ -f /mnt/vol/engshare/admin/scripts/master.bashrc ]; then
#  . /mnt/vol/engshare/admin/scripts/master.bashrc
#fi
if [ -f /usr/facebook/ops/rc/master.bashrc ]; then
  . /usr/facebook/ops/rc/master.bashrc
fi

# Use VI mode
set -o vi

# History 
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%c "

# Devserver for syncstrings
export DEVSERVER=dev

# Editor of choice
export EDITOR=vim

# Get rid of lead www, etc
alias tbgs='tbgs --stripdir'
alias tbgr='tbgr --stripdir'
alias fbgs='fbgs --stripdir'
alias fbgr='fbgr --stripdir'
alias obgs='obgs --stripdir'
alias obgr='obgr --stripdir'
alias cbgs='cbgs --stripdir'
alias cbgr='cbgr --stripdir'

# Graphical diff
alias idiff='~/scripts/idea diff'

# Fancy calendar
alias fcal='~/scripts/fancy_cal | \grep -E --color "\b`date +%e`\b|$"'

# Fancy du for dir size
alias dirsize='du -hxd1 . | gsort -rh'

alias fba='cd ~/fbsource/fbandroid'
alias sb='ssh dev'
alias adr='arc diff --trace -m rebase'

# Facebook PathPicker aka Facebook Pager
function fp() {
  if `which fp 2>/dev/null`; then
    $(which fp)
  else
    fpp
  fi
}

# Make less parse control chars like colors
export LESS="-R"

# Git command-line tools
source ~/.git-completion.sh
source ~/.git-prompt.sh
source ~/.scm-prompt.sh
source ~/.hg-completion.sh

# Setup PROMPT
if [[ -n "$PS1" ]] ; then
  # Some useful colors
  export YELLOW="\[\033[0;33m\]"
  export CYAN="\[\033[1;36m\]"
  export BLUE="\[\033[1;34m\]"
  export PURPLE="\[\033[0;35m\]"
  export NO_COLOR="\[\033[0m\]"
  
  export GIT_PROMPT='$(__git_ps1 " %s")'
  export HG_PROMPT='$(_dotfiles_scm_info)'

  # Choose a color based on whether the last command succeeded or not
  PS1='$([[ ${?:-0} -eq 0 ]] && echo "\[\033[0;32m\]" || echo "\[\033[0;31m\]")'

  # Add the time, user@host
  PS1="$PS1[\t] $YELLOW\u$NO_COLOR@$BLUE$(hostname | sed 's/\.local$//' | sed 's/\..*facebook.com$//')"

  # Add git status and the full path
  PS1="$PS1$PURPLE$HG_PROMPT $CYAN\w"

  # Add a '$'
  PS1="$PS1$NO_COLOR \$ "

  export PS1
fi

# Android helper commands
page() { adb shell am start -a android.intent.action.VIEW fb://page/$1; }
prof() { adb shell am start -a android.intent.action.VIEW fb://profile/${1:-642231006}; }
group() { adb shell am start -a android.intent.action.VIEW fb://group/$1; }
event() { adb shell am start -a android.intent.action.VIEW fb://event/$1; }
permalink() { adb shell am start -a android.intent.action.VIEW fb://native_post/$1?fallback_url=1; }
faceweb() { adb shell am start -a android.intent.action.VIEW fb://faceweb/f?href=%2Fprofile.php; }
restart_fb() {
  adb shell am force-stop com.facebook.wakizashi && \
  adb shell am start -n com.facebook.wakizashi/com.facebook.katana.LoginActivity
}
alias debug_wait='adb shell am start -D -n com.facebook.wakizashi/com.facebook.katana.activity.FbMainTabActivity'
alias perftest_build='bb automation_fbandroid_for_perftest'
alias perftest_install='bi automation_fbandroid_for_perftest'
alias perftest_run='bt //javatests/com/facebook/testing/perf/endtoend:open_composer --no-results-cache'
alias perftest_results='PYTHONPATH=testrunner:testrunner/aosp_testrunner testrunner/buddy_perf_test/results.py'
alias lesslog='adb logcat -d | less'

# Auto paging for grep
_grep_pager() {
  grep_cmd=$1
  shift
  if [ -t 1 ]; then
    $grep_cmd --color=always "$@" | less -FX
  else
    $grep_cmd "$@"
  fi
}
alias grep='_grep_pager grep'
alias egrep='_grep_pager egrep'
alias fgrep='_grep_pager fgrep'

# Random utils
FBANDROID_DIR=$HOME/fbsource/fbandroid
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
alias preview='open -a Preview'
alias qe='$FBANDROID_DIR/scripts/dumpapp qe'
alias gk='$FBANDROID_DIR/scripts/dumpapp gk'
alias mc='$FBANDROID_DIR/scripts/dumpapp mobileconfig'
alias shake='$FBANDROID_DIR/scripts/dumpapp shake'
alias rage='shake'
alias sl='hg sl'
alias st='hg st re:'
alias stc='hg st re: --change .'
alias stu='hg st re: --rev .^'
alias dif='hg diff'
alias difu='hg diff --rev .^'
alias lg='hg lg'
rmbook() {
  for book in $*; do
    hg strip $book && hg book -d $book
  done
}
reporoot() {
  root=$(hg root 2>/dev/null)
  [ $? -eq 0 ] || root=$(git rev-parse --show-toplevel 2>/dev/null)
  rc=$?; [ $rc -ne 0 ] && return $rc
  echo $root
}
genyvpn() {
  sudo route -n change 192.168.1.0/24 -interface vboxnet1
  sudo route -n delete 192.168.1.0/24 -interface vboxnet1
  sudo route -n add 192.168.1.0/24 -interface vboxnet1
}
screenshot() {
  timestamp=$(date +%Y%m%d_%H%M%S)
  target="$HOME/Screenshots/android_screen_$timestamp.png"
  adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $target
  echo Saved screenshot to $target
}

# Buck utilities
# TODO refactor this to `osascript -e 'display notification "hello" with title "title"'`
alias notify='terminal-notifier -message' 
_run_and_notify() {
  success_msg=$1; shift
  fail_msg=$1; shift
  $@
  rc=$?
  if [ $rc -eq 0 ]; then
    notify "$success_msg"
  else
    notify "$fail_msg"
    return $rc
  fi
}
alias bb='_run_and_notify "Build complete" "Build failed" buck build'
alias bi='_run_and_notify "Installed successfully" "Build/install failed" buck install'
alias bt='_run_and_notify "Tests passed!" "Tests failed" buck test'
alias f='bi fb4a -r'
alias sample_install='bi java/com/facebook/composer/sample:sample_debug -r'
test_composer() {
  [ $PWD != "$(reporoot)" ] && echo 'Need to be in a repo root!' && return 1
  composer_paths=$(find javatests/com/facebook/composer -name BUCK | xargs -n1 dirname)
  extra_paths="javatests/com/facebook/feed/util/composer javatests/com/facebook/ipc"
  bt $composer_paths $extra_paths "$@"
}

revapp() {
  hg cat --rev $1 apps/fb4a/manifest/AndroidManifest.xml | grep android:versionName | cut -d'"' -f2
}

fixwatchman() {
  watchman watch-del /Users/rone/fbsource && \
  watchman watch-project /Users/rone/fbsource/fbandroid/.
}

# A function to launch ipython notebooks
function ifbpynb { pushd ~/python; /usr/local/bin/ifbpy notebook --profile=nbserver; popd; }
