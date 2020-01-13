# Class: corp104_consul_alerts::install
#
# This module manages corp104_consul_alerts install
#
class corp104_consul_alerts::install (
  String    $package_name      = $corp104_consul_alerts::package_name,
  String    $version           = $corp104_consul_alerts::version,
  String    $package_ensure    = 'installed',
  String    $install_method    = 'url',
  String    $download_url      = $corp104_consul_alerts::download_url,
  String    $download_extension = 'tar.gz',
  String    $bin_dir           = $corp104_consul_alerts::bin_dir,
  String    $service_name      = $corp104_consul_alerts::service_name,
  String    $http_proxy        = $corp104_consul_alerts::http_proxy,
) inherits corp104_consul_alerts {

  $proxy_server = empty($http_proxy) ? {
    true    => undef,
    default => $http_proxy,
  }

  $install_dir = "/opt/${package_name}-${version}.linux-${facts['architecture']}"

  case $install_method {
    'url': {
      file { $install_dir:
        ensure => 'directory',
        owner  => 'root',
        group  => 0, # 0 instead of root because OS X uses "wheel".
        mode   => '0555',
      }
      -> archive { "/tmp/${package_name}-${version}.${download_extension}":
        ensure          => present,
        source          => $download_url,
        creates         => "${install_dir}/${package_name}",
        extract         => true,
        extract_path    => "${install_dir}",
        proxy_server    => $proxy_server,
        checksum_verify => false,
        cleanup         => true,
      }
      -> file {
        "/opt/${package_name}-${version}.linux-${facts['architecture']}/${package_name}":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${bin_dir}/${service_name}":
          ensure => link,
          notify => Service[$service_name],
          target => "/opt/${package_name}-${version}.linux-${facts['architecture']}/${package_name}",
      }
    }
    'package': {
      package { $package_name:
        ensure => $package_ensure,
      }
    }
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
}
