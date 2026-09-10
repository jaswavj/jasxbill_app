import { routerPathNames } from '../../routes/routerPathNames';

export interface MenuItemConfig {
  id: string;
  name: string;
  url?: string;
  icon: string;
  moduleId?: number;
  submenus?: MenuItemConfig[];
}

/** Old JSP user_modules IDs — a menu shows only if the user has that module. */
export const MENU_MODULE = {
  billing: 1,
  master: 2,
  stockReports: 3,
  users: 4,
  inventory: 5,
  accountReports: 6,
  admin: 7,
  statistics: 8,
  credit: 10,
  orderList: 11,
  expense: 12,
} as const;

export const filterMenuByModules = (items: MenuItemConfig[], moduleIds: number[]): MenuItemConfig[] => {
  const allowed = new Set((moduleIds || []).map(Number));
  return items.filter((item) => item.moduleId == null || allowed.has(item.moduleId));
};

export const hasModuleAccess = (moduleIds: number[] | undefined, moduleId: number): boolean =>
  (moduleIds || []).map(Number).includes(moduleId);

/** After login: statistics home first when allowed, otherwise the billing screen. */
export const defaultAppPath = (moduleIds: number[] | undefined): string =>
  hasModuleAccess(moduleIds, MENU_MODULE.statistics)
    ? routerPathNames.dashboard
    : routerPathNames.billing;

export const moduleIdForPath = (pathname: string): number | null => {
  if (pathname.includes('/app/billing')) return MENU_MODULE.billing;
  if (pathname.includes('/app/master')) return MENU_MODULE.master;
  if (pathname.includes('/app/stock-reports')) return MENU_MODULE.stockReports;
  if (pathname.includes('/app/users/change-password')) return null;
  if (pathname.includes('/app/users')) return MENU_MODULE.users;
  if (pathname.includes('/app/inventory')) return MENU_MODULE.inventory;
  if (pathname.includes('/app/account-reports')) return MENU_MODULE.accountReports;
  if (pathname.includes('/app/admin')) return MENU_MODULE.admin;
  if (pathname.includes('/app/statistics')) return MENU_MODULE.statistics;
  if (pathname.includes('/app/credit')) return MENU_MODULE.credit;
  if (pathname.includes('/app/order-list')) return MENU_MODULE.orderList;
  if (pathname.includes('/app/expense')) return MENU_MODULE.expense;
  return null;
};

