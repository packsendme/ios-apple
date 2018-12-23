//
//  PhotoProfileViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 20/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class PhotoProfileViewController: UIViewController {

    @IBOutlet weak var titleProfilePhotoLabel: UILabel!
    @IBOutlet weak var gobackBtn: UIBarButtonItem!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var profileimageImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editBtn.title = NSLocalizedString("photoprofile-buttontop-edit", comment:"")
        titleProfilePhotoLabel.text = NSLocalizedString("photoprofile-title-home", comment:"")
   
    }

    @IBAction func editPhotoAction(_ sender: Any) {
        showScrollOptions()
    }
    
    func showScrollOptions() {
        let sheet = UIAlertController(title: "Where to", message: "Where would you like to scroll to?", preferredStyle: .actionSheet)
        
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-deletephoto", comment:""), style: UIAlertActionStyle.cancel, handler:{ (alert: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        });
        
        let takeAction = UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-takephoto", comment:""), style: UIAlertActionStyle.cancel, handler:{ (alert: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        });
        
        let chooseAction = UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-choosephoto", comment:""), style: UIAlertActionStyle.cancel, handler:{ (alert: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        });
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-cancelphoto", comment:""), style: UIAlertActionStyle.cancel, handler:{ (alert: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        });
        
      
        sheet.addAction(deleteAction)
        sheet.addAction(takeAction)
        sheet.addAction(chooseAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
}
