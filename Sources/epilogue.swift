// Imports
import Foundation

let env = ProcessInfo.processInfo.environment
let inputStr: String = readLine() ?? "{}"
let json = inputStr.data(using: .utf8, allowLossyConversion: true)!

// snippet of code "injected" (wrapper code for invoking traditional main)
func _run_main(mainFunction: ([String: Any]) -> [String: Any]) -> Void {
    print("------------------------------------------------")
    print("Using traditional style for invoking action...([String: Any]) -> [String: Any]")
    
    let parsed = try! JSONSerialization.jsonObject(with: json, options: []) as! [String: Any]
    let result = mainFunction(parsed)
    if JSONSerialization.isValidJSONObject(result) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: result, options: [])
            if let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {
                print("\(jsonStr)")
            } else {
                print("Error serializing data to JSON, data conversion returns nil string")
            }
        } catch {
            print(("\(error)"))
        }
    } else {
        print("Error serializing JSON, data does not appear to be valid JSON")
    }
}

// snippet of code "injected" (wrapper code for invoking codable main - async - vanilla)
func _run_main<In: Codable, Out: Codable>(mainFunction: (In, (Out?, Error?) -> Void) -> Void) {
    print("------------------------------------------------")
    print("Using codable style for invoking action (async style - vanilla)...")
    
    do {
        let input = try JSONDecoder().decode(In.self, from: json)
        
        let resultHandler = { (out: Out?, error: Error?) in
            if let error = error {
                print("Action handler callback returned an error:", error)
                return
            }
            
            guard let out = out else {
                print("Action handler callback did not return response or error.")
                return
            }
            
            do {
                let jsonData = try JSONEncoder().encode(out)
                let jsonString = String(data: jsonData, encoding: .utf8)
                print("\(jsonString!)")
            } catch let error as EncodingError {
                print("JSONEncoder failed to encode Codable type to JSON string:", error)
                return
            } catch {
                print("Failed to execute action handler with error:", error)
                return
            }
        }
        
        mainFunction(input, resultHandler)
    } catch let error as DecodingError {
        print("JSONDecoder failed to decode JSON string to Codable type:", error)
        return
    } catch {
        print("Failed to execute action handler with error:", error)
        return
    }
}

// snippet of code "injected" (wrapper code for invoking codable main - sync - vanilla)
func _run_main<In: Codable, Out: Codable>(mainFunction: (In) -> Out) -> Void {
    print("------------------------------------------------")
    print("Using codable style for invoking action (sync style - vanilla)...")
    
    do {
        let input = try JSONDecoder().decode(In.self, from: json)
        let out = mainFunction(input)
        let jsonData = try JSONEncoder().encode(out)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print("\(jsonString!)")
    } catch let error as DecodingError {
        print("JSONDecoder failed to decode JSON string to Codable type:", error)
        return
    } catch let error as EncodingError {
        print("JSONEncoder failed to encode Codable type to JSON string:", error)
        return
    } catch {
        print("Failed to execute action handler with error:", error)
        return
    }
}
