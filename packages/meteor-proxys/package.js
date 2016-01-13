Package.describe({
  name: 'elevenyellow:meteor-proxys',
  version: '0.0.1',
  summary: 'A Meteor package designed to easily handle Proxys',
  git: 'https://bitbucket.org/elevenyellow/meteor-proxys/',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use([
    'coffeescript',
    'check',
    'underscore',
    'templating'
  ]);

  api.use('aldeed:tabular@1.5.1');
  api.use('meteorhacks:unblock@1.1.0');
  api.use('aldeed:collection2@2.8.0');
  api.use('dburles:collection-helpers@1.0.4');
  api.use('alanning:roles@1.2.14');
  api.use('garbolino:meteor-proxybonanza');
  api.use('twbs:bootstrap');
  api.use('jss:flag-icon');
  api.use('themeteorchef:bert@2.1.0');

  api.imply(['alanning:roles@1.2.14','accounts-password','aldeed:tabular@1.5.1']);

  api.addFiles([
    'both/proxys-packages.coffee',
    'both/proxys.coffee',
    'both/proxys-tabular.coffee'
  ],['client', 'server']);

  api.addFiles([
    'server/proxys-publications.coffee'
  ],'server');

  api.addFiles([
    'client/proxys.html',
    'client/proxys.coffee',
    'client/proxys-packages.html',
    'client/proxys-packages.coffee'
  ],'client');

});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('elevenyellow:meteor-proxys');
  api.addFiles('meteor-proxys-tests.js');
});
