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
}

/*Monitoring System*/
module "monitoringSystem" {
  source = "./modules/monitoringSystem"
  monitoringSystemName = "monitoringSys1"
}

/*
module "winccoaSystem-1" {
  source = "./modules/winccoaSystem"
  winccoaSystemName = "firstSystem"
  winccoaSystemIdx = "1"
}

module "winccoaSystem-2" {
  source = "./modules/winccoaSystem"
  winccoaSystemName = "secondSystem"
  winccoaSystemIdx = "2"
}

output "winccoaSystem-1-url" {
  value = "${module.winccoaSystem-1.winccoa-master-url}"
}

output "winccoaSystem-2-url" {
  value = "${module.winccoaSystem-2.winccoa-master-url}"
}
*/