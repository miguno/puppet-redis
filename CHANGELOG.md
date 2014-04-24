# Change log

## 1.0.5 (unreleased)

* TBD


## 1.0.4 (April 24, 2014)

IMPROVEMENTS

* Add `$user_manage` parameter to enable/disable user and group management.

BACKWARDS INCOMPATIBILITIES

* Change default value of `$package_ensure` from "latest" to "present".


## 1.0.3 (April 08, 2014)

IMPROVEMENTS

* Remove `puppetlabs/stdlib` from `Modulefile` to decouple us from PuppetForge.


## 1.0.2 (March 11, 2014)

BUG FIXES:

* Correctly create `$working_dir` recursively.  (Doh!)


## 1.0.1 (March 11, 2014)

IMPROVEMENTS

* Recursively create `$working_dir` if needed.


## 1.0.0 (March 10, 2014)

* Initial release.
