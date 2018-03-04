//
//  Document.swift
//  RaiseMan
//
//  Created by Nate Chandler on 9/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private var KVOContext: Int = 0

@objc class Document: NSDocument, NSWindowDelegate {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayController: NSArrayController!
    @objc dynamic var employees: [Employee] = [] {
        willSet {
            for employee in employees {
                stopObservingEmployee(employee)
            }
        }
        didSet {
            for employee in employees {
                startObservingEmployee(employee)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addEmployee(sender: NSButton) {
        let windowController = windowControllers[0]
        let window = windowController.window!
        
        let endedEditing = window.makeFirstResponder(window)
        if !endedEditing {
            Swift.print("Unable to end editing")
            return
        }
        
        let undo: UndoManager = undoManager!
        
        // Has an edit occurred already in this event?
        if undo.groupingLevel > 0 {
            // Close the last group
            undo.endUndoGrouping()
            // Open a new group
            undo.beginUndoGrouping()
        }
        
        // Create the object
        let employee = arrayController.newObject() as! Employee
        
        // Add it to the array controller's content array
        arrayController.addObject(employee)
        
        // Re-sort (in case the use has sorted a column) 
        arrayController.rearrangeObjects()
        
        // Get the sorted array
        let sortedEmployees = arrayController.arrangedObjects as! [Employee]
        
        // Find the object just added
        let row = sortedEmployees.index(of: employee)!
        
        // Begin the edit in the first column
        Swift.print("starting edit of \(employee) in row \(row)")
        tableView.editColumn(0, row: row, with: nil, select: true)
    }
    
    // MARK: - Accessors
    
    func insertObject(_ employee: Employee, inEmployeesAtIndex index: Int) {
        Swift.print("adding \(employee) to the employees array")
        
        // Add the inverse of this operation to the undo stack
        if let undo = undoManager {
            undo.registerUndo(withTarget: self) { target in
                target.removeObject(fromEmployeesAtIndex: index)
            }
            undo.setActionName("Add Person")
        }
        
        employees.insert(employee, at: index)
    }
    
    func removeObject(fromEmployeesAtIndex index: Int) {
        let employee = employees[index]
        Swift.print("removing \(employee) from the employees array")
        
        // Add the inverse of this operation to the undo stack
        if let undo = undoManager {
            undo.registerUndo(withTarget: self) { target in
                target.insertObject(employee, inEmployeesAtIndex: index)
            }
            undo.setActionName("Remove Person")
        }
        
        employees.remove(at: index)
    }
    
    // MARK: - Key Value Observing
    
    func startObservingEmployee(_ employee: Employee) {
        employee.addObserver(self, forKeyPath: "name", options: .old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .old, context: &KVOContext)
    }
    
    func stopObservingEmployee(_ employee: Employee) {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context != &KVOContext {
            // if the context does not match, this message
            // must be intended for our superclass
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        
        var oldvalue = change?[NSKeyValueChangeKey.oldKey] as AnyObject?
        if oldvalue is NSNull {
            oldvalue = nil
        }
        
        
        // Add the inverse of this operation to the undo stack
        if let undo = undoManager {
            undo.registerUndo(withTarget: self) { target in
                target.setValue(oldvalue, forKeyPath: keyPath!)
            }
            undo.setActionName("Add Person")
        }
    }
    
    // MARK - Lifecycle
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
                                    
    }

    // MARK - NSDocument Overrides
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
        super.windowControllerDidLoadNib(windowController)
    }

    class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name(rawValue: "Document")
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        employees = []
    }
    
}

