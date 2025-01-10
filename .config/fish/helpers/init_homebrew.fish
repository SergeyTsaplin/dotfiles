function init_homebrew
  set -q HOMEBREW_EXECUTABLE; or set -f HOMEBREW_EXECUTABLE /opt/homebrew/bin/brew
  if test -e $HOMEBREW_EXECUTABLE
    $HOMEBREW_EXECUTABLE shellenv | source
  end
end
