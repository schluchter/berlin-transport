import Quick
import Nimble
import berlin_transport

class BTConResParserTests: QuickSpec {
    override func spec() {
        describe("The ConRes parser", {
            context("when it is initialized", {
                let conns = BTConResParser(fileName: "Antwort_ID_ASCI").getConnections()
                it("should return one or more BTConnection objects") {
                    expect(conns.count).to(equal(7))
                }
                it("should have the correct date for the connection") {

                }
            })
        })
        
        describe("The first connection") {
            let connection = BTConResParser(fileName: "Antwort_ID_ASCI").getConnections().first!
            it("should have one segment") {
                expect(connection.segments?.count).to(equal(1))
            }
            it("should return the duration for the connection") {
                expect(connection.travelTime).to(equal(4*60))
            }
            
            context("and within it, the first segment") {
                let segment = connection.segments?.first!
                
                it("should have the correct values set") {
                    expect(segment?.duration).to(equal(4*60))
//                    expect(segment?.start.displayName).to(contain("Frankfurt (Oder), Bahnhof"))
//                    expect(segment?.end.displayName).to(contain("Frankfurt (Oder), Brunnenplatz"))
                }
                
            }
        }
    }
}
