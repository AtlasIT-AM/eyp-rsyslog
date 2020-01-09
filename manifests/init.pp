# @param messages_facilities List of facilities for /var/log/messages default: *.info, mail.none, authpriv.none, cron.none
class rsyslog(
                $ratelimitinterval   = '0',
                $filecreatemode      = undef,
                $service_ensure      = 'running',
                $service_enable      = true,
                $forwardformat       = false,
                $modules             = undef,
                $vars                = undef,
                $workdirectory       = '/var/lib/rsyslog',
                $rsyslogd_purge      = true,
                $rsyslogd_recurse    = true,
                $emerg               = $rsyslog::params::emerg_default,
                $omitlocallogging    = $rsyslog::params::omitlocallogging_default,
                $imjournalstatefile  = $rsyslog::params::imjournalstatefile_default,
                $rsyslogconf_mode    = '0644',
                $rsyslogd_mode       = '0755',
                $log_files           = [],
                $log_files_mode      = '0640',
                $messages_facilities = [ '*.info', 'mail.none', 'authpriv.none', 'cron.none' ],
              ) inherits rsyslog::params {

  if ! defined(Class['syslogng'])
  {
    if($modules)
    {
      validate_array($modules)

      file { '/etc/rsyslog.d/00-modules.conf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => $rsyslogconf_mode,
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
        mode    => $rsyslogconf_mode,
        content => template("${module_name}/modules/vars.erb"),
        notify  => Service['rsyslog'],
        require => File['/etc/rsyslog.d'],
      }
    }

    package { 'rsyslog':
      ensure => 'installed',
    }

    file { '/etc/rsyslog.d':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => $rsyslogd_mode,
      purge   => $rsyslogd_purge,
      recurse => $rsyslogd_recurse,
      require => Package['rsyslog'],
    }

    file { '/etc/rsyslog.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => $rsyslogconf_mode,
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
        mode    => $rsyslogconf_mode,
        content => template("${module_name}/modules/listen.erb"),
        notify  => Service['rsyslog'],
        require => File['/etc/rsyslog.d'],
      }
    }

    if(!empty($log_files))
    {
      file { $log_files:
        ensure => 'present',
        mode   => $log_files_mode,
      }
    }

    if(defined(Class['::syslogng']))
    {
      service { 'rsyslog':
        ensure  => 'stopped',
        enable  => false,
        require => Package['rsyslog'],
      }
    }
    else
    {
      service { 'rsyslog':
        ensure  => $service_ensure,
        enable  => $service_enable,
        require => Package['rsyslog'],
      }
    }
  }
}
