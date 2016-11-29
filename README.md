# rsyslog

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rsyslog](#setup)
    * [What rsyslog affects](#what-rsyslog-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rsyslog](#beginning-with-rsyslog)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A one-maybe-two sentence summary of what the module does/what problem it solves.
This is your 30 second elevator pitch for your module. Consider including
OS/Puppet version it works with.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What rsyslog affects

* rsyslog modules:
  - imfile
  - imtcp
  - imudp

### Setup Requirements

This module requires pluginsync enabled and eyp/nsswitch module installed

### Beginning with rsyslog

rsyslog example:

```yaml
classes:
  - rsyslog
rsyslog::modules:
  - imfile
  - imtcp
  - imudp
rsyslogfacilities:
  any:
    facility: '*.*'
    remotesyslogtype: tcp
    remotesyslog: "%{hiera('systemadmin::syslogservers')}"
rsyslogimfiles:
  /opt/tomcat8080/logs/catalina.out:
    inputfiletag: catalina.out
    statefile: stat-catalina1
  /opt/tomcat8080/logs/sso.log:
    inputfiletag: sso.log
    statefile: stat-sso1
```

## Usage

modules:
* **imtcp**: TCP Syslog Input Module
* **imudp**: UDP Syslog Input Module
* **imfile**: Text File Input Module
* **imjournal**: provides access to the systemd journal
* **imklog**: provides kernel logging support
* TODO: #$ModLoad immark  # provides --MARK-- message capability

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested on CentOS 6

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature
