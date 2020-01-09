# puppet2sitepp @rsyslogimudp
define rsyslog::imudp(
                        $udpport     = '514',
                        $listen_name = $name,
                      ) {
  if ! defined(Class['rsyslog'])
  {
    fail('You must include the rsyslog base class before using any rsyslog defined resources')
  }

  if ! ('imudp' in $rsyslog::modules)
  {
    fail('imudp not loaded')
  }

  $listen_name_cleanup = regsubst($listen_name, '[^a-zA-Z]+', '_', 'G')

  file { "/etc/rsyslog.d/01-imudp-${listen_name_cleanup}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => $rsyslog::rsyslogconf_mode,
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
    content => template("${module_name}/modules/imudp.erb")
  }

}
