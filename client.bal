// Copyright (c) 2025, ERP Omni Module
// Abstract Client Interface for ERP Systems

// ============================================================================
// ABSTRACT ERP CLIENT INTERFACE
// ============================================================================

// Abstract client object that defines the unified interface for all ERP systems.
// Vendor-specific implementations (SAP, NetSuite, Dynamics, Odoo) should implement
// this client object to provide a consistent API across different ERP platforms.
public client class ErpClient {

    // ========================================================================
    // PURCHASE ORDER OPERATIONS
    // ========================================================================

    // Creates a new purchase order in the ERP system
    // 
    // + purchaseOrder - The canonical purchase order to create
    // + return - The vendor's internal PO ID on success, or an error
    remote function createPurchaseOrder(PurchaseOrder purchaseOrder) returns string|ErpError {
        return error NotImplementedError("createPurchaseOrder not implemented");
    }

    // Retrieves a purchase order by its ID
    // 
    // + id - The vendor's internal PO ID
    // + return - The canonical purchase order on success, or an error
    remote function getPurchaseOrder(string id) returns PurchaseOrder|ErpError {
        return error NotImplementedError("getPurchaseOrder not implemented");
    }

    // Updates an existing purchase order
    // 
    // + id - The vendor's internal PO ID
    // + purchaseOrder - The updated canonical purchase order
    // + return - The vendor's internal PO ID on success, or an error
    remote function updatePurchaseOrder(string id, PurchaseOrder purchaseOrder) returns string|ErpError {
        return error NotImplementedError("updatePurchaseOrder not implemented");
    }

    // Deletes or cancels a purchase order
    // 
    // + id - The vendor's internal PO ID
    // + return - () on success, or an error
    remote function deletePurchaseOrder(string id) returns ErpError? {
        return error NotImplementedError("deletePurchaseOrder not implemented");
    }

    // Lists purchase orders with optional filtering
    // 
    // + filter - Optional filter parameters (vendor-specific)
    // + return - Array of canonical purchase orders on success, or an error
    remote function listPurchaseOrders(map<string>? filter = ()) returns PurchaseOrder[]|ErpError {
        return error NotImplementedError("listPurchaseOrders not implemented");
    }

    // ========================================================================
    // INVOICE OPERATIONS
    // ========================================================================

    // Creates a new invoice in the ERP system
    // 
    // + invoice - The canonical invoice to create
    // + return - The vendor's internal invoice ID on success, or an error
    remote function createInvoice(Invoice invoice) returns string|ErpError {
        return error NotImplementedError("createInvoice not implemented");
    }

    // Retrieves an invoice by its ID
    // 
    // + id - The vendor's internal invoice ID
    // + return - The canonical invoice on success, or an error
    remote function getInvoice(string id) returns Invoice|ErpError {
        return error NotImplementedError("getInvoice not implemented");
    }

    // Updates an existing invoice
    // 
    // + id - The vendor's internal invoice ID
    // + invoice - The updated canonical invoice
    // + return - The vendor's internal invoice ID on success, or an error
    remote function updateInvoice(string id, Invoice invoice) returns string|ErpError {
        return error NotImplementedError("updateInvoice not implemented");
    }

    // Deletes or voids an invoice
    // 
    // + id - The vendor's internal invoice ID
    // + return - () on success, or an error
    remote function deleteInvoice(string id) returns ErpError? {
        return error NotImplementedError("deleteInvoice not implemented");
    }

    // Lists invoices with optional filtering
    // 
    // + filter - Optional filter parameters (vendor-specific)
    // + return - Array of canonical invoices on success, or an error
    remote function listInvoices(map<string>? filter = ()) returns Invoice[]|ErpError {
        return error NotImplementedError("listInvoices not implemented");
    }

    // ========================================================================
    // CUSTOMER OPERATIONS
    // ========================================================================

    // Creates a new customer in the ERP system
    // 
    // + customer - The canonical customer to create
    // + return - The vendor's internal customer ID on success, or an error
    remote function createCustomer(Customer customer) returns string|ErpError {
        return error NotImplementedError("createCustomer not implemented");
    }

    // Retrieves a customer by their ID
    // 
    // + id - The vendor's internal customer ID
    // + return - The canonical customer on success, or an error
    remote function getCustomer(string id) returns Customer|ErpError {
        return error NotImplementedError("getCustomer not implemented");
    }

    // Updates an existing customer
    // 
    // + id - The vendor's internal customer ID
    // + customer - The updated canonical customer
    // + return - The vendor's internal customer ID on success, or an error
    remote function updateCustomer(string id, Customer customer) returns string|ErpError {
        return error NotImplementedError("updateCustomer not implemented");
    }

    // Deletes or deactivates a customer
    // 
    // + id - The vendor's internal customer ID
    // + return - () on success, or an error
    remote function deleteCustomer(string id) returns ErpError? {
        return error NotImplementedError("deleteCustomer not implemented");
    }

    // Lists customers with optional filtering
    // 
    // + filter - Optional filter parameters (vendor-specific)
    // + return - Array of canonical customers on success, or an error
    remote function listCustomers(map<string>? filter = ()) returns Customer[]|ErpError {
        return error NotImplementedError("listCustomers not implemented");
    }

    // ========================================================================
    // VENDOR OPERATIONS
    // ========================================================================

    // Creates a new vendor in the ERP system
    // 
    // + vendor - The canonical vendor to create
    // + return - The vendor's internal vendor ID on success, or an error
    remote function createVendor(Vendor vendor) returns string|ErpError {
        return error NotImplementedError("createVendor not implemented");
    }

    // Retrieves a vendor by their ID
    // 
    // + id - The vendor's internal vendor ID
    // + return - The canonical vendor on success, or an error
    remote function getVendor(string id) returns Vendor|ErpError {
        return error NotImplementedError("getVendor not implemented");
    }

    // Updates an existing vendor
    // 
    // + id - The vendor's internal vendor ID
    // + vendor - The updated canonical vendor
    // + return - The vendor's internal vendor ID on success, or an error
    remote function updateVendor(string id, Vendor vendor) returns string|ErpError {
        return error NotImplementedError("updateVendor not implemented");
    }

    // Deletes or deactivates a vendor
    // 
    // + id - The vendor's internal vendor ID
    // + return - () on success, or an error
    remote function deleteVendor(string id) returns ErpError? {
        return error NotImplementedError("deleteVendor not implemented");
    }

    // Lists vendors with optional filtering
    // 
    // + filter - Optional filter parameters (vendor-specific)
    // + return - Array of canonical vendors on success, or an error
    remote function listVendors(map<string>? filter = ()) returns Vendor[]|ErpError {
        return error NotImplementedError("listVendors not implemented");
    }

    // ========================================================================
    // PRODUCT OPERATIONS
    // ========================================================================

    // Creates a new product in the ERP system
    // 
    // + product - The canonical product to create
    // + return - The vendor's internal product ID on success, or an error
    remote function createProduct(Product product) returns string|ErpError {
        return error NotImplementedError("createProduct not implemented");
    }

    // Retrieves a product by its ID
    // 
    // + id - The vendor's internal product ID
    // + return - The canonical product on success, or an error
    remote function getProduct(string id) returns Product|ErpError {
        return error NotImplementedError("getProduct not implemented");
    }

    // Updates an existing product
    // 
    // + id - The vendor's internal product ID
    // + product - The updated canonical product
    // + return - The vendor's internal product ID on success, or an error
    remote function updateProduct(string id, Product product) returns string|ErpError {
        return error NotImplementedError("updateProduct not implemented");
    }

    // Deletes or deactivates a product
    // 
    // + id - The vendor's internal product ID
    // + return - () on success, or an error
    remote function deleteProduct(string id) returns ErpError? {
        return error NotImplementedError("deleteProduct not implemented");
    }

    // Lists products with optional filtering
    // 
    // + filter - Optional filter parameters (vendor-specific)
    // + return - Array of canonical products on success, or an error
    remote function listProducts(map<string>? filter = ()) returns Product[]|ErpError {
        return error NotImplementedError("listProducts not implemented");
    }
}

// Error type for unimplemented methods
type NotImplementedError distinct ErpError;
