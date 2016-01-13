Template.proxyActions.events
  'click .proxys-inactive-proxy': (e, t) ->
    e.preventDefault()
    targetProxyId = t.data._id
    if confirm("Are you sure you want to delete this proxy? #{targetProxyId}")
      Meteor.call 'disableProxyAndReleaseUsers', proxyId, (error, data) ->
        if error
          Messages.throwError 'Sorry, we got an error:' + error
        else
          Messages.throwSuccess 'Proxy removed'

  'click .proxys-test-proxy': (e, t) ->
    e.preventDefault()
    targetProxyId = t.data._id
    button = $(e.target)
    button.attr("disabled", true).html('<i class="fa fa-spinner fa-spin"></i> Processing')
    Meteor.call 'checkProxyStatus', targetProxyId, (error, data) ->
      button.attr("disabled", false).html('<i class="fa fa-dot-circle-o"></i> Test')
      if error
        Bert.alert "Sorry, we got an error: #{error.reason}", "danger"
      else
        Bert.alert "Proxy test OK", "success" 
