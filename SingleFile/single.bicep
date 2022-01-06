

var location = resourceGroup().location
var storageAccountAName = uniqueString('A${subscription().id}')

resource storageAccountA 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountAName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

var storageAccountBName = uniqueString('B${subscription().id}')

resource storageAccountB 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountBName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

var keyVaultName = uniqueString('kv${subscription().id}')
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
}

resource keyVaultStorageAccountAConnectionString 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: 'StorageAccountAConnectionString'
  properties: {
    attributes: {
      enabled: true
    }
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountA.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountA.id, storageAccountA.apiVersion).keys[0].value}'
  }
}

resource keyVaultStorageAccountBConnectionString 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: 'StorageAccountBConnectionString'
  properties: {
    attributes: {
      enabled: true
    }
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountB.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccountB.id, storageAccountB.apiVersion).keys[0].value}'
  }
}
