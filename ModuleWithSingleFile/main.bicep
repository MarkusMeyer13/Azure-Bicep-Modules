var location = resourceGroup().location
var storageAccountAName = uniqueString('A${subscription().id}')

module storageAccountAModule 'Modules/storageAccount.bicep'={
  name: storageAccountAName
  params:{
    storageAccountName:storageAccountAName
  }
}

var storageAccountBName = uniqueString('B${subscription().id}')

module storageAccountBModule 'Modules/storageAccount.bicep'={
  name: storageAccountBName
  params:{
    storageAccountName:storageAccountBName
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

resource storageAccountA 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
 name:storageAccountAName
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

resource storageAccountB 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name:storageAccountBName
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
