class rsyslog	(
			$ratelimitinterval = '0',
			$servicestate      = 'running',
			$forwardformat     = false,
			$modules           = undef,
			$vars              = undef,
			$workdirectory     = '/var/lib/rsyslog',
		) inherits params {

	if ! defined(Class['syslogng'])
	{
		if($modules)
		{
			validate_array($modules)

			file { '/etc/rsyslog.d/modules.conf':
				ensure  => 'present',
				owner   => 'root',
				group   => 'root',
				mode    => '0644',
				content => template("${module_name}/modules/loadmodules.erb"),
				notify  => Service['rsyslog'],
				require => File['/etc/rsyslog.d'],
			}
		}

		if($vars)
		{
			validate_hash($vars)

			file { '/etc/rsyslog.d/vars.conf':
				ensure  => 'present',
				owner   => 'root',
				group   => 'root',
				mode    => '0644',
				content => template("${module_name}/modules/vars.erb"),
				notify  => Service['rsyslog'],
				require => File['/etc/rsyslog.d'],
			}
		}

		if defined(Class['ntteam'])
		{
			ntteam::tag{ 'rsyslog': }
		}

		package { 'rsyslog':
			ensure => 'installed',
		}

		file { '/etc/rsyslog.d':
			ensure  => 'directory',
			owner   => 'root',
			group   => 'root',
			mode    => '0655',
			require => Package['rsyslog'],
		}

		file { '/etc/rsyslog.conf':
			ensure  => 'present',
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => template($rsyslog::params::rsyslogconf_template),
			notify  => Service['rsyslog'],
			require => [Package['rsyslog'],File['/etc/rsyslog.d']],
		}

		service { 'rsyslog':
			ensure  => $servicestate,
			enable  => true,
			require => Package['rsyslog'],
		}
	}
}
