# puppet-module-osrepos_wrapper

#### Table of Contents

1. [Module Description](#module-description)
2. [Compatibility](#compatibility)
3. [Class Descriptions](#class-descriptions)
    * [osrepos_wrapper](#class-osrepos_wrapper)


# Module description

A simple wrapper to decide which class is called for managing OS package
repositories. Based on the osfamily of a system apt or swrepo will be
included in the catalogue. Further configuration details needs to be
configured at hiera level for the used class.

This wrapper is passive, on unsupported osfamilies it will not add
resources to the catalogue nor fail the compilation.


# Compatibility

This module is built for use with Puppet v3 (with and without the future
parser) and Puppet v4 on the following platforms and supports Ruby versions
1.8.7, 1.9.3, 2.0.0, 2.1.0 and 2.3.1.

 * Debian 6
 * Debian 7
 * Debian 8
 * EL 5
 * EL 6
 * EL 7
 * SLED 11
 * SLED 12
 * SLES 11
 * SLES 12
 * Ubuntu 10.04
 * Ubuntu 12.04
 * Ubuntu 14.04
 * Ubuntu 16.04

Support is directly depending on the sourced classes apt and swrepo:
 * https://github.com/puppetlabs/puppetlabs-apt.git
 * https://github.com/jwennerberg/puppet-module-swrepo.git

[![Build Status](https://travis-ci.org/Phil-Friderici/puppet-module-osrepos_wrapper.png?branch=master)](https://travis-ci.org/Phil-Friderici/puppet-module-osrepos_wrapper)


# Class Descriptions
## Class `osrepos_wrapper`

### Description

The osrepos_wrapper class will decide which class is called for managing
OS package repositories based on the osfamily of the system.

When running on RedHat or Suse it will call swrepo, on Debian and Ubuntu
apt will be used by default.

### Parameters

---
#### repoclass (type: String)
Alternative class to call for managing package repositories if specified.
Configuration needs to be configured at hiera level for the given class.

- *Default*: 'undef'

---
