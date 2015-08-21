//
//  ViewController.swift
//  braintree-test
//
//  Created by Stephen Parker on 20/08/2015.
//  Copyright (c) 2015 nbition. All rights reserved.
//

import UIKit
import Braintree

class ViewController: UIViewController, BTDropInViewControllerDelegate {
    
    var braintree = Braintree()
    var tokenResponse: String = ""
    
    @IBAction func paymentButton(sender: AnyObject) {
        var dropInViewController: BTDropInViewController = self.braintree.dropInViewControllerWithDelegate(self)
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action:"userDidCancelPayment")
        
        dropInViewController.navigationItem.leftBarButtonItem = cancelButton
        dropInViewController.summaryTitle = "A tasty burger"
        dropInViewController.summaryDescription = "Good with a beverage to wash it down"
        dropInViewController.displayAmount = "$10"
        
        var navigationController: UINavigationController = UINavigationController(rootViewController: dropInViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let clientTokenURL = NSURL(string: "https://braintree-homey-cltsang.c9.io/client_token")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        clientTokenRequest.HTTPMethod = "GET"
        clientTokenRequest.addValue("text/plain", forHTTPHeaderField: "Accept")
        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: {data, response, error -> Void in
//            if error != nil {
//                println(error.localizedDescription)
//            }
//            self.tokenResponse = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
//            println(self.tokenResponse)
//        })
//        task.resume()
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: buildBrainTree)
        task.resume()

    }
    
    func buildBrainTree(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        if error != nil {
            println(error.localizedDescription)
        }
        
        self.tokenResponse = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        self.braintree = Braintree(clientToken: self.tokenResponse)
        println(self.tokenResponse)

    }
    
    func userDidCancelPayment() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postNonce(paymentMethodNonce: String) {
        
        let paymentURL = NSURL(string: "https://braintree-homey-cltsang.c9.io/payment-methods")
        let request = NSMutableURLRequest(URL: paymentURL!)
        request.HTTPMethod = "POST"
        var bodyString = "payment_method_nonce=%@\(paymentMethodNonce)"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: noncePosted)
        task.resume()
        
    }
    
    func noncePosted(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        println(response)
    }

    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!){
        postNonce(paymentMethod.nonce)
    }
    
    /// Informs the delegate when the user has decided to cancel out of the Drop In payment form.
    ///
    /// Drop In handles its own error cases, so this cancelation is user initiated and
    /// irreversable. Upon receiving this message, you should dismiss Drop In.
    ///
    /// @param viewController The Drop In view controller informing its delegate of failure.
    /// @param error An error that describes the failure.
    
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!){
        
    }
    
    /// Informs the delegate when the user has entered or selected payment information.
    ///
    /// @param viewController The Drop In view controller informing its delegate
    
    func dropInViewControllerWillComplete(viewController: BTDropInViewController!){
    }
}

