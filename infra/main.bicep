@description('Environment name (staging or production)')
@allowed([
  'staging'
  'prod'
])
param environment string

@description('Azure region for resource deployment')
param location string = resourceGroup().location

@description('App Service plan SKU name')
param appServiceSkuName string

var namingPrefix = 'quickshop-${environment}'

// 1. App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namingPrefix}-plan'
  location: location
  sku: {
    name: appServiceSkuName
  }
  properties: {
    reserved: true
  }
}

// 2. Web App API
resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namingPrefix}-api'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'
      alwaysOn: (environment == 'prod')
    }
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
