define rsyslog::imudp(
                        $udpport = '514'
                      ) {
  if ! defined(Class['rsyslog'])
	{
		fail('You must include the rsyslog base class before using any rsyslog defined resources')
	}

  if ! ('imudp' in $rsyslog::modules)
  {
    fail('imudp not loaded')
  }

  file { '/etc/rsyslog.d/imudp.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
    content => template("${module_name}/modules/imudp.erb")
  }

}
