# puppet2sitepp @rsyslogfacilities
define rsyslog::facility(
                          $facility,
                          $facilityname     = $name,
                          $order            = '10',
                          $filename         = undef,
                          $discard          = false,
                          $basedir          = '/etc/rsyslog.d',
                          $remotesyslog     = undef,
                          $remotesyslogtype = 'udp',
                          $template         = undef,
                        ) {
  validate_re($remotesyslogtype, [ '^udp$', '^tcp$'], "not a valid protocol: ${remotesyslogtype}")

  if ! defined(Class['syslogng'])
  {
    file { "${basedir}/99-${order}-${facilityname}.conf":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => $rsyslog::rsyslogconf_mode,
      content => template("${module_name}/facility.erb"),
      notify  => Service['rsyslog'],
    }
  }

}
