import Quick
import Nimble
import berlin_trnsprt

class BTConResParserTests: QuickSpec {
    override func spec() {
        describe("The ConRes parser", {
            context("when it is initialized", {
                let conns = BTConResParser(fileName: "Antwort_ID_ASCI").getConnections()
                it("should return one or more BTConnection objects") {
                    expect(conns.count).to(equal(7))
                }
            })
        })
        
        describe("Connections") {
            let connection = BTConResParser(fileName: "Antwort_ID_ASCI").getConnections().first!
            
            it("should have the correct departure time") {
                let df = NSDateFormatter()
                df.dateFormat = "yyyyMMdd hh':'mm':'ss"
                let referenceDate = df.dateFromString("20130416 11:57:00")
                expect(connection.startDate).to(equal(referenceDate))
            }
            
            it("should have the right number of segments") {
                expect(connection.segments?.count).to(equal(1))
            }
            it("should return the duration for the connection") {
                expect(connection.travelTime).to(equal(4 * 60))
            }
            
            context("and within it, the first segment") {
                let segment = connection.segments?.first! as BTJourney
                
                it("should have the correct values set") {
                    expect(segment.duration).to(equal(4*60))
                    expect(segment.start.title).to(equal("Frankfurt (Oder), Bahnhof"))
                    expect(segment.end.title).to(equal("Frankfurt (Oder), Brunnenplatz"))
                    expect(segment.line.serviceTerminus).to(equal("Frankfurt (Oder), Spitzkrug Nord"))

                    expect(segment.line.serviceId.name).to(equal("981"))
                    expect(segment.line.serviceId.serviceType).to(equal(BTServiceDescription.ServiceType.Bus))
                }
                
                it("should have 3 entries in the passList") {
                    expect(segment.passList?.count).to(equal(3))
                }
            }
        }
    }
}
