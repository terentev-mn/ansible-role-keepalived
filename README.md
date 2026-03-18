Keepalived
=========

This role installs and configures Keepalived.

It is based on the evrardjp/ansible-keepalived role, but focuses on ease of use.
The templates have been refactored into a single universal file, and the variables structure has been redesigned to closely match the actual configuration file syntax.


Requirements
------------

No fancy requirements. Only package and file management in the role.

Starting with this role version 4.0.0, the following minimum OS versions are required:
- Ubuntu: 15.04 or above
- Debian: Jessie or above
- CentOS: 7 or above

For older OSes, please use a previous version of this role.

Role Variables
--------------
Variables are defined in a dictionary under the keepalived key.Nested lists or dictionaries are rendered inside curly braces. If a parameter has no value, you must specify novalue.

Example vars:

```yaml
keepalived:
  global_defs:
    router_id: "{{ inventory_hostname }}"
    script_user: root
    enable_script_security: novalue

  vrrp_instance vr-33:
    interface: eth0
    state:
    virtual_router_id: 33
    priority:
    advert_int: 1

    virtual_ipaddress:
      - 10.11.11.11/24 dev eth1
      - 10.10.10.0/32 dev eth0

    virtual_routes:
      - src 10.10.10.33 to 10.0.0.0/8 via 10.10.10.1 dev eth0
      - src 10.10.10.33 to 192.168.0.0/16 via 10.10.10.1 dev eth0
      - src 11.11.11.88 to 0.0.0.0/1 via 142.91.15.88 dev eth1
      - src 11.11.11.88 to 128.0.0.0/1 via 11.11.11.88 dev eth1

    track_script:
      check_service: novalue
```

Converted to config:
```
global_defs {
  router_id localhost
  script_user root
  enable_script_security
}
vrrp_instance vr-33 {
  interface eth0
  state MASTER
  virtual_router_id 33
  priority 100
  advert_int 1
  virtual_ipaddress {
    10.11.11.11/24 dev eth1
    10.10.10.0/32 dev eth0
  }
  virtual_routes {
    src 10.10.10.33 to 10.0.0.0/8 via 10.10.10.1 dev eth0
    src 10.10.10.33 to 192.168.0.0/16 via 10.10.10.1 dev eth0
    src 11.11.11.88 to 0.0.0.0/1 via 11.11.11.88 dev eth1
    src 11.11.11.88 to 128.0.0.0/1 via 11.11.11.88 dev eth1
  }
  track_script {
    check_service
  }
```

The script management method has been changed; scripts are now stored in the `keepalived_scripts` variable.
Example script var:
```yaml
keepalived_scripts:
  - dst: "/etc/keepalived/haproxy_check.sh"
    content: |
      #!/bin/sh
      /usr/bin/curl http://127.0.0.1
     mode: "0755"  # if 0755 may omit
```

Dependencies
------------

No dependency

License
-------

Apache2
This role is based on evrardjp/ansible-keepalived. Original license and authorship retained as per Apache 2.0 requirements.

Author Information
------------------

Maksim Terentev
