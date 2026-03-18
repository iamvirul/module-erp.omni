// Copyright (c) 2025, ERP Omni Module
// Test cases for ErpClient interface

import ballerina/test;

// Mock implementation of ErpClient for testing
client class MockErpClient {
    *ErpClient;

    private map<PurchaseOrder> purchaseOrders = {};
    private map<Invoice> invoices = {};
    private map<Customer> customers = {};
    private map<Vendor> vendors = {};
    private map<Product> products = {};

    // Purchase Order Operations
    remote function createPurchaseOrder(PurchaseOrder purchaseOrder) returns string|ErpError {
        string id = purchaseOrder.id;
        self.purchaseOrders[id] = purchaseOrder;
        return id;
    }

    remote function getPurchaseOrder(string id) returns PurchaseOrder|ErpError {
        PurchaseOrder? po = self.purchaseOrders[id];
        if po is () {
            return error NotFoundError(string `Purchase Order ${id} not found`);
        }
        return po;
    }

    remote function updatePurchaseOrder(string id, PurchaseOrder purchaseOrder) returns string|ErpError {
        if !self.purchaseOrders.hasKey(id) {
            return error NotFoundError(string `Purchase Order ${id} not found`);
        }
        self.purchaseOrders[id] = purchaseOrder;
        return id;
    }

    remote function deletePurchaseOrder(string id) returns ErpError? {
        if !self.purchaseOrders.hasKey(id) {
            return error NotFoundError(string `Purchase Order ${id} not found`);
        }
        _ = self.purchaseOrders.remove(id);
        return ();
    }

    remote function listPurchaseOrders(map<string>? filter = ()) returns PurchaseOrder[]|ErpError {
        return self.purchaseOrders.toArray();
    }

    // Invoice Operations
    remote function createInvoice(Invoice invoice) returns string|ErpError {
        string id = invoice.id;
        self.invoices[id] = invoice;
        return id;
    }

    remote function getInvoice(string id) returns Invoice|ErpError {
        Invoice? invoice = self.invoices[id];
        if invoice is () {
            return error NotFoundError(string `Invoice ${id} not found`);
        }
        return invoice;
    }

    remote function updateInvoice(string id, Invoice invoice) returns string|ErpError {
        if !self.invoices.hasKey(id) {
            return error NotFoundError(string `Invoice ${id} not found`);
        }
        self.invoices[id] = invoice;
        return id;
    }

    remote function deleteInvoice(string id) returns ErpError? {
        if !self.invoices.hasKey(id) {
            return error NotFoundError(string `Invoice ${id} not found`);
        }
        _ = self.invoices.remove(id);
        return ();
    }

    remote function listInvoices(map<string>? filter = ()) returns Invoice[]|ErpError {
        return self.invoices.toArray();
    }

    // Customer Operations
    remote function createCustomer(Customer customer) returns string|ErpError {
        string id = customer.id;
        self.customers[id] = customer;
        return id;
    }

    remote function getCustomer(string id) returns Customer|ErpError {
        Customer? customer = self.customers[id];
        if customer is () {
            return error NotFoundError(string `Customer ${id} not found`);
        }
        return customer;
    }

    remote function updateCustomer(string id, Customer customer) returns string|ErpError {
        if !self.customers.hasKey(id) {
            return error NotFoundError(string `Customer ${id} not found`);
        }
        self.customers[id] = customer;
        return id;
    }

    remote function deleteCustomer(string id) returns ErpError? {
        if !self.customers.hasKey(id) {
            return error NotFoundError(string `Customer ${id} not found`);
        }
        _ = self.customers.remove(id);
        return ();
    }

    remote function listCustomers(map<string>? filter = ()) returns Customer[]|ErpError {
        return self.customers.toArray();
    }

    // Vendor Operations
    remote function createVendor(Vendor vendor) returns string|ErpError {
        string id = vendor.id;
        self.vendors[id] = vendor;
        return id;
    }

    remote function getVendor(string id) returns Vendor|ErpError {
        Vendor? vendor = self.vendors[id];
        if vendor is () {
            return error NotFoundError(string `Vendor ${id} not found`);
        }
        return vendor;
    }

    remote function updateVendor(string id, Vendor vendor) returns string|ErpError {
        if !self.vendors.hasKey(id) {
            return error NotFoundError(string `Vendor ${id} not found`);
        }
        self.vendors[id] = vendor;
        return id;
    }

    remote function deleteVendor(string id) returns ErpError? {
        if !self.vendors.hasKey(id) {
            return error NotFoundError(string `Vendor ${id} not found`);
        }
        _ = self.vendors.remove(id);
        return ();
    }

    remote function listVendors(map<string>? filter = ()) returns Vendor[]|ErpError {
        return self.vendors.toArray();
    }

    // Product Operations
    remote function createProduct(Product product) returns string|ErpError {
        string id = product.id;
        self.products[id] = product;
        return id;
    }

    remote function getProduct(string id) returns Product|ErpError {
        Product? product = self.products[id];
        if product is () {
            return error NotFoundError(string `Product ${id} not found`);
        }
        return product;
    }

    remote function updateProduct(string id, Product product) returns string|ErpError {
        if !self.products.hasKey(id) {
            return error NotFoundError(string `Product ${id} not found`);
        }
        self.products[id] = product;
        return id;
    }

    remote function deleteProduct(string id) returns ErpError? {
        if !self.products.hasKey(id) {
            return error NotFoundError(string `Product ${id} not found`);
        }
        _ = self.products.remove(id);
        return ();
    }

    remote function listProducts(map<string>? filter = ()) returns Product[]|ErpError {
        return self.products.toArray();
    }
}

