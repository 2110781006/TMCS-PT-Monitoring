/*OPC UA Systems*/
module "opcuaSystem-1" {
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys1"
}
module "opcuaSystem-2"{
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys2"
}
module "opcuaSystem-3"{
  source = "./modules/opcuaSystem"
  opcuaSystemName = "opcuaSys3"
}

/*DB System*/
module "dbSystem" {
  source = "./modules/databaseSystem"
  dbSystemName = "dbSys1"
  dbPassword = var.dbPassword
}

/*Monitoring System*/
module "monitoringSystem" {
  source = "./modules/monitoringSystem"
  monitoringSystemName = "monitoringSys1"
}

/*WinCC Oa System*/
module "winccoaSystem" {
  source = "./modules/winccoaSystem"
  winccoaSystemName = "winccoaSys1"
  connectToOpcUaServers = "${module.opcuaSystem-1.opcuaIp}_${module.opcuaSystem-2.opcuaIp}_${module.opcuaSystem-3.opcuaIp}"
  dbHost = module.dbSystem.dbIp
  dbUser = var.dbUser
  dbPassword = var.dbPassword
}

output "result" {
  value = module.dbSystem.dbIp
}