class rsyslog::params {

	case $::osfamily
	{
		'redhat':
		{
			case $::operatingsystemrelease
			{
				/^6.*$/:
				{
					$rsyslogconf_template='rsyslog/rsyslogconf.erb'
					$system_im='imklog'
					$systemlogsocketname=undef
					$imjournalstatefile_default=undef
					$omitlocallogging_default=undef
					$emerg_default='*'
				}
				/^7.*$/:
				{
					$rsyslogconf_template='rsyslog/rsyslogconf.erb'
					$system_im='imjournal'
					$systemlogsocketname='/run/systemd/journal/syslog'
					$imjournalstatefile_default='imjournal.state'
					$omitlocallogging_default=true
					$emerg_default=':omusrmsg:*'
				}
				default: { fail('Unsupported RHEL/CentOS version!')  }
			}
		}
		default: { fail('Unsupported OS!')  }
	}
}
