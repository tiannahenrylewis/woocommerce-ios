import Foundation
import Alamofire


/// Order: Remote Endpoints
///
public class OrdersRemote: Remote {

    /// Retrieves all of the `Orders` available.
    ///
    /// - Parameters:
    ///     - siteID: Site for which we'll fetch remote orders.
    ///     - pageNumber: Number of page that should be retrieved.
    ///     - pageSize: Number of Orders to be retrieved per page.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func loadAllOrders(for siteID: Int,
                              pageNumber: Int = Defaults.pageNumber,
                              pageSize: Int = Defaults.pageSize,
                              completion: @escaping ([Order]?, Error?) -> Void)
    {
        let path = Constants.ordersPath
        let parameters = [ParameterKeys.page: String(pageNumber),
                          ParameterKeys.perPage: String(pageSize)]
        let request = JetpackRequest(wooApiVersion: .mark2, method: .get, siteID: siteID, path: path, parameters: parameters)
        let mapper = OrderListMapper(siteID: siteID)

        enqueue(request, mapper: mapper, completion: completion)
    }

    /// Retrieves a specific `Order`
    ///
    /// - Parameters:
    ///     - siteID: Site which hosts the Order.
    ///     - orderID: Identifier of the Order.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func loadOrder(for siteID: Int, orderID: Int, completion: @escaping (Order?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/\(orderID)"
        let request = JetpackRequest(wooApiVersion: .mark2, method: .get, siteID: siteID, path: path, parameters: nil)
        let mapper = OrderMapper(siteID: siteID)

        enqueue(request, mapper: mapper, completion: completion)
    }

    /// Retrieves the notes for a specific `Order`
    ///
    /// - Parameters:
    ///     - siteID: Site which hosts the Order.
    ///     - orderID: Identifier of the Order.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func loadOrderNotes(for siteID: Int, orderID: Int, completion: @escaping ([OrderNote]?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/\(orderID)/\(Constants.notesPath)/"
        let request = JetpackRequest(wooApiVersion: .mark2, method: .get, siteID: siteID, path: path, parameters: nil)
        let mapper = OrderNotesMapper()

        enqueue(request, mapper: mapper, completion: completion)
    }

    /// Updates the `OrderStatus` of a given Order.
    ///
    /// - Parameters:
    ///     - siteID: Site which hosts the Order.
    ///     - orderID: Identifier of the Order to be updated.
    ///     - status: New Status to be set.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func updateOrder(from siteID: Int, orderID: Int, status: String, completion: @escaping (Order?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/" + String(orderID)
        let parameters = [ParameterKeys.status: status]
        let mapper = OrderMapper(siteID: siteID)

        let request = JetpackRequest(wooApiVersion: .mark2, method: .post, siteID: siteID, path: path, parameters: parameters)
        enqueue(request, mapper: mapper, completion: completion)
    }

    /// Adds an order note to a specific Order.
    ///
    /// - Parameters:
    ///     - siteID: Site which hosts the Order.
    ///     - orderID: Identifier of the Order to be updated.
    ///     - isCustomerNote: if true, the note will be shown to customers and they will be notified.
    ///                       if false, the note will be for admin reference only. Default is false.
    ///     - note: The note to be posted.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func addOrderNote(for siteID: Int, orderID: Int, isCustomerNote: Bool, with note: String, completion: @escaping (OrderNote?, Error?) -> Void) {
        let path = "\(Constants.ordersPath)/" + String(orderID) + "/" + "\(Constants.notesPath)"
        let parameters = [ParameterKeys.note: note,
                          ParameterKeys.customerNote: String(isCustomerNote)]
        let mapper = OrderNoteMapper()

        let request = JetpackRequest(wooApiVersion: .mark2, method: .post, siteID: siteID, path: path, parameters: parameters)
        enqueue(request, mapper: mapper, completion: completion)
    }
}


// MARK: - Constants!
//
public extension OrdersRemote {
    public enum Defaults {
        public static let pageSize: Int     = 75
        public static let pageNumber: Int   = 1
    }

    private enum Constants {
        static let ordersPath: String       = "orders"
        static let notesPath: String        = "notes"
    }

    private enum ParameterKeys {
        static let customerNote: String     = "customer_note"
        static let note: String             = "note"
        static let page: String             = "page"
        static let perPage: String          = "per_page"
        static let status: String           = "status"
    }
}
