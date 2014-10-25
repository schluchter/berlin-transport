import Quick
import Nimble
import berlin_transport

class BTConResParserTests: QuickSpec {
    override func spec() {
        describe("The ConRes parser", {
            context("when it is initialized", {
                let conns = BTConResParser(fileName: "Antwort_ID_ASCI").getConnections()
                let connection = conns.first!
                it("should return an NSTimeInterval for the travel time") {
                    expect(connection.travelTime).to(equal(4*60))
                }
                it("should return one or more BTConnection objects") {
                    expect(conns.count) > 0
                }
                it("should have the correct date for the connection") {

                }
            })
        })
    }
}
