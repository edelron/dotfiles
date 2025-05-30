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

alias javad='java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y'

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

# VLC
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# Fancy du for dir size
alias dirsize='du -hxd1 . | gsort -rh'

alias fba='cd ~/fbsource/fbandroid'
alias fbs='cd ~/fbsource'
alias sb='et dev:8080 -r 2226:2226'
alias jfsn='jf s -n'
alias jfgr='jf get --rebase'
alias ipython=/Users/rone/Library/Python/3.9/bin/ipython3

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

# SCM command-line tools
if [ -f /opt/facebook/share/scm-prompt ]; then
  source /opt/facebook/share/scm-prompt
elif [ -f "$ADMIN_SCRIPTS/scm-prompt" ]; then
  source $ADMIN_SCRIPTS/scm-prompt
fi

# Setup PROMPT
if [[ -n "$PS1" ]] ; then
  # Some useful colors
  export YELLOW="\[\033[0;33m\]"
  export CYAN="\[\033[1;36m\]"
  export BLUE="\[\033[1;34m\]"
  export PURPLE="\[\033[0;35m\]"
  export NO_COLOR="\[\033[0m\]"
  
  export HG_PROMPT='$(_dotfiles_scm_info | sed -E -e "s/\|?remote\/(fbsource|fbobjc)\/stable\|?//g" | sed -E -e "s/remote\/fbandroid\///")'

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
restart_ig() {
  adb shell am force-stop com.instagram.android && \
  adb shell am start -n com.instagram.android/com.instagram.mainactivity.InstagramMainActivity
}
restart_stella() {
  adb shell am force-stop com.facebook.stella_debug && \
  adb shell am start -n com.facebook.stella_debug/com.facebook.wearable.companion.silverstone.main.view.SilverstoneMainActivity
}
alias debug_java='java -Xdebug -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y'
alias debug_wait='adb shell am start -D -n com.facebook.wakizashi/com.facebook.katana.activity.FbMainTabActivity'
alias debug_wait_ig='adb shell am start -D -n com.instagram.android/com.instagram.mainactivity.InstagramMainActivity'
alias debug_wait_stella='adb shell am start -D -n com.facebook.stella_debug/com.facebook.wearable.companion.silverstone.main.view.SilverstoneMainActivity'
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
#alias grep='_grep_pager grep'
#alias egrep='_grep_pager egrep'
#alias fgrep='_grep_pager fgrep'

# Random utils
FBANDROID_DIR=$HOME/fbsource/fbandroid
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
alias preview='open -a Preview'
alias qe='$FBANDROID_DIR/scripts/dumpapp mobileconfig qe'
alias gk='$FBANDROID_DIR/scripts/dumpapp gk'
alias mc='$FBANDROID_DIR/scripts/dumpapp mobileconfig'
alias shake='$FBANDROID_DIR/scripts/dumpapp shake'
alias rage='shake'
alias st='hg st re:'
alias stc='hg st re: --change .'
alias stu='hg st re: --rev .^'
alias dif='hg diff'
alias difu='hg diff --rev .^'
alias lg='hg lg'
alias hghide='hg hide'
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
_notify() {
  if [[ $OSTYPE == 'darwin'* ]]; then
    osascript -e "display notification \"$1\" with title \"Notification\""
  fi
}

_run_and_notify() {
  success_msg=$1; shift
  fail_msg=$1; shift
  $@
  rc=$?
  if [ $rc -eq 0 ]; then
    _notify "$success_msg"
  else
    _notify "$fail_msg"
  fi
  return $rc
}
bb() {
  args=$(_resolve_buck_input "$@")
  _run_and_notify "Build complete" "Build failed" buck build $(~/scripts/addbuckprefix "$args")
}
bi() {
  _run_and_notify "Installed successfully" "Build/install failed" buck install $(~/scripts/addbuckprefix $*)
}
bt() {
  args=$(_resolve_buck_input "$@")
  _run_and_notify "Tests passed!" "Tests failed" buck test $(~/scripts/addbuckprefix "$args")
}
alias f='bi fb4a -r'
alias bd='hg st -n --rev .^ | files2modules | buck build @-'
test_composer() {
  [ $PWD != "$(reporoot)" ] && echo 'Need to be in a repo root!' && return 1
  composer_paths=$(find javatests/com/facebook/composer -name BUCK | xargs -n1 dirname)
  extra_paths="javatests/com/facebook/feed/util/composer javatests/com/facebook/ipc"
  bt $composer_paths $extra_paths "$@"
}

pu() {
  _run_and_notify "Pull complete" "Pull failed" eval "hg pull && hg up stable"
}

revapp() {
  hg cat --rev $1 apps/fb4a/manifest/AndroidManifest.xml | grep android:versionName | cut -d'"' -f2
}

alias bq='buck uquery'

fixwatchman() {
  watchman watch-del /Users/rone/fbsource && \
  watchman watch-project /Users/rone/fbsource/fbandroid/.
}

fix_buck_test() {
  sudo launchctl limit maxfiles 1000000 1000000
}

# A function to launch ipython notebooks
function ifbpynb { pushd ~/python; /usr/local/bin/ifbpy notebook --profile=nbserver; popd; }

function opendot {
  cat | dot -Tpdf | open -f -a /Applications/Preview.app
}

relpath() {
  cat | sed "s|^$PWD/||"
}

reldirname() {
  cat | xargs dirname | relpath
}

warmstart_ig() {
  adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -f 0x10200000 -n com.instagram.android/com.instagram.mainactivity.InstagramMainActivity --activity-clear-task
}

## Choose diff
sd() {
    if ! hg root &> /dev/null; then
        >&2 echo "ERROR: Not in an hg repo"
        return 1
    fi
    hg | fzf -m --layout=reverse --height=~50% | grep -Eo '\bD[0-9]{5,}\b'
}

## Choose commit
sc() {
    if ! hg root &> /dev/null; then
        >&2 echo "ERROR: Not in an hg repo"
        return 1
    fi
    hg | fzf -m --layout=reverse --height=~50% | grep -Eo '\b[a-f0-9]{9}\b'
}

_resolve_buck_input() {
    files=()
    modules=()
    for arg in "$@"; do
        if [ -f "$arg" ]; then
            files+=("$arg")
        else
            modules+=("$arg")
        fi
    done
    if [ ${#files[@]} -gt 0 ]; then
        for module in $(echo "${files[@]}" | files2modules); do
            modules+=("$module")
        done
    fi
    printf '%s\n' "${modules[@]}" | sed 's#^fbsource##' | sort -u
}
