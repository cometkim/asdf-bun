#!/usr/bin/env bash

# Source from https://github.com/davidaurelio/shell-semver

semver_regex() {
  local VERSION="([0-9]+)[.]([0-9]+)[.]([0-9]+)"
  local INFO="([0-9A-Za-z-]+([.][0-9A-Za-z-]+)*)"
  local PRERELEASE="(-${INFO})"
  local METAINFO="([+]${INFO})"
  echo "^${VERSION}${PRERELEASE}?${METAINFO}?$"
}

SEMVER_REGEX=$(semver_regex)
unset -f semver_regex

semver_check() {
  echo "$1" | grep -Eq "$SEMVER_REGEX"
}

semver_parse() {
  semver_check "$1" &&
  echo "$1" | sed -E -e "s/$SEMVER_REGEX/\1 \2 \3 \5 \8/" -e 's/  / _ /g' -e 's/ $/ _/'
}

semver_is_prerelease() {
  local PRERELEASE
  PRERELEASE=$(semver_parse "$1" | cut -d " " -f 4)

  test "$PRERELEASE" != _
}

semver_compare() {
  if ! (semver_check "$1" && semver_check "$2"); then
    return 2
  fi

  local A
  A=$(semver_parse "$1")

  local B
  B=$(semver_parse "$2")

  set $A $B

  if [[ "$1" -gt "$6" || "$2" -gt "$7" ]]; then
    return 1;
  fi
}

semver_equal() {
  local A
  A=$(semver_parse "$1")

  if [ $? != 0 ]; then
    return 2
  fi

  local B
  B=$(semver_parse "$2")

  set $A $B

  test -n "$A" -a -n "$B" -a "$1 $2 $3 $4" = "$6 $7 $8 $9"
}
