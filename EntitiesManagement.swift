//
//  EntitiesManagement.swift
// Zeno
//
//  Created by apple on 02/12/21.
//

import Foundation
import CoreData
import UIKit

//MARK: - retrieveDelegate
protocol retrieveDelegate {
    func gotsmStoredInfo(DataArray : [smMeasurementModel])
    func gotcmStoredInfo(DataArray : [cmMeasurementModel])
    func gotalStoredInfo(DataArray : [alMeasurementModel])
    func gotsfStoredInfo(DataArray : [sfMeasurementModel])
    func gotmeshsmStoredInfo(DataArray : [meshsmMeasurementModel])
}

let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
let context = appDelegate.persistentContainer.viewContext

class Entities {
    
    static let sharedInstance = Entities()
    var delegate : retrieveDelegate?
    
    //MARK: - Add projects info
    func addprojectsinfoToLocal(projectid: String, projectname: String, Phonenumber: String, countrycode: String , customername: String, email: String, StreetNumber: String,zipcodecity : String , country :String, createdtimestamp: String ) {
        do
        {
            let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
            fetchRequest.predicate = NSPredicate(format: "projectid = %@", projectid)
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            
            if data.count >  0 { //Existing Project
                
                data[0].projectid = projectid
                data[0].projectname = projectname
                data[0].customername = customername
                data[0].streetnumber = StreetNumber
                data[0].zipcodecity = zipcodecity
                data[0].country = country
                data[0].phonenumber = Phonenumber
                data[0].email = email
                data[0].createdtimestamp = createdtimestamp
                data[0].countrycode = countrycode
                
            }  else { //New Project
                
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.projectid = projectid
                ProjectInfo.projectname = projectname
                ProjectInfo.customername = customername
                ProjectInfo.streetnumber = StreetNumber
                ProjectInfo.zipcodecity = zipcodecity
                ProjectInfo.country = country
                ProjectInfo.phonenumber = Phonenumber
                ProjectInfo.email = email
                ProjectInfo.createdtimestamp = createdtimestamp
                ProjectInfo.countrycode = countrycode
            }
            
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - retrieve All Existing projects info
    func retrieveExistingProjects() -> ([Project]){
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        var returnArray = [Project]()
        do{
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            if data.count >  0 {
                for i in 0..<data.count {
                    returnArray.append(data[i])
                }
            }
            
        } catch let fetchErr{
            print("Failed to fetch retrieveExistingProjects: ", fetchErr)
        }
        return returnArray
    }
    
    //MARK: - Add SM data To Local
    func addSmDataToLocal(DataArray : [smMeasurementModel] ) {
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do
        {
            let smMeasurementModelArray:[String:[smMeasurementModel]] = ["smMeasurementModelArray": DataArray]
            let jsonData = try! JSONEncoder().encode(smMeasurementModelArray)  //Convert Dictionary to JSON
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            if data.count >  0 {
                data[0].smdataCount = DataArray.count.description //Measuremnts counts to show in project details page
                
                for i in 0..<data.count {
                    data[i].smdata = jsonData
                }
            }  else {
                
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.smdata = jsonData
                
            }
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    
    //MARK: - Add Mesh SM data To Local
    func addMeshSmDataToLocal(DataArray : [meshsmMeasurementModel] ) {
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do
        {
            let meshsmMeasurementModelArray:[String:[meshsmMeasurementModel]] = ["meshsmMeasurementModelArray": DataArray]
            let jsonData = try! JSONEncoder().encode(meshsmMeasurementModelArray)  //Convert Dictionary to JSON
            
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            if data.count >  0 {
                data[0].meshsmdataCount = DataArray.count.description //Measuremnts counts to show in project details page
                
                for i in 0..<data.count {
                    data[i].meshsmdata = jsonData
                }
            }  else {
                
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.smdata = jsonData
                
            }
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - Add CM data To Local
    func addcmDataToLocal(DataArray : [cmMeasurementModel] ) {
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do
        {
            let allMeasurementDataArray:[String:[cmMeasurementModel]] = ["cmMeasurementModelArray": DataArray]
            let jsonData = try! JSONEncoder().encode(allMeasurementDataArray)  //Convert Dictionary to JSON
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            
            if data.count >  0 {
                data[0].cmdataCount = DataArray.count.description //Measuremnts counts to show in project details page
                for i in 0..<data.count {
                    data[i].cmdata = jsonData
                }
            }  else {
                
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.cmdata = jsonData
            }
            
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - Add AL data To Local
    func addalDataToLocal(DataArray : [alMeasurementModel] ) {
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do
        {
            let allMeasurementDataArray:[String:[alMeasurementModel]] = ["alMeasurementModelArray": DataArray]
            let jsonData = try! JSONEncoder().encode(allMeasurementDataArray)  //Convert Dictionary to JSON
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            
            if data.count >  0 {
                data[0].aldataCount = DataArray.count.description //Measuremnts counts to show in project details page
                for i in 0..<data.count {
                    data[i].aldata = jsonData
                }
            }  else {
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.aldata = jsonData
            }
            
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - Add SF data To Local
    func addsfDataToLocal(DataArray : [sfMeasurementModel] ) {
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do
        {
            let allMeasurementDataArray:[String:[sfMeasurementModel]] = ["sfMeasurementModelArray": DataArray]
            let jsonData = try! JSONEncoder().encode(allMeasurementDataArray)  //Convert Dictionary to JSON
            
            let retrievedata = try context.fetch(fetchRequest)
            let data = retrievedata
            
            if data.count >  0 {
                data[0].sfDataCount = DataArray.count.description //Measuremnts counts to show in project details page
                for i in 0..<data.count {
                    data[i].sfdata = jsonData
                }
            } else {
                
                let ProjectInfo = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! Project
                ProjectInfo.sfdata = jsonData
            }
            do{
                try context.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    //MARK: - retrieve Measurements Data
    func retrieveData(type : MeasurementType){
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.predicate = NSPredicate(format: "projectid = %@", UserDefaultsClass.shared.getProjectId()!)
        do{
            let retrievedata = try context.fetch(fetchRequest)
            
            switch type {
                
            case .MeshSM:
                
                for i in 0..<retrievedata.count{
                    if  let JsonData = retrievedata[i].meshsmdata {
                        
                        let result = try! JSONDecoder().decode([String: [meshsmMeasurementModel]].self, from: JsonData)
                        
                        if let meshsmMeasurementModelArray = result["meshsmMeasurementModelArray"]
                        {
                            var dataArray : [meshsmMeasurementModel] = []
                            for singleStd in meshsmMeasurementModelArray{
                                dataArray.append(singleStd)
                            }
                            self.delegate?.gotmeshsmStoredInfo(DataArray: dataArray)
                            
                        } else { return }
                    } else { return }
                }
                
            case .SM:
                
                for i in 0..<retrievedata.count{
                    if  let JsonData = retrievedata[i].smdata {
                        
                        let result = try! JSONDecoder().decode([String: [smMeasurementModel]].self, from: JsonData)
                        
                        if let smMeasurementModelArray = result["smMeasurementModelArray"]
                        {
                            var dataArray : [smMeasurementModel] = []
                            for singleStd in smMeasurementModelArray{
                                dataArray.append(singleStd)
                            }
                            self.delegate?.gotsmStoredInfo(DataArray: dataArray)
                            
                        } else { return }
                    } else { return }
                }
                
            case .CM:
                
                for i in 0..<retrievedata.count{
                    
                    if let JsonData = retrievedata[i].cmdata{
                        
                        let result = try! JSONDecoder().decode([String: [cmMeasurementModel]].self, from: JsonData)
                        
                        if let cmMeasurementModelArray = result["cmMeasurementModelArray"]
                        {
                            var dataArray : [cmMeasurementModel] = []
                            for element in cmMeasurementModelArray{
                                dataArray.append(element)
                            }
                            self.delegate?.gotcmStoredInfo(DataArray: dataArray)
                            
                        } else { return }
                    } else { return }
                }
                
            case .AL:
                for i in 0..<retrievedata.count{
                    if let JsonData = retrievedata[i].aldata{
                        let result = try! JSONDecoder().decode([String: [alMeasurementModel]].self, from: JsonData)
                        
                        if let alMeasurementModelArray = result["alMeasurementModelArray"]
                        {
                            var dataArray : [alMeasurementModel] = []
                            for element in alMeasurementModelArray{
                                dataArray.append(element)
                            }
                            self.delegate?.gotalStoredInfo(DataArray: dataArray)
                            
                        } else { return }
                    } else { return }
                }
                
            case .SF:
                for i in 0..<retrievedata.count{
                    if let JsonData = retrievedata[i].sfdata{
                        
                        let result = try! JSONDecoder().decode([String: [sfMeasurementModel]].self, from: JsonData)
                        
                        if let alMeasurementModelArray = result["sfMeasurementModelArray"]
                        {
                            var dataArray : [sfMeasurementModel] = []
                            for element in alMeasurementModelArray{
                                dataArray.append(element)
                            }
                            self.delegate?.gotsfStoredInfo(DataArray: dataArray)
                            
                        } else { return }
                    }  else { return }
                }
            default:
                print("default")
            }
            
        } catch let fetchErr{
            print("Failed to fetch companiess: ", fetchErr)
        }
    }
    
}
