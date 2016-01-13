Meteor.publish 'tabular_ProxyPackages', (tableName, ids, fields) ->
  check tableName, String
  check ids, Array
  check fields, Match.Optional(Object)
  @unblock()

  return ProxyPackages.find()

Meteor.publish 'tabular_Proxys', (tableName, ids, fields) ->
  check tableName, String
  check ids, Array
  check fields, Match.Optional(Object)
  @unblock()

  return Proxys.find()
