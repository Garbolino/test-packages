Meteor.loginAsAdmin = (password, callback) ->
  #create a login request with admin: true, so our loginHandler can handle this request
  loginRequest =
    admin: true
    password: password
  #send the login request
  Accounts.callLoginMethod
    methodArguments: [ loginRequest ]
    userCallback: callback
  return
