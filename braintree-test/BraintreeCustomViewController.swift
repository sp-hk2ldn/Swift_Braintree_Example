//
//  BraintreeCustomViewController.swift
//  
//
//  Created by Stephen Parker on 21/08/2015.
//
//

import UIKit
import Braintree

class BraintreeCustomViewController: UIViewController, BTDropInViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