export const billingMenuConfig: MenuItemConfig[] = [
  {
    id: 'billing',
    name: 'Billing',
    icon: 'fas fa-file-invoice',
    moduleId: MENU_MODULE.billing,
    url: routerPathNames.billing,
  },
  {
    id: 'master',
    name: 'Master',
    icon: 'fas fa-box',
    moduleId: MENU_MODULE.master,
    submenus: [
      { id: 'category', name: 'Category', url: routerPathNames.master.category, icon: 'fas fa-layer-group' },
      { id: 'brands', name: 'Brands', url: routerPathNames.master.brands, icon: 'fas fa-tags' },
      { id: 'product', name: 'Product', url: routerPathNames.master.product, icon: 'fas fa-cube' },
      { id: 'config-material', name: 'Config Product Material', url: routerPathNames.master.configMaterial, icon: 'fas fa-cogs' },
      { id: 'product-master', name: 'Product Master', url: routerPathNames.master.productMaster, icon: 'fas fa-boxes' },
      { id: 'stock', name: 'Stock Management', url: routerPathNames.master.stock, icon: 'fas fa-warehouse' },
      { id: 'customers', name: 'Customers', url: routerPathNames.master.customers, icon: 'fas fa-users' },
      { id: 'cafe-tables', name: 'Cafe Tables', url: routerPathNames.master.cafeTables, icon: 'fas fa-chair' },
      { id: 'units', name: 'Units', url: routerPathNames.master.units, icon: 'fas fa-balance-scale' },
      { id: 'barcode', name: 'Bar Code', url: routerPathNames.master.barCode, icon: 'fas fa-barcode' },
    ],
  },
  {
    id: 'inventory',
    name: 'Inventory',
    icon: 'fas fa-warehouse',
    moduleId: MENU_MODULE.inventory,
    submenus: [
      { id: 'supplier', name: 'Supplier', url: routerPathNames.inventory.supplier, icon: 'fas fa-truck' },
      { id: 'purchase', name: 'Purchase Entry', url: routerPathNames.inventory.purchase, icon: 'fas fa-file-import' },
      { id: 'purchase-return', name: 'Purchase Return', url: routerPathNames.inventory.purchaseReturn, icon: 'fas fa-undo' },
      { id: 'purchase-report', name: 'Purchase Report', url: routerPathNames.inventory.purchaseReport, icon: 'fas fa-chart-bar' },
      { id: 'purchase-return-report', name: 'Purchase Return Report', url: routerPathNames.inventory.purchaseReturnReport, icon: 'fas fa-chart-line' },
      { id: 'supplier-payment-report', name: 'Supplier Payment Report', url: routerPathNames.inventory.supplierPaymentReport, icon: 'fas fa-money-check' },
    ],
  },
  {
    id: 'statistics',
    name: 'Statistics',
    icon: 'fas fa-chart-pie',
    moduleId: MENU_MODULE.statistics,
    submenus: [
      { id: 'profit-analysis', name: 'Profit Analysis Report', url: routerPathNames.statistics.profitAnalysis, icon: 'fas fa-chart-pie' },
      { id: 'stats-dashboard', name: 'Dashboard', url: routerPathNames.statistics.dashboard, icon: 'fas fa-chart-line' },
      { id: 'category-sales', name: 'Category Sales Statistics', url: routerPathNames.statistics.categorySales, icon: 'fas fa-layer-group' },
      { id: 'product-analysis', name: 'Product Analysis Report', url: routerPathNames.statistics.productAnalysis, icon: 'fas fa-cube' },
      { id: 'balance-summary', name: 'Balance Summary', url: routerPathNames.statistics.balanceSummary, icon: 'fas fa-scale-balanced' },
    ],
  },
  {
    id: 'stock-reports',
    name: 'Stock Reports',
    icon: 'fas fa-chart-bar',
    moduleId: MENU_MODULE.stockReports,
    submenus: [
      { id: 'current-stock', name: 'Current Stock', url: routerPathNames.stockReports.currentStock, icon: 'fas fa-boxes' },
      { id: 'product-transaction', name: 'Product Transaction', url: routerPathNames.stockReports.productTransaction, icon: 'fas fa-exchange-alt' },
      { id: 'stock-adjustment', name: 'Stock Adjustment', url: routerPathNames.stockReports.stockAdjustment, icon: 'fas fa-sliders-h' },
    ],
  },
  {
    id: 'account-reports',
    name: 'Account Reports',
    icon: 'fas fa-file-alt',
    moduleId: MENU_MODULE.accountReports,
    submenus: [
      {
        id: 'sales-reports',
        name: 'Sales Reports',
        icon: 'fas fa-money-bill-wave',
        submenus: [
          { id: 'sales', name: 'Sales Report', url: routerPathNames.accountReports.sales, icon: 'fas fa-file-invoice' },
          { id: 'sales-by-category', name: 'Sales by Category', url: routerPathNames.accountReports.salesByCategory, icon: 'fas fa-layer-group' },
          { id: 'sales-by-department', name: 'Sales by Department', url: routerPathNames.accountReports.salesByDepartment, icon: 'fas fa-sitemap' },
          { id: 'sales-by-item', name: 'Sales by Product', url: routerPathNames.accountReports.salesByItem, icon: 'fas fa-cube' },
          { id: 'sales-by-customer', name: 'Sales by Customer', url: routerPathNames.accountReports.salesByCustomer, icon: 'fas fa-user' },
          { id: 'sales-by-attender', name: 'Sales by Attender', url: routerPathNames.accountReports.salesByAttender, icon: 'fas fa-user-tie' },
          { id: 'day-account', name: 'Day Account', url: routerPathNames.accountReports.dayAccount, icon: 'fas fa-calendar-day' },
          { id: 'day-book', name: 'Day Book', url: routerPathNames.accountReports.dayBook, icon: 'fas fa-book' },
          { id: 'commission', name: 'Commission Report', url: routerPathNames.accountReports.commission, icon: 'fas fa-percent' },
        ],
      },
      {
        id: 'gst-reports',
        name: 'GST Reports',
        icon: 'fas fa-calculator',
        submenus: [
          { id: 'gstr1', name: 'GSTR-1', url: routerPathNames.accountReports.gstr1, icon: 'fas fa-file-alt' },
          { id: 'gst-sales-summary', name: 'Sales Summary', url: routerPathNames.accountReports.gstSalesSummary, icon: 'fas fa-file-invoice' },
          { id: 'gst-bill-wise', name: 'Bill Wise Sales GST', url: routerPathNames.accountReports.gstBillWise, icon: 'fas fa-receipt' },
          { id: 'gst-item-wise', name: 'Item Wise Sales GST', url: routerPathNames.accountReports.gstItemWise, icon: 'fas fa-list' },
          { id: 'gst-hsn', name: 'HSN Sales GST', url: routerPathNames.accountReports.gstHsn, icon: 'fas fa-barcode' },
          { id: 'gst-purchase', name: 'Purchase GST', url: routerPathNames.accountReports.gstPurchase, icon: 'fas fa-file-import' },
          { id: 'gst-purchase-summary', name: 'Purchase GST Summary', url: routerPathNames.accountReports.gstPurchaseSummary, icon: 'fas fa-chart-pie' },
        ],
      },
    ],
  },
  {
    id: 'credit',
    name: 'Credit Management',
    icon: 'fas fa-money-check-alt',
    moduleId: MENU_MODULE.credit,
    submenus: [
      { id: 'customer-balance', name: 'Customers Balance', url: routerPathNames.credit.customerBalance, icon: 'fas fa-wallet' },
      { id: 'supplier-payment', name: 'Supplier Payment', url: routerPathNames.credit.supplierPayment, icon: 'fas fa-hand-holding-usd' },
    ],
  },
  {
    id: 'users',
    name: 'User Management',
    icon: 'fas fa-user-shield',
    moduleId: MENU_MODULE.users,
    submenus: [
      { id: 'create-user', name: 'Create User', url: routerPathNames.users.create, icon: 'fas fa-user-plus' },
      { id: 'permission', name: 'Module Permission', url: routerPathNames.users.permission, icon: 'fas fa-key' },
      { id: 'special-permission', name: 'Special Permission', url: routerPathNames.users.specialPermission, icon: 'fas fa-unlock' },
      { id: 'attender', name: 'Attender Management', url: routerPathNames.users.attender, icon: 'fas fa-user-tie' },
      { id: 'user-discount', name: 'User Discount', url: routerPathNames.users.discount, icon: 'fas fa-percent' },
    ],
  },
  {
    id: 'admin',
    name: 'Admin',
    icon: 'fas fa-chart-pie',
    moduleId: MENU_MODULE.admin,
    submenus: [
      { id: 'company-details', name: 'Company Details', url: routerPathNames.admin.companyDetails, icon: 'fas fa-building' },
      { id: 'edit-bill', name: 'Edit Date/Cancel Bill', url: routerPathNames.admin.editBill, icon: 'fas fa-edit' },
      { id: 'monthly-bills', name: 'Monthly Bills', url: routerPathNames.admin.monthlyBills, icon: 'fas fa-file-invoice' },
      { id: 'edit-log', name: 'Edit Log', url: routerPathNames.admin.editLog, icon: 'fas fa-history' },
      { id: 'change-payment-type', name: 'Change Payment Type', url: routerPathNames.admin.changePaymentType, icon: 'fas fa-exchange-alt' },
      { id: 'exchange', name: 'Exchange', url: routerPathNames.admin.exchange, icon: 'fas fa-sync' },
      { id: 'bill-date-change-report', name: 'Bill Date Change Report', url: routerPathNames.admin.billDateChangeReport, icon: 'fas fa-calendar-alt' },
      { id: 'cancel-bill-report', name: 'Cancel Bill Reports', url: routerPathNames.admin.cancelBillReport, icon: 'fas fa-ban' },
      { id: 'payment-type-change-report', name: 'Payment Type Change Report', url: routerPathNames.admin.paymentTypeChangeReport, icon: 'fas fa-file-alt' },
      { id: 'exchange-report', name: 'Exchange & Return Report', url: routerPathNames.admin.exchangeReport, icon: 'fas fa-undo' },
    ],
  },
  {
    id: 'expense',
    name: 'Expense',
    icon: 'fas fa-money-bill-wave',
    moduleId: MENU_MODULE.expense,
    submenus: [
      { id: 'expense-type', name: 'Expense Type', url: routerPathNames.expense.type, icon: 'fas fa-tags' },
      { id: 'expense-entry', name: 'Expense Entry', url: routerPathNames.expense.entry, icon: 'fas fa-receipt' },
      { id: 'expense-report', name: 'Expense Report', url: routerPathNames.expense.report, icon: 'fas fa-chart-line' },
    ],
  },
  {
    id: 'order-list',
    name: 'Order List',
    icon: 'fas fa-list-alt',
    moduleId: MENU_MODULE.orderList,
    url: routerPathNames.orderList,
  },
];
