@Proxys = new Meteor.Collection("proxys")

Proxys.helpers
	url: ->
  	return "http://#{@ip}:#{@portHttp}"

  getPackage: ->
    ProxyPackages.findOne @packageId

Proxys.allow
  insert: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']
  update: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']
  remove: (userId, doc) ->
    return userId and Roles.userIsInRole userId, ['admin','staff']

ProxysSchema = new SimpleSchema
  packageId:
    type: String
    index: 1
  ip:
    type: String
    index: 1
  portHttp:
    type: Number
  portSocks:
    type: Number
    optional: true
  country_code:
    type: String
  active:
    type: Boolean
  available:
    type: Boolean
  createdAt:
    type: Date
    optional: true
  users:
    type: [String]
    optional: true

Proxys.attachSchema ProxysSchema

if Meteor.isServer
  @userIdProxyRelease = (proxyId, userId) ->
    proxy = Proxys.findOne proxyId

    updateProxyOptions =
      $pull:
        'users': userId

    if !proxy?
      throw new Meteor.Error(401, "Proxys undefined: proxyId:#{proxyId} and userId:user._id")

    if proxy.users? and proxy.users.length is 4
      updateProxyOptions.$set = {}
      updateProxyOptions.$set['available'] = true

    Proxys.update({_id:proxyId}, updateProxyOptions)
    proxyId

  testRequest = (proxyUrl, callback) ->
    ###*
    # Performs a request to the bing favicon to check that the proxiss are working or not. True if works, false if not.
    # @param {object} proxy to test
    ###
    result = {}
    requestOptions =
      npmRequestOptions:
        proxy: proxyUrl
    url = 'http://www.bing.com/favicon.ico'
    method = "GET"
    counter = 0
    loopTimes = [0..2]
    for i in loopTimes
      try
        response = HTTP.call(method, url, requestOptions)
        if response.errors or response.statusCode isnt 200
          counter+=1
      catch
        counter+=1

    result =
      proxyUrl: proxyUrl
      counter: counter
    callback and callback(null, result)

  checkProxyStatus = (proxyId) ->
    testProxyRequest = Meteor.wrapAsync(testRequest)
    proxy = Proxys.findOne proxyId
    if proxy?
      workingProxy = testProxyRequest proxy.url
      if workingProxy.counter > 0
        throw new Meteor.Error 'proxy-error', "Error in proxy with #{workingProxy.counter} errors out of 3"
      return true
    else
      throw new Meteor.Error 'proxy-error', "There is no proxy with this id: #{proxyId}"

  disableProxyAndReleaseUsers = (proxyId) ->
    proxy = Proxys.findOne proxyId
    if proxy?
      updateUserOptions =
        $set:
          'profile.proxyId': null
      Meteor.users.update('profile.proxyId':proxy._id, updateUserOptions, multi: true )

      updateProxyOptions =
        $set: 'users':[] , 'active':false
      Proxys.update(_id:proxyId, updateProxyOptions)
      true
    else
      throw new Meteor.Error 'proxy-error', "There is no proxy with this id: #{proxyId}"

  Meteor.methods
    'disableProxyAndReleaseUsers': (proxyId) ->
      check(proxyId, String)
      loggedInUser = Meteor.userId()
      if !loggedInUser or !Roles.userIsInRole(loggedInUser, ['admin', 'staff'])
        throw new Meteor.Error(401, "You are not allowed to do this action")

      disableProxyAndReleaseUsers(proxyId)

    'checkProxyStatus': (proxyId) ->
      check(proxyId, String)
      loggedInUser = Meteor.userId()
      if !loggedInUser or !Roles.userIsInRole(loggedInUser, ['admin', 'staff'])
        throw new Meteor.Error(401, "You are not allowed to do this action")

      checkProxyStatus(proxyId)

    'doUserIdProxyRelease': (proxyId, userId) ->
      check(userId, String)
      check(proxyId, String)

      loggedInUser = Meteor.user()
      if !loggedInUser or !Roles.userIsInRole(loggedInUser, ['admin', 'staff'])
        throw new Meteor.Error(401, "You are not allowed to do this action")

      userIdProxyRelease(proxyId, userId)
