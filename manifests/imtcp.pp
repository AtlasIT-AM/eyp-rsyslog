define rsyslog::imtcp(
                        $tcpport = '514'
                      ) {
  if ! defined(Class['rsyslog'])
  {
    fail('You must include the rsyslog base class before using any rsyslog defined resources')
  }

  if ! ('imtcp' in $rsyslog::modules)
  {
    fail('imtcp not loaded')
  }

  file { '/etc/rsyslog.d/imtcp.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => $rsyslog::rsyslogconf_mode,
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
    content => template("${module_name}/modules/imtcp.erb")
  }

}
