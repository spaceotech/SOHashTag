
import UIKit

public extension UIView {
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil, type: self)
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    public class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textView: UITextView!
    
    var viewOuter : HashTagTableViewCell!
    var arrValues = ["Hi", "Hello", "Honest", "Ok", "Now", "today", "yesterday", "currently", "sunday", "monday", "tuesday", "wednesday", "thrusaday", "Friday", "saturday"]
    var arrSearched = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor

        viewOuter = HashTagTableViewCell.fromNib()
        viewOuter.hidden = true
        viewOuter.tableView.delegate = self
        viewOuter.tableView.dataSource = self

        viewOuter.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        arrSearched = arrValues
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        textView.inputAccessoryView = viewOuter
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearched.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        cell.textLabel?.text = "#" + arrSearched[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        viewOuter.hidden = true
        let textViewTmp = textView.text
        
        var strNewText = textViewTmp.componentsSeparatedByString("#")
        if strNewText.count > 1 {
            strNewText[strNewText.count - 1] = arrSearched[indexPath.row]
        }
        let strFinalText = strNewText.joinWithSeparator("#")
        textView.text = strFinalText.stringByAppendingString(" ")
    }

    //MARK: UITextView Delegate
    func textViewDidChangeSelection(textView: UITextView) {
        let str = textView.text
        if str != "" {
            let lastChar = str[str.endIndex.predecessor()]
            if lastChar == "#" {
                viewOuter.hidden = false
            }
        }
        else {
            viewOuter.hidden = true
        }
        let textviewtext = textView.text
        let new = textviewtext.componentsSeparatedByString("#")
        arrSearched = arrValues.filter({$0.lowercaseString.containsString(new.last!.stringByReplacingOccurrencesOfString("#", withString: "").lowercaseString)})
        viewOuter.tableView.reloadData()
    }
}

