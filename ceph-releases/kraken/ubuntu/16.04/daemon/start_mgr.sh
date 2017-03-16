#!/bin/bash
set -e

function start_mgr {
  get_config
  check_config

  # Check to see if our MGR has been initialized
  if [ ! -e $MGR_KEYRING ]; then
    get_admin_key
    check_admin_key

    # Create ceph-mgr key
    ceph ${CEPH_OPTS} auth get-or-create mgr.$MGR_NAME mon 'allow *' -o $MGR_KEYRING
    chown ceph. $MGR_KEYRING
    chmod 600 $MGR_KEYRING
  fi

  log "SUCCESS"
  # start ceph-mgr
  exec /usr/bin/ceph-mgr ${CEPH_OPTS} -d --setuser ceph --setgroup ceph -i $MGR_NAME
}