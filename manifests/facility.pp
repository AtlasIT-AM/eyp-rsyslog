define rsyslog::facility(
													$facility,
													$facilityname     = $name,
													$filename         = undef,
													$discard          = false,
													$basedir          = '/etc/rsyslog.d',
													$remotesyslog     = undef,
													$remotesyslogtype = 'udp',
													$order            = '10',
												) {
	validate_re($remotesyslogtype, [ '^udp$', '^tcp$'], "not a valid protocol")

	if ! defined(Class['syslogng'])
	{
		file { "${basedir}/${order}-${facilityname}.conf":
			ensure  => 'present',
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => template("${module_name}/facility.erb"),
			notify  => Service['rsyslog'],
		}
	}

}
