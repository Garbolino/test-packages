users = [
  {
    name: 'Normal User'
    email: 'normal@example.com'
    roles: []
  }
  {
    name: 'View-Secrets User'
    email: 'view@example.com'
    roles: [ 'view-secrets' ]
  }
  {
    name: 'Manage-Users User'
    email: 'manage@example.com'
    roles: [ 'manage-users' ]
  }
  {
    name: 'admin'
    email: 'admin@example.com'
    roles: [ 'admin' ]
  }
]
proxyPackages = [
  {
      "packageId" : "42799"
      "name" : "International"
      "packageType" : "geo"
      "bandwidth" : 51539607552
      "bandwidthLeft" : 49743916344
      "howmanyIps" : 48
      "price" : 161
      "provider" : "proxybonanza"
      "createdAt" : new Date()
      "expiresAt" : new Date()
  }
  {
      "packageId" : "43361"
      "name" : "Shared Bonanza 200IPs/12C/50GB"
      "packageType" : "shared"
      "bandwidth" : 53687091200
      "bandwidthLeft" : 21682288106
      "howmanyIps" : 200
      "price" : 70
      "provider" : "proxybonanza"
      "createdAt" : new Date()
      "expiresAt" : new Date()
  }
]
proxys = [
  {
      "packageId" : "42396"
      "ip" : "93.189.89.119"
      "portHttp" : 60099
      "portSocks" : 61336
      "country_code" : "es"
      "available" : true
      "active" : true
      "createdAt" : new Date()
  }
  {
      "packageId" : "42396"
      "ip" : "93.189.89.118"
      "portHttp" : 60099
      "portSocks" : 61336
      "country_code" : "us"
      "available" : true
      "active" : true
      "createdAt" : new Date()
  }
]
if Meteor.users.find().count() is 0
  _.each users, (user) ->
    id = undefined
    id = Accounts.createUser(
      email: user.email
      password: '111111'
      profile: name: user.name)
    if user.roles.length > 0
      Roles.addUsersToRoles id, user.roles
    return

  console.log "Admin user example: admin@example.com with password: 111111"

if ProxyPackages.find().count() is 0
  _.each proxyPackages, (pack) ->
    ProxyPackages.insert pack

  console.log "ProxyPackages examples created"

if Proxys.find().count() is 0
  _.each proxys, (proxy) ->
    Proxys.insert proxy

  console.log "Proxys examples created"
