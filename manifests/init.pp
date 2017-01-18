class rsyslog	(
								$ratelimitinterval  = '0',
								$servicestate       = 'running',
								$forwardformat      = false,
								$modules            = undef,
								$vars               = undef,
								$workdirectory      = '/var/lib/rsyslog',
								$rsyslogd_purge     = true,
								$rsyslogd_recurse   = true,
								$emerg              = $rsyslog::params::emerg_default,
								$omitlocallogging   = $rsyslog::params::omitlocallogging_default,
								$imjournalstatefile = $rsyslog::params::imjournalstatefile_default,
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
			mode    => '0755',
			purge   => $rsyslogd_purge,
			recurse => $rsyslogd_recurse,
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


		if($rsyslog::params::systemlogsocketname!=undef)
		{
			file { '/etc/rsyslog.d/listen.conf':
				ensure  => 'present',
				owner   => 'root',
				group   => 'root',
				mode    => '0644',
				content => template("${module_name}/modules/listen.erb"),
				notify  => Service['rsyslog'],
				require => File['/etc/rsyslog.d'],
			}
		}

		service { 'rsyslog':
			ensure  => $servicestate,
			enable  => true,
			require => Package['rsyslog'],
		}
	}
}
