#Meteor Proxys
A Meteor private package designed to easily handle Proxys

## Install

* in /packages
  - git clone git@bitbucket.org:elevenyellow/meteor-proxys.git

## Dependencies
* coffeescript
* check
* aldeed:tabular
* aldeed:simple-schema
* meteorhacks:unblock
* aldeed:collection2
* dburles:collection-helpers
* alanning:roles
* jss:flag-icon
* garbolino:meteor-proxybonanza
* twbs:bootstrap

## Usage
* It uses ProxyBonanza API to get a list of available proxys
  - Check https://github.com/Garbolino/meteor-proxybonanza to see API request available
* Add to Meteor Settings your ProxyBonanza API key:
  - Meteor.settings.proxyBonanza.api_key
* Add in a private view (admin, staff using alanning:roles) these templates:
  - {{> proxyPackages}}
  - {{> proxys}}

## TODO
* Fix proxy template actions
* Tests