// Test Purchase Order Operations
@test:Config {}
function testCreatePurchaseOrder() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder po = {
        id: "PO-001",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    string|ErpError result = mockClient->createPurchaseOrder(po);
    test:assertTrue(result is string, msg = "Should successfully create PO");
    test:assertEquals(result, "PO-001", msg = "Should return PO ID");
}

@test:Config {}
function testGetPurchaseOrder() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder po = {
        id: "PO-002",
        poNumber: "PO-2025-002",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 2000.00,
        grandTotal: 2000.00,
        status: "APPROVED"
    };
    
    _ = check mockClient->createPurchaseOrder(po);
    
    PurchaseOrder|ErpError retrieved = mockClient->getPurchaseOrder("PO-002");
    test:assertTrue(retrieved is PurchaseOrder, msg = "Should retrieve PO");
    
    if retrieved is PurchaseOrder {
        test:assertEquals(retrieved.poNumber, "PO-2025-002", msg = "PO number should match");
        test:assertEquals(retrieved.status, "APPROVED", msg = "Status should match");
    }
}

@test:Config {}
function testGetPurchaseOrderNotFound() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder|ErpError result = mockClient->getPurchaseOrder("NON-EXISTENT");
    test:assertTrue(result is NotFoundError, msg = "Should return NotFoundError");
}

@test:Config {}
function testUpdatePurchaseOrder() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder po = {
        id: "PO-003",
        poNumber: "PO-2025-003",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    _ = check mockClient->createPurchaseOrder(po);
    
    PurchaseOrder updatedPo = {
        id: po.id,
        poNumber: po.poNumber,
        orderDate: po.orderDate,
        currency: po.currency,
        vendor: po.vendor,
        items: po.items,
        subtotal: po.subtotal,
        grandTotal: po.grandTotal,
        status: "APPROVED"
    };
    
    string|ErpError result = mockClient->updatePurchaseOrder("PO-003", updatedPo);
    test:assertTrue(result is string, msg = "Should successfully update PO");
    
    PurchaseOrder|ErpError retrieved = mockClient->getPurchaseOrder("PO-003");
    if retrieved is PurchaseOrder {
        test:assertEquals(retrieved.status, "APPROVED", msg = "Status should be updated");
    }
}

@test:Config {}
function testDeletePurchaseOrder() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder po = {
        id: "PO-004",
        poNumber: "PO-2025-004",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    _ = check mockClient->createPurchaseOrder(po);
    
    ErpError? deleteResult = mockClient->deletePurchaseOrder("PO-004");
    test:assertTrue(deleteResult is (), msg = "Should successfully delete PO");
    
    PurchaseOrder|ErpError getResult = mockClient->getPurchaseOrder("PO-004");
    test:assertTrue(getResult is NotFoundError, msg = "Deleted PO should not be found");
}

