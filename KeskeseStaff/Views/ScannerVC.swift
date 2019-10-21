




import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    @IBOutlet weak var tableNumberLbl : UILabel!
    var table: TableResponse? = nil
    
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //        blurView(view: bottomView)
        scanner()
        //        self.performSegue(withIdentifier: "isScannet", sender: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    
    
    func scanner(){
        
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = cameraView.frame
        cameraView.layer.addSublayer(video)
        
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    
                    if (object.stringValue?.contains("\(BASE_URL)/join_table/"))!{
                        
                        let tableCode = object.stringValue?.replace(target: "\(BASE_URL)/join_table/", withString: "")
//                        tableCode!.remove(at: tableCode!.index(before: tableCode!.endIndex))
                        print(tableCode!)
                        self.getTable(code: tableCode!)

                        

                    }
                }
            }
        }
    }
    
    
    
    func getTable(code: String){
        KeskeseStaff.getTablesByCode(code: code).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                let responseList = response.data!.createList(type: TableResponse.self)
                if !responseList.isEmpty{
                    self.table = responseList[0]
                }
                print(response)
                self.tableNumberLbl.text = "\(NSLocalizedString("Table", comment: "")) \(self.table!.table.number)"
                // Поставить текст с номером стола в текстовое поле
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    
    func postAttachNewStaffTable(oldStaffId: Int,tableId: Int, staff: StaffUser){
        
        var tables = staff.tables ?? [Int]()
        
        if !tables.contains(tableId){
            tables.append(tableId)
            print("TABLE APPENDED")
            
        } else {
            // FINISH AND CLOSE WINDOW
            print("TABLE HAS")
            self.navigationController?.popViewController(animated: true)
            session.stopRunning()
            return
        }

        KeskeseStaff.postAttachNewStaffTable(old_staff_id: oldStaffId, new_staff_id: staff.id!, table_id: tableId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                self.session.stopRunning()
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    func patchStaffTable(tableId: Int, staff: StaffUser){
        var tables = staff.tables ?? [Int]()

        if !tables.contains(tableId){
            tables.append(tableId)
            print("TABLE APPENDED")

        } else {
            // FINISH AND CLOSE WINDOW
            print("TABLE HAS")
            self.navigationController?.popViewController(animated: true)
            session.stopRunning()
            return
        }

        KeskeseStaff.patchTablesForStaff(tables: tables, staffID: staff.id!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                KeskeseStaff.staff.tables = tables
                // FINISH AND CLOSE WINDOW
                print("TABLE PATCHED")

                self.navigationController?.popViewController(animated: true)
                self.session.stopRunning()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                self.navigationController?.popViewController(animated: true)
                self.session.stopRunning()
                break
            }
        }
    }
    
    @IBAction func asignBtn(_ sender: Any) {
        if table != nil{
            
            self.postAttachNewStaffTable(oldStaffId: table?.staff.id ?? 0, tableId: table!.table.id
                , staff: KeskeseStaff.staff)
            
        } else {
            view.makeToast(NSLocalizedString("Scan QR-Code", comment: ""))
        }
    }
    
}
