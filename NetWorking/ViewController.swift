//
//  ViewController.swift
//  NetWorking
//
//  Created by ios7126 on 20/09/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var segNetwork: UISegmentedControl!
    @IBOutlet weak var labelResultado: UILabel!
    
    // MARK: - Propriedades
    let getEndPoint = "https://httpbin.org/ip"
    let postEndPoint = "https://requestb.in/17cipet1"
    
    
    // MARK: - Actions
    @IBAction func networkSelecionada(_ sender: UISegmentedControl) {
        switch segNetwork.selectedSegmentIndex {
        case 0:
            // GET
            enviarGET()
        case 1:
            // POST
            enviarPOST()
        default:
            print("Opção Inválida")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Funções de Apoio
    func enviarGET() {
        // Validação do Endpoint, com guard
        guard let getURL = URL(string: getEndPoint) else {
            print("Erro na URL de requisição")
            return }
        /* RELEMBRANDO A SEQUÊNCIA DE OPERAÇÕES DO PARSE
         1 - URL
         2 - SESSION
         3 - DATA
         4 - RESUME
         */
        // 1-URL
        let request = URLRequest(url: getURL)
        // 2-SESSION
        let urlSession = URLSession.shared
        // 3-DATA
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            // Retorno do protocolo HTTP
            //  response = 200
            guard let realResponse = response as? HTTPURLResponse, realResponse.statusCode == 200 else {
                print("Erro na resposta protocolo HTTP")
                return
            }
            // Tudo OK - Vamos fazer o parse do Json
            do {
                if let ipString = data {
                    print("IP retornado: \(ipString)")
                    // PARSE
                    let jsonDictionary = try
                        JSONSerialization.jsonObject(with: ipString, options: .mutableContainers)
                        as! NSDictionary
                    let origem = jsonDictionary["origin"] as! String
                    // Atualizar a Interface
                    //  Desta vez, usando Selector
                    self.performSelector(onMainThread: #selector(ViewController.updateIPLabel(_:)), with: origem, waitUntilDone: false)
                
                }
            } catch {
                print("Erro no parse")
            }
        })
        // 4-RESUME
        task.resume()
    }
    
    func enviarPOST () {
        
    }
    
    // MARK: - Selectors
    // Selector do GET
    func updateIPLabel(_ text: String) {
        self.labelResultado.text = "GET - Seu IP é " + text
    }
    // SELECTOR do POST
    func updatePostLabel(_ text: String) {
        self.labelResultado.text = "POST - " + text
    }


}