@test:Config {}
function testListPurchaseOrders() returns error? {
    MockErpClient mockClient = new;
    
    PurchaseOrder po1 = {
        id: "PO-005",
        poNumber: "PO-2025-005",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    PurchaseOrder po2 = {
        id: "PO-006",
        poNumber: "PO-2025-006",
        orderDate: po1.orderDate,
        currency: po1.currency,
        vendor: po1.vendor,
        items: po1.items,
        subtotal: po1.subtotal,
        grandTotal: po1.grandTotal,
        status: po1.status
    };
    
    _ = check mockClient->createPurchaseOrder(po1);
    _ = check mockClient->createPurchaseOrder(po2);
    
    PurchaseOrder[]|ErpError result = mockClient->listPurchaseOrders();
    test:assertTrue(result is PurchaseOrder[], msg = "Should return list of POs");
    
    if result is PurchaseOrder[] {
        test:assertEquals(result.length(), 2, msg = "Should have 2 POs");
    }
}

// Test Invoice Operations
@test:Config {}
function testCreateAndGetInvoice() returns error? {
    MockErpClient mockClient = new;
    
    Invoice invoice = {
        id: "INV-001",
        invoiceNumber: "INV-2025-001",
        invoiceDate: "2025-01-15",
        currency: "USD",
        customer: {
            id: "C-001",
            name: "Test Customer",
            billingAddress: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        amountDue: 1000.00,
        paymentTerms: {
            terms: "NET30",
            dueDays: 30
        },
        status: "DRAFT"
    };
    
    string|ErpError createResult = mockClient->createInvoice(invoice);
    test:assertTrue(createResult is string, msg = "Should create invoice");
    
    Invoice|ErpError getResult = mockClient->getInvoice("INV-001");
    test:assertTrue(getResult is Invoice, msg = "Should retrieve invoice");
}

// Test Customer Operations
@test:Config {}
function testCreateAndGetCustomer() returns error? {
    MockErpClient mockClient = new;
    
    Customer customer = {
        id: "C-001",
        name: "Test Customer",
        billingAddress: {
            street1: "123 St",
            city: "City",
            postalCode: "12345",
            country: "US"
        },
        contactDetails: {},
        currency: "USD"
    };
    
    string|ErpError createResult = mockClient->createCustomer(customer);
    test:assertTrue(createResult is string, msg = "Should create customer");
    
    Customer|ErpError getResult = mockClient->getCustomer("C-001");
    test:assertTrue(getResult is Customer, msg = "Should retrieve customer");
}

// Test Vendor Operations
@test:Config {}
function testCreateAndGetVendor() returns error? {
    MockErpClient mockClient = new;
    
    Vendor vendor = {
        id: "V-001",
        name: "Test Vendor",
        address: {
            street1: "123 St",
            city: "City",
            postalCode: "12345",
            country: "US"
        },
        contactDetails: {},
        currency: "USD"
    };
    
    string|ErpError createResult = mockClient->createVendor(vendor);
    test:assertTrue(createResult is string, msg = "Should create vendor");
    
    Vendor|ErpError getResult = mockClient->getVendor("V-001");
    test:assertTrue(getResult is Vendor, msg = "Should retrieve vendor");
}

// Test Product Operations
@test:Config {}
function testCreateAndGetProduct() returns error? {
    MockErpClient mockClient = new;
    
    Product product = {
        id: "PROD-001",
        sku: "WIDGET-001",
        name: "Test Widget",
        unitPrice: 99.99,
        active: true
    };
    
    string|ErpError createResult = mockClient->createProduct(product);
    test:assertTrue(createResult is string, msg = "Should create product");
    
    Product|ErpError getResult = mockClient->getProduct("PROD-001");
    test:assertTrue(getResult is Product, msg = "Should retrieve product");
}

// Test Error Types
@test:Config {}
function testErrorTypes() {
    ErpError baseError = error ErpError("Base error");
    test:assertTrue(baseError is ErpError, msg = "Should be ErpError");
    
    AuthenticationError authError = error AuthenticationError("Auth failed");
    test:assertTrue(authError is ErpError, msg = "AuthenticationError should be ErpError");
    
    NotFoundError notFoundError = error NotFoundError("Not found");
    test:assertTrue(notFoundError is ErpError, msg = "NotFoundError should be ErpError");
    
    TransformationError transformError = error TransformationError("Transform failed");
    test:assertTrue(transformError is ErpError, msg = "TransformationError should be ErpError");
}
