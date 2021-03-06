//
//  SearchCentralViewController.swift
//  Brain Remote
//
//  Created by Lucas Bonin on 6/14/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit
import VirtualGameController

class SearchCentralViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteInit()
        
    }
    
    
    private func remoteInit(){
        
        // Inicializa controle
        VgcManager.startAs(.Peripheral, appIdentifier: "bRainLucas", customElements: CustomElements(), customMappings: CustomMappings())
        
        
        //Adiciona informacoes sobre o controle
        VgcManager.peripheral.deviceInfo = DeviceInfo(deviceUID: "", vendorName: "", attachedToDevice: false, profileType: .ExtendedGamepad, controllerType: .Software, supportsMotion: false)
        
        
        // Notificacoes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchCentralViewController.servicesChange(_:)), name: VgcPeripheralFoundService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchCentralViewController.servicesChange(_:)), name: VgcPeripheralLostService, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchCentralViewController.peripheralDidConnect(_:)), name: VgcPeripheralDidConnectNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        tableView.reloadData()

        // Comeca a procurar por centrals
        VgcManager.peripheral.browseForServices()
    }
    
    func servicesChange(notification: NSNotification){
        //encontrou novo servico
        
        let vgcService = notification.object as? VgcService
        print("Found \(vgcService?.fullName)")
        
        // Recarregar tabela de centrais
        let reloadTable = NSBlockOperation {
            self.tableView.reloadData()
        }
        
        NSOperationQueue.mainQueue().addOperation(reloadTable)
        
    }
    
    
    func peripheralDidConnect(notification: NSNotification){
        //Se conectou em uma central
        
        //Para de procurar por centrais
        //VgcManager.peripheral.stopBrowsingForServices()
        
        
    }
    
    //MARK: Table View data source
    
    override
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Quantidade de centrais encontradas
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VgcManager.peripheral.availableServices.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell")
        
        cell?.textLabel?.text = VgcManager.peripheral.availableServices[indexPath.row].fullName
        
        return cell!
        
    }
    
    //MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !VgcManager.peripheral.haveConnectionToCentral{
            VgcManager.peripheral.connectToService(VgcManager.peripheral.availableServices[indexPath.row])
        }
        //Troca de View.
        VgcManager.peripheral.stopBrowsingForServices()
        performSegueWithIdentifier("PostItSegue", sender: self)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
