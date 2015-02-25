import Quick
import Nimble
import berlin_transport


class BTConReqBuilderTests: QuickSpec {
    override func spec() {
        describe("The date and time printer") {
            context("when given my birthday") {
                let comps = NSDateComponents()
                let calendar = NSCalendar.currentCalendar()
                comps.year = 1980
                comps.month = 1
                comps.day = 1
                comps.hour = 11
                comps.minute = 15
                comps.second = 30
                
                let date = calendar.dateFromComponents(comps)
                println(date)
                
                let output = BTRequestBuilder.requestDataFromDate(date!)
                
//                it("should print the correct date string") {
//                    expect(output.day).to(equal("19800101"))
//                }
//                
//                it("should print the correct time string") {
//                    expect(output.time).to(equal("11:15:30"))
//                }
            }
        }

    }
}
