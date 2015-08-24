//
//  BraintreeCustomViewController.swift
//  
//
//  Created by Stephen Parker on 21/08/2015.
//
//

import Stripe
import UIKit
import Braintree

class BraintreeCustomViewController: UIViewController, BTDropInViewControllerDelegate, UITextFieldDelegate, NSObjectProtocol, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    
    var braintree = Braintree()
    var paymentField: STPPaymentCardTextField?
    var tokenResponse: String = ""
    var paymentRequest: BTClientCardRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientTokenURL = NSURL(string: "https://braintree-homey-cltsang.c9.io/client_token")
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL!)
        clientTokenRequest.HTTPMethod = "GET"
        clientTokenRequest.addValue("text/plain", forHTTPHeaderField: "Accept")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(clientTokenRequest, completionHandler: buildBrainTree)
        task.resume()

        paymentField = STPPaymentCardTextField()
        paymentField?.frame = CGRectMake(12, 32, UIScreen.mainScreen().bounds.size.width - 24, UIScreen.mainScreen().bounds.size.height / 12)
        paymentField?.borderColor = UIColor.blueColor()
        paymentField?.textColor = UIColor.greenColor()
        paymentField?.placeholderColor = UIColor.orangeColor()
        paymentField?.delegate = self
        self.containerView.addSubview(paymentField!)
        
        // Do any additional setup after loading the view.
    }

    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) -> Void {
        if textField.valid == true {
            self.paymentRequest = BTClientCardRequest()
            self.paymentRequest?.number = textField.cardNumber
            self.paymentRequest?.expirationMonth = String(textField.expirationMonth)
            self.paymentRequest?.expirationYear = "20\(String(textField.expirationYear))"
            self.paymentRequest?.cvv = textField.cvc
            braintree.tokenizeCard(self.paymentRequest!, completion: printAndPostNonce)
        }
    }
    
    func printAndPostNonce(nonce: String!, error: NSError!) -> Void {
        if error != nil {
            println(error.localizedDescription)
        }
        println("nonce:\(nonce)")
        postNonce(nonce)
    }
    
    func buildBrainTree(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        if error != nil {
            println(error.localizedDescription)
        }
        
        self.tokenResponse = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        self.braintree = Braintree(clientToken: self.tokenResponse)
        println(self.tokenResponse)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!){
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!){  
    }
    
    func dropInViewControllerWillComplete(viewController: BTDropInViewController!){
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
