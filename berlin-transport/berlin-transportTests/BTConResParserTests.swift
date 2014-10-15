import Quick
import Nimble
import berlin_transport

class BTConResParserTests: QuickSpec {
    override func spec() {
        describe("The ConRes parser", {
            context("when it is initialized", {
                let conns = BTConResParser().getConnections()
                let connection = conns.first!
                it("it should return an NSTimeInterval for the travel time", {
                    expect(connection.travelTime).to(equal(32*60))
                })
            })
        })
    }
}
