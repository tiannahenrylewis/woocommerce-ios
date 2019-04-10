import XCTest
@testable import WooCommerce

final class ManualTrackingViewControllerTests: XCTestCase {
    private var subject: ManualTrackingViewController?
    private var viewModel: ManualTrackingViewModel?

    private struct MockData {
        static let siteID = 1234
        static let orderID = 5678
    }

    override func setUp() {
        super.setUp()
        viewModel = AddTrackingViewModel(siteID: MockData.siteID, orderID: MockData.orderID)
        subject = ManualTrackingViewController(viewModel: viewModel!)
        // Force the VC to load the xib
        let _ = subject?.view
    }

    override func tearDown() {
        subject = nil
        viewModel = nil
        super.tearDown()
    }

    func testTitleMatchesViewModel() {
        XCTAssertEqual(subject?.title, viewModel?.title)
    }

    func testLeftBarButtonItemIsLabelledDismiss() {
        let leftBarButton = subject?.navigationItem.leftBarButtonItem

        XCTAssertEqual(leftBarButton?.title, "Dismiss")
    }

    func testRightBarButtonItemIsLabelledAccordingToViewModel() {
        let rightBarButton = subject?.navigationItem.rightBarButtonItem

        XCTAssertEqual(rightBarButton?.title, viewModel?.primaryActionTitle)
    }

    func testBackButtonItemIsConfiguredAsEmpty() {
        let backBarButton = subject?.navigationItem.backBarButtonItem

        XCTAssertEqual(backBarButton?.title, String())
    }

    func testVCIsTableViewDataSource() {
        let table = subject?.getTable()
        let dataSource = table?.dataSource as? ManualTrackingViewController

        XCTAssertEqual(dataSource, subject)
    }

    func testVCIsTableViewDelegate() {
        let table = subject?.getTable()
        let delegate = table?.delegate as? ManualTrackingViewController

        XCTAssertEqual(delegate, subject)
    }

    func testVCBackgroundColorIsSet() {
        XCTAssertEqual(subject?.view.backgroundColor, StyleManager.tableViewBackgroundColor)
    }
}