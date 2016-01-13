TabularProxyTables = {}

Meteor.isClient and Template.registerHelper('TabularProxyTables', TabularProxyTables)

TabularProxyTables.ProxysPackages = new Tabular.Table
  name: 'ProxysPackagesTable'
  collection: ProxyPackages
  pub: "tabular_ProxyPackages"
  allow:  (userId) ->
    return Roles.userIsInRole userId, ['admin','staff']
  extraFields: ['bandwidthLeft']
  pageLength: 10
  autoWidth: true
  order: [[0, "desc"]]
  columns: [
    {
      title: "PackageId"
      data: "packageId"
    }
    {
      title: "Name"
      data: "name"
    }
    {
      title: "Type"
      data: "packageType"
    }
    {
      data: "_id"
      visible: false
    }
    {
      title: "Number of IPs"
      data: "howmanyIps"
    }
    {
      title: "Bandwidth"
      data: "bandwidth"
      render: (val, type, doc) ->
        gb = parseInt(val/(1024*1024*1024))
        left = parseInt(doc.bandwidthLeft/(1024*1024*1024))
        "#{left} GiB / #{gb} GiB"
    }
    {
      title: "Price"
      data: "price"
      render: (val, type, doc) ->
        "$#{val}"
    }
    {
      title: "Provider"
      data: "provider"
    }
    {
      title: "AuthIPs"
      tmpl: Meteor.isClient and Template.proxyPackageAuthIps
    }
    {
      title: "Actions"
      tmpl: Meteor.isClient and Template.proxyPackageActions
    }
  ]

TabularProxyTables.Proxys = new Tabular.Table
  name: 'ProxysTable'
  collection: Proxys
  pub: "tabular_Proxys",
  allow:  (userId) ->
    return Roles.userIsInRole userId, ['admin','staff']
  pageLength: 25
  extraFields: ['portHttp', 'ip']
  autoWidth: false
  order: [[3, "desc"]],
  columns: [
    {
      title: "URL"
      data: "url()"
    }
    {
      data: "_id"
      visible: false
    }
    {
      title: "Country"
      data: "country_code"
      render: (val, type, doc) ->
        return "<span class='flag-icon flag-icon-#{val}' alt=#{val} title=#{val}></span> #{val}"
    }
    {
      title: "Available"
      data: "available"
    }
    {
      title: "Users"
      data: "users"
      render: (val, type, doc) ->
        label = 'bg-green'
        if val?
          num = val.length
          if num is 4
            label = 'bg-red'
        else
          num = 0
        "<span class='badge #{label}'>#{num}</span>"
    }
    {
      title: "Actions"
      tmpl: Meteor.isClient && Template.proxyActions
    }
  ]
