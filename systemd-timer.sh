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

# Make sure meta-data and usage always succeed
case $__OCF_ACTION in
meta-data)	timer_meta_data
		exit $OCF_SUCCESS
		;;
usage|help)	timer_usage
		exit $OCF_SUCCESS
		;;
esac

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
