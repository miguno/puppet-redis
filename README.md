# puppet-redis

Wirbelsturm-compatible [Puppet](http://puppetlabs.com/) module to deploy [Redis](http://redis.io).

You can use this Puppet module to deploy Redis to physical and virtual machines, for instance via your existing
internal or cloud-based Puppet infrastructure and via a tool such as [Vagrant](http://www.vagrantup.com/) for local
and remote deployments.

---

Table of Contents

* <a href="#quickstart">Quick start</a>
* <a href="#features">Features</a>
* <a href="#requirements">Requirements and assumptions</a>
* <a href="#installation">Installation</a>
* <a href="#configuration">Configuration</a>
* <a href="#usage">Usage</a>
    * <a href="#configuration-examples">Configuration examples</a>
        * <a href="#hiera">Using Hiera</a>
        * <a href="#manifests">Using Puppet manifests</a>
    * <a href="#service-management">Service management</a>
    * <a href="#log-files">Log files</a>
* <a href="#todo">TODO</a>
* <a href="#changelog">Change log</a>
* <a href="#contributing">Contributing</a>
* <a href="#license">License</a>

---

<a name="quickstart"></a>

# Quick start

See section [Usage](#usage) below.


<a name="features"></a>

# Features

* Supports Redis 2.8+, i.e. the latest stable release version.
* Decouples code (Puppet manifests) from configuration data ([Hiera](http://docs.puppetlabs.com/hiera/1/)) through the
  use of Puppet parameterized classes, i.e. class parameters.  Hence you should use Hiera to control how Redis is
  deployed and to which machines.
* Supports RHEL OS family (e.g. RHEL 6, CentOS 6, Amazon Linux).
    * Code contributions to support additional OS families are welcome!
* Redis is run under process supervision via [supervisord](http://www.supervisord.org/) version 3.0+.


<a name="requirements"></a>

# Requirements and assumptions

* This module requires that the target machines to which you are deploying Redis have **yum repositories configured**
  for pulling the Redis package (i.e. RPM).
    * We provide [wirbelsturm-rpm-redis](https://github.com/miguno/wirbelsturm-rpm-redis) so that you can conveniently
      build such an RPM yourself.
    * Because we run Redis via supervisord through [puppet-supervisor](https://github.com/miguno/puppet-supervisor), the
      supervisord RPM must be available, too.  See [puppet-supervisor](https://github.com/miguno/puppet-supervisor)
      for details.
* This module requires the following **additional Puppet modules**:

    * [puppet-supervisor](https://github.com/miguno/puppet-supervisor)

  It is recommended that you add these modules to your Puppet setup via
  [librarian-puppet](https://github.com/rodjek/librarian-puppet).  See the `Puppetfile` snippet in section
  _Installation_ below for a starting example.
* **When using Vagrant**: Depending on your Vagrant box (image) you may need to manually configure/disable firewall
  settings -- otherwise machines may not be able to talk to each other.  One option to manage firewall settings is via
  [puppetlabs-firewall](https://github.com/puppetlabs/puppetlabs-firewall).


<a name="installation"></a>

# Installation

It is recommended to use [librarian-puppet](https://github.com/rodjek/librarian-puppet) to add this module to your
Puppet setup.

Add the following lines to your `Puppetfile`:

```
# Add the puppet-redis module
mod 'redis',
  :git => 'https://github.com/miguno/puppet-redis.git'

# Add the puppet-supervisor module dependency
mod 'supervisor',
  :git => 'https://github.com/miguno/puppet-supervisor.git'
```

Then use librarian-puppet to install (or update) the Puppet modules.


<a name="configuration"></a>

# Configuration

* See [init.pp](manifests/init.pp) for the list of currently supported configuration parameters.  These should be
  self-explanatory.
* See [params.pp](manifests/params.pp) for the default values of those configuration parameters.


<a name="usage"></a>

# Usage


<a name="configuration-examples"></a>

## Configuration examples


<a name="hiera"></a>

### Using Hiera

Simple example, using default settings.  This will start a Redis instance that listens on port `6379/tcp`.

```yaml
---
classes:
  - supervisor
  - redis::service
```

More sophisticated example that overrides some of the default settings:


```yaml
---
classes:
  - supervisor
  - redis::service

## Custom Redis settings
redis::port: 1234
redis::working_dir: '/var/lib/redis'

## Custom supervisord settings
supervisor::logfile_maxbytes: '20MB'
supervisor::logfile_backups: 5
```


<a name="manifests"></a>

### Using Puppet manifests

_Note: It is recommended to use Hiera to control deployments instead of using this module in your Puppet manifests_
_directly._

TBD


<a name="service-management"></a>

## Service management

To manually start, stop, restart, or check the status of the Redis daemon, respectively:

    $ sudo supervisorctl [start|stop|restart|status] redis

Example:

    $ sudo supervisorctl status
    redis                            RUNNING    pid 3808, uptime 0:09:18

<a name="log-files"></a>

## Log files

_Note: The locations below may be different depending on the Redis RPM you are actually using._

* Supervisord log files related to Redis processes:
    * `/var/log/supervisor/redis/redis.out`
    * `/var/log/supervisor/redis/redis.err`
* Supervisord main log file: `/var/log/supervisor/supervisord.log`


<a name="todo"></a>

# TODO

* Enhance in-line documentation of Puppet manifests.
* Add unit tests and specs.
* Add Travis CI setup.


<a name="changelog"></a>

## Change log

See [CHANGELOG](CHANGELOG.md).


<a name="contributing"></a>

## Contributing to puppet-redis

Code contributions, bug reports, feature requests etc. are all welcome.

If you are new to GitHub please read [Contributing to a project](https://help.github.com/articles/fork-a-repo) for how
to send patches and pull requests to puppet-redis.


<a name="license"></a>

## License

Copyright © 2014 Michael G. Noll

See [LICENSE](LICENSE) for licensing information.
