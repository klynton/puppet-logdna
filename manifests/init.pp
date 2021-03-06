# == Class: logdna
#
#   This class installs and configures LogDNA Agent
#
# == Parameters:
# [*conf_key*]
#   LogDNA Ingestion Key - LogDNA Agent service will not start
#   unless it is specified
# [*conf_file*]
#   Configuration file alternative to /etc/logdna.conf,
#   which is default
# [*conf_logdir*]
#   Log Directories to be added
# [*conf_logfile*]
#   Log Files to be added
# [*conf_tags*]
#   Tags to be added
# [*conf_hostname*]
#   Alternative host name to be used
# [*conf_exclude*]
#   Log Files or Directories to be excluded
# [*conf_exclude_regex*]
#   Exclusion Rule for Log Lines
# [*agent_install*]
#   Whether or not to install the agent
# [*agent_configure*]
#   Whether or not to configure the agent
# [*agent_service*]
#   LogDNA Agent service status; i.e.,
#   start, stop, or restart
#

class logdna (
    Optional[String] $conf_key                  = $logdna::params::conf_key,
    Optional[String] $conf_file                 = $logdna::params::conf_file,
    Optional[Array[String]] $conf_logdir        = $logdna::params::conf_logdir,
    Optional[Array[String]] $conf_logfile       = $logdna::params::conf_logfile,
    Optional[Array[String]] $conf_tags          = $logdna::params::conf_tags,
    Optional[String] $conf_hostname             = $logdna::params::conf_hostname,
    Optional[Array[String]] $conf_exclude       = $logdna::params::conf_exclude,
    Optional[String] $conf_exclude_regex        = $logdna::params::conf_exclude_regex,
    Boolean $agent_install                      = $logdna::params::agent_install,
    Boolean $agent_configure                    = $logdna::params::agent_configure,
    Optional[String] $agent_service             = $logdna::params::agent_service
) inherits logdna::params {

    if $agent_install {
        case $::osfamily {
            'RedHat': {
                include 'logdna::agent::package::install_redhat'
            }
            'Debian': {
                include 'logdna::agent::package::install_debian'
            }
            default: {
                fail("This OS is not supported: ${::osfamily}")
            }
        }
    }

    if $agent_configure {
        class {'logdna::agent::configure':
            key           => $conf_key,
            conf_file     => $conf_file,
            logdirs       => $conf_logdir,
            logfiles      => $conf_logfile,
            tags          => $conf_tags,
            hostname      => $conf_hostname,
            exclude       => $conf_exclude,
            exclude_regex => $conf_exclude_regex
        }
    }

    class {'logdna::agent::service':
        ensure => $agent_service,
    }
}
