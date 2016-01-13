Template.proxyPackages.events
  'click .proxys-update-packages': (e) ->
    e.preventDefault()

    Meteor.call 'updateProxyBonanzaPackages', (error, data) ->
      if error
        console.error "There was an error: #{error}"
      else
        console.info "Packages have been updated succesfully"

Template.proxyPackageActions.helpers
  'algo': () ->
    console.log('algo')
    
Template.proxyPackageActions.events
  'click .proxys-update-package': (e) ->
    e.preventDefault()
    packageId = t.data.packageId

    Meteor.call 'updateProxyBonanzaPackage', packageId, (error, data) ->
      if error
        console.error "There was an error: #{error}"
      else
        console.log data
        console.info "Package have been updated succesfully"
