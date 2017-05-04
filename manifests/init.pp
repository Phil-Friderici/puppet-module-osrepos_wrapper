# == Class: osrepos_wrapper
#
# Wrapper to choose the OS specific package repository class
#
class osrepos_wrapper (
  $repoclass = undef,
) {

  # variable preparations
  if $repoclass != undef {
    validate_string($repoclass)
  }

  case $::osfamily {
    'RedHat': { $repoclass_default = 'swrepo' }
    'Suse':   { $repoclass_default = 'swrepo' }
    'Debian': { $repoclass_default = 'apt' }
    default:  { $repoclass_default = undef }
  }

  case $repoclass {
    undef:   { $repoclass_real = $repoclass_default }
    default: { $repoclass_real = $repoclass }
  }

  # variable validations
  if $repoclass_real != undef {
    validate_string($repoclass_real)
  }

  # functionality
  if $repoclass_real != undef {
    $repoclass_prefix = "::${repoclass_real}"
    include $repoclass_prefix
  }
}