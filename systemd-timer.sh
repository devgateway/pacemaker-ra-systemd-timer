#!/bin/sh
# Resource Agent for managing Systemd timers
# License: GNU General Public License (GPL)
# Copyright 2018, Development Gateway

# Initialization:
: ${OCF_FUNCTIONS_DIR=${OCF_ROOT}/lib/heartbeat}
. ${OCF_FUNCTIONS_DIR}/ocf-shellfuncs

timer_meta_data() {
  cat <<EOF
##include metadata.xml
EOF
}

timer_usage() {
  echo "Usage: $0 {start|stop|monitor|validate-all|meta-data}" >&2
}

timer_start() {
  if timer_monitor; then
    ocf_log info "$UNIT already running"
    return $OCF_SUCCESS
  fi

  if $CMD --quiet --wait start "$UNIT"; then
    return $OCF_SUCCESS
  else
    return $OCF_ERR_GENERIC
  fi
}

timer_stop() {
}

timer_monitor() {
  if $CMD --quiet is-active "$UNIT"; then
    ocf_log debug "$UNIT is active"
    return $OCF_SUCCESS
  else
    # inspect further
    if $CMD --quiet is-failed "$UNIT"; then
      ocf_log debug "$UNIT has failed"
      exit $OCF_ERR_GENERIC
    else
      ocf_log debug "$UNIT is inactive"
      return $OCF_NOT_RUNNING
    fi
  fi
}

timer_validate_all() {
  check_binary $BINARY

  local STDERR=$($CMD show --property=Id "$UNIT" 2>&1 >/dev/null)
  if [ $? -ne 0 ]; then
    ocf_log err "$CMD: $STDERR"
    # do a more thorough check
    if $CMD --quiet is-system-running
      # unit-specific error
      local CODE=$OCF_ERR_INSTALLED
    else
      # probably can't connect to D-Bus
      local CODE=$OCF_ERR_PERM
    fi
    exit $CODE
  fi

  return $OCF_SUCCESS
}

# Make sure meta-data and usage always succeed
case $__OCF_ACTION in
meta-data)	timer_meta_data
		exit $OCF_SUCCESS
		;;
usage|help)	timer_usage
		exit $OCF_SUCCESS
		;;
esac

BINARY=systemctl
if ocf_is_root; then
  CMD="$BINARY --system"
else
  CMD="$BINARY --user"
fi
UNIT="$(echo "$OCF_RESKEY_name" | sed 's/\.timer$//').timer"

# Anything other than meta-data and usage must pass validation
timer_validate_all || exit $?

# Translate each action into the appropriate function call
case $__OCF_ACTION in
start)		timer_start;;
stop)		timer_stop;;
status|monitor)	timer_monitor;;
validate-all)	;;
*)		timer_usage
		exit $OCF_ERR_UNIMPLEMENTED
		;;
esac
rc=$?

# The resource agent may optionally log a debug message
ocf_log debug "${OCF_RESOURCE_INSTANCE} $__OCF_ACTION returned $rc"
exit $rc
