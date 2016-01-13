@ProxyPackages = new Meteor.Collection("proxy_packages")

ProxyPackages.allow
  insert: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']
  update: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']
  remove: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']

ProxyPackagesSchema = new SimpleSchema
  packageId:
    type: String
    index: 1
  name:
    type: String
  packageType:
    type: String
    optional: true
  bandwidth:
    type: Number
    optional: true
  bandwidthLeft:
    type: Number
    optional: true
  howmanyIps:
    type: Number
    optional: true
  price:
    type: Number
    optional: true
  provider:
    type: String
    optional: true
  authips:
    type: [String]
    optional: true
  createdAt:
    type: Date
    optional: true
  expiresAt:
    type: Date
    optional: true

ProxyPackages.attachSchema ProxyPackagesSchema

Meteor.methods
  'updateProxyBonanzaPackages': () ->
    userId = Meteor.userId()
    if userId? and !Roles.userIsInRole userId, ['admin','staff']
      throw new (Meteor.Error)('Permission Denied', 'Sorry, you do no have permission to do this action')

    packs = Meteor.call 'getUserPackages'
    provider = 'proxybonanza'
    if packs?.data? and packs.data.success
      myPackages = packs.data.data
      for obj in myPackages
        packageId = obj.id.toString()
        pack =
          'packageId': packageId
          'name': obj.package.name
          'packageType': obj.package.package_type
          'bandwidth': parseInt(obj.package.bandwidth)
          'bandwidthLeft': parseFloat(obj.bandwidth).toFixed(2)
          'howmanyIps': parseInt(obj.package.howmany_ips)
          'price': parseInt(obj.package.price)
          'provider': provider
          'createdAt': new Date(obj.package.created)
          'expiresAt': new Date(obj.expires)

        packExists = ProxyPackages.findOne(packageId:packageId)
        if packExists?
          updateOptions =
            $set: pack
          ProxyPackages.update(packageId:packageId, updateOptions)
        else
          ProxyPackages.insert pack
    myPackages

  'updateProxyBonanzaPackage': (packageId) ->
    check(packageId, String)

    userId = Meteor.userId()
    if userId? and !Roles.userIsInRole userId, ['admin','staff']
      throw new (Meteor.Error)('Permission Denied', 'Sorry, you do no have permission to do this action')

    pack = Meteor.call 'getPackageDetail', packageId
    if pack?.data? and pack.data.success
      proxys = pack.data.data.ippacks
      _authips = pack.data.data.authips
      mypackage = pack.data.data.package

      authips = []
      _.each _authips, (obj) ->
        authips.push obj.ip
      updateOptions =
        $set:
          'authips': authips

      ProxyPackages.update(packageId:packageId, updateOptions)
      for proxy in proxys
        proxyExits = Proxys.findOne(ip:proxy.ip)
        proxyObj =
          'packageId': packageId
          'ip': proxy.ip
          'portHttp': proxy.port_http
          'portSocks': proxy.port_socks
          'country_code': proxy.proxyserver.georegion.country.isocode.toLowerCase()
        if !proxyExits?
          proxyObj.available = true
          proxyObj.active = true
          proxyObj.createdAt = new Date()
          Proxys.insert proxyObj
        else
          udpateProxyOptions =
            $set: proxyObj
          Proxys.update(_id:proxyExits._id, udpateProxyOptions)
