var keyVaultName = uniqueString('kv${subscription().id}')
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
}

var storageAccountAName = uniqueString('A${subscription().id}')
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
 
var storageAccountBName = uniqueString('B${subscription().id}')
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
