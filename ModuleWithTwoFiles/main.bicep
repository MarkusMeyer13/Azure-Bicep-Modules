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
