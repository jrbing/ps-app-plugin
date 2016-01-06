#!/usr/bin/env bash
#===============================================================================
# vim: softtabstop=2 shiftwidth=2 expandtab fenc=utf-8 spelllang=en
#===============================================================================
#
#          FILE: psadmin.sh
#
#   DESCRIPTION: passes the specified ps-appserver commands to the psadmin
#                executable
#
#===============================================================================

export PMID=$(hostname) # Export the PMID in order to resolve an issue that Tuxedo has with long hostnames

domain=$1
action=$2

required_environment_variables=( PS_HOME PS_CFG_HOME PS_APP_HOME PS_PIA_HOME PS_CUST_HOME TUXDIR )
optional_environment_variables=( DM_HOME PS_DM_DATA_IN PS_DM_DATA_OUT PS_DM_SCRIPT PS_DM_LOG JAVA_HOME COBDIR PS_FILEDIR PS_SERVDIR ORACLE_HOME ORACLE_BASE TNS_ADMIN AGENT_HOME )

set_required_environment_variables () {
  for var in ${required_environment_variables[@]}; do
    rd_node_var=$( printenv RD_NODE_${var} )
    export $var=$rd_node_var
  done
}

set_optional_environment_variables () {
  for var in ${optional_environment_variables[@]}; do
    if [[ `printenv RD_NODE_${var}` ]]; then
      rd_node_var=RD_NODE_${var}
      export $var=$( printenv $rd_node_var )
    fi
  done
}

check_variables () {
  for var in ${required_environment_variables[@]}; do
    if [[ `printenv ${var}` = '' ]]; then
      echo "${var} is not set.  Please make sure this is set before continuing."
      exit 1
    fi
  done
}

update_path () {
  export PATH=$PATH:.
  export PATH=$TUXDIR/bin:$PATH
  [[ $COBDIR ]] && export PATH=$COBDIR/bin:$PATH
  [[ $ORACLE_HOME ]] && export PATH=$ORACLE_HOME/bin:$PATH
  [[ $AGENT_HOME ]] && export PATH=$AGENT_HOME/bin:$PATH
}

update_ld_library_path () {
  export LD_LIBRARY_PATH=$TUXDIR/lib:$LD_LIBRARY_PATH
  [[ $JAVA_HOME ]] && export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH
  [[ $COBDIR ]] && export LD_LIBRARY_PATH=$COBDIR/lib:$LD_LIBRARY_PATH
  [[ $ORACLE_HOME ]] && export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
}

update_cobpath () {
  # Add the PS_APP_HOME cblbin directory to the COBPATH
  [[ $COBPATH ]] && export COBPATH=$PS_APP_HOME/cblbin:$COBPATH
}

source_psconfig () {
  cd "$PS_HOME" && source "$PS_HOME"/psconfig.sh && cd - > /dev/null 2>&1 # Source psconfig.sh
}

#######################
# Setup the environment
#######################

set_required_environment_variables
check_variables
source_psconfig
set_optional_environment_variables
update_path
update_ld_library_path
update_cobpath

###########################
# Run the specified command
###########################

case $action in

  status)
    "$PS_HOME"/bin/psadmin -c sstatus -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c cstatus -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c qstatus -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c pslist -d "$domain" 2>&1
  ;;

  start)
    "$PS_HOME"/bin/psadmin -c boot -d "$domain" 2>&1
  ;;

  stop)
    "$PS_HOME"/bin/psadmin -c shutdown -d "$domain" 2>&1
  ;;

  kill)
    "$PS_HOME"/bin/psadmin -c shutdown! -d "$domain" 2>&1
  ;;

  configure)
    "$PS_HOME"/bin/psadmin -c configure -d "$domain" 2>&1
  ;;

  purge)
    "$PS_HOME"/bin/psadmin -c purge -d "$domain" 2>&1
  ;;

  flush)
    "$PS_HOME"/bin/psadmin -c cleanipc -d "$domain" 2>&1
  ;;

  restart)
    "$PS_HOME"/bin/psadmin -c shutdown -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c boot -d "$domain" 2>&1
  ;;

  bounce)
    "$PS_HOME"/bin/psadmin -c shutdown -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c cleanipc -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c purge -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c configure -d "$domain" 2>&1
    "$PS_HOME"/bin/psadmin -c boot -d "$domain" 2>&1
  ;;

esac
