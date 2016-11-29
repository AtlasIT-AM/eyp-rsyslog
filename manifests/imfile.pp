define rsyslog::imfile(
                        $inputfiletag,
                        $statefile,
                        $fileseverity  = 'error',
                        $filefacility  = 'local7',
                        $inputfilename = $name,
                      ) {
  if ! defined(Class['rsyslog'])
	{
		fail('You must include the rsyslog base class before using any rsyslog defined resources')
	}

  if ! ('imfile' in $rsyslog::modules)
  {
    fail('imfile not loaded')
  }

  if(! defined(Concat['/etc/rsyslog.d/imfiles.conf']))
  {
    concat { '/etc/rsyslog.d/imfiles.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['rsyslog'],
      notify  => Service['rsyslog'],
    }

    concat::fragment { "header imfiles":
      target  => '/etc/rsyslog.d/imfiles.conf',
      order   => '00',
      content => "#puppet managed file\n",
    }

  }

  concat::fragment { "${inputfiletag} ${inputfilename}":
    target  => '/etc/rsyslog.d/imfiles.conf',
    order   => '42',
    content => template("${module_name}/modules/imfile.erb"),
  }

}
