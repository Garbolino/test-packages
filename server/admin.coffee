Accounts.registerLoginHandler (loginRequest) ->
  #there are multiple login handlers in meteor.
  #a login request go through all these handlers to find it's login hander
  #so in our login handler, we only consider login requests which has admin field
  if !loginRequest.admin
    return undefined
  #our authentication logic :)
  if loginRequest.password != 'apple1'
    return null
  #we create a admin user if not exists, and get the userId
  userId = null
  user = Meteor.users.findOne('profile.name': 'admin')
  if !user
    userId = Meteor.users.insert('profile.name': 'admin')
  else
    userId = user._id
  #send loggedin user's user id
  { id: userId }
