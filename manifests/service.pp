# Class: corp104_consul_alerts::service
#
# This module manages corp104_consul_alerts service
#
class corp104_consul_alerts::service (
  String    $user              = $corp104_consul_alerts::user,
  String    $group             = $corp104_consul_alerts::group,
  Boolean   $manage_user       = $corp104_consul_alerts::manage_user,
  Array     $extra_groups      = $corp104_consul_alerts::extra_groups,
  Boolean   $manage_group      = $corp104_consul_alerts::manage_group,
  String    $bin_dir           = $corp104_consul_alerts::bin_dir,
  String    $init_style        = $corp104_consul_alerts::init_style,
  String    $service_name      = $corp104_consul_alerts::service_name,
  String    $service_ensure    = $corp104_consul_alerts::service_ensure,
  Boolean   $service_enable    = $corp104_consul_alerts::service_enable,
  Boolean   $manage_service    = $corp104_consul_alerts::manage_service,
  Boolean   $restart_on_change = $corp104_consul_alerts::restart_on_change,
  String    $extra_options     = $corp104_consul_alerts::extra_options,
  Hash[String,Scalar] $extra_env_vars = $corp104_consul_alerts::extra_env_vars,
) inherits corp104_consul_alerts {

  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }

  $options = $extra_options

  # Default Environment variables 
  $env_vars = {}

  $real_env_vars = merge($env_vars, $extra_env_vars)

  corp104_consul_alerts::daemon { $service_name:
    notify_service => $notify_service,
    user           => $user,
    group          => $group,
    manage_user    => $manage_user,
    extra_groups   => $extra_groups,
    manage_group   => $manage_group,
    bin_dir        => $bin_dir,
    init_style     => $init_style,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    manage_service => $manage_service,
    options        => $options,
    env_vars       => $real_env_vars,
  }
}
