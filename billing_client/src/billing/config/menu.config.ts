import { routerPathNames } from '../../routes/routerPathNames';

export interface MenuItemConfig {
  id: string;
  name: string;
  url?: string;
  icon: string;
  moduleId?: number;
  submenus?: MenuItemConfig[];
}

/** Main menus: is_group=1. Sub menus use these ids with group_id = parent. */
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

export const MENU_SUB = {
  category: 101,
  brands: 102,
  product: 103,
  configMaterial: 104,
  productMaster: 105,
  stock: 106,
  customers: 107,
  cafeTables: 108,
  units: 109,
  barCode: 110,
  supplier: 111,
  purchase: 112,
  purchaseReturn: 113,
  purchaseReport: 114,
  purchaseReturnReport: 115,
  supplierPaymentReport: 116,
  profitAnalysis: 117,
  statsDashboard: 118,
  categorySales: 119,
  productAnalysis: 120,
  currentStock: 121,
  zeroStock: 122,
  productTransaction: 123,
  stockAdjustment: 124,
  sales: 125,
  salesByCategory: 126,
  salesByDepartment: 127,
  salesByItem: 128,
  salesByCustomer: 129,
  salesByAttender: 130,
  dayBook: 131,
  commission: 132,
  gstr1: 133,
  gstSalesSummary: 134,
  gstBillWise: 135,
  gstItemWise: 136,
  gstHsn: 137,
  gstPurchase: 138,
  gstPurchaseSummary: 139,
  customerBalance: 140,
  supplierPayment: 141,
  createUser: 142,
  modulePermission: 143,
  specialPermission: 144,
  attender: 145,
  userDiscount: 146,
  companyDetails: 147,
  editBill: 148,
  editLog: 149,
  exchange: 150,
  exchangeReport: 151,
  expenseType: 152,
  expenseEntry: 153,
  expenseReport: 154,
} as const;

const leafIds = (item: MenuItemConfig): number[] => {
  if (item.submenus && item.submenus.length > 0) {
    return item.submenus.flatMap(leafIds);
  }
  return item.moduleId != null ? [item.moduleId] : [];
};

/** Parent-only grants (old users) unlock every child of that group. */
export const expandModuleIds = (moduleIds: number[] | undefined): Set<number> => {
  const allowed = new Set((moduleIds || []).map(Number));
  for (const group of billingMenuConfig) {
    const children = leafIds(group);
    if (children.length === 0) continue;
    const hasChild = children.some((id) => allowed.has(id));
    if (group.moduleId != null && allowed.has(group.moduleId) && !hasChild) {
      children.forEach((id) => allowed.add(id));
    }
    if (hasChild && group.moduleId != null) {
      allowed.add(group.moduleId);
    }
  }
  return allowed;
};

export const filterMenuByModules = (items: MenuItemConfig[], moduleIds: number[]): MenuItemConfig[] => {
  const allowed = expandModuleIds(moduleIds);
  const filter = (list: MenuItemConfig[]): MenuItemConfig[] =>
    list
      .map((item) => {
        if (item.submenus && item.submenus.length > 0) {
          const submenus = filter(item.submenus);
          if (submenus.length === 0) return null;
          return { ...item, submenus };
        }
        if (item.moduleId == null || allowed.has(item.moduleId)) return item;
        return null;
      })
      .filter((item): item is MenuItemConfig => item != null);
  return filter(items);
};

export const hasModuleAccess = (moduleIds: number[] | undefined, moduleId: number): boolean =>
  expandModuleIds(moduleIds).has(moduleId);

/** After login: statistics home first when allowed, otherwise the billing screen. */
export const defaultAppPath = (moduleIds: number[] | undefined): string =>
  hasModuleAccess(moduleIds, MENU_MODULE.statistics)
    ? routerPathNames.dashboard
    : routerPathNames.billing;

const pathMatches = (pathname: string, url?: string) =>
  !!url && (pathname === url || pathname.startsWith(`${url}/`));

export const moduleIdForPath = (pathname: string): number | null => {
  if (pathname.includes('/app/users/change-password')) return null;
  let bestUrl = '';
  let bestId: number | null = null;
  const walk = (list: MenuItemConfig[]) => {
    for (const item of list) {
      const url = item.url || '';
      if (pathMatches(pathname, url) && url.length >= bestUrl.length) {
        bestUrl = url;
        bestId = item.moduleId ?? null;
      }
      if (item.submenus) walk(item.submenus);
    }
  };
  walk(billingMenuConfig);
  return bestId;
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
      { id: 'category', name: 'Category', url: routerPathNames.master.category, icon: 'fas fa-layer-group', moduleId: MENU_SUB.category },
      { id: 'brands', name: 'Brands', url: routerPathNames.master.brands, icon: 'fas fa-tags', moduleId: MENU_SUB.brands },
      { id: 'product', name: 'Product', url: routerPathNames.master.product, icon: 'fas fa-cube', moduleId: MENU_SUB.product },
      { id: 'config-material', name: 'Config Product Material', url: routerPathNames.master.configMaterial, icon: 'fas fa-cogs', moduleId: MENU_SUB.configMaterial },
      { id: 'product-master', name: 'Product Master', url: routerPathNames.master.productMaster, icon: 'fas fa-boxes', moduleId: MENU_SUB.productMaster },
      { id: 'stock', name: 'Stock Management', url: routerPathNames.master.stock, icon: 'fas fa-warehouse', moduleId: MENU_SUB.stock },
      { id: 'customers', name: 'Customers', url: routerPathNames.master.customers, icon: 'fas fa-users', moduleId: MENU_SUB.customers },
      { id: 'cafe-tables', name: 'Cafe Tables', url: routerPathNames.master.cafeTables, icon: 'fas fa-chair', moduleId: MENU_SUB.cafeTables },
      { id: 'units', name: 'Units', url: routerPathNames.master.units, icon: 'fas fa-balance-scale', moduleId: MENU_SUB.units },
      { id: 'barcode', name: 'Bar Code', url: routerPathNames.master.barCode, icon: 'fas fa-barcode', moduleId: MENU_SUB.barCode },
    ],
  },
  {
    id: 'inventory',
    name: 'Inventory',
    icon: 'fas fa-warehouse',
    moduleId: MENU_MODULE.inventory,
    submenus: [
      { id: 'supplier', name: 'Supplier', url: routerPathNames.inventory.supplier, icon: 'fas fa-truck', moduleId: MENU_SUB.supplier },
      { id: 'purchase', name: 'Purchase Entry', url: routerPathNames.inventory.purchase, icon: 'fas fa-file-import', moduleId: MENU_SUB.purchase },
      { id: 'purchase-return', name: 'Purchase Return', url: routerPathNames.inventory.purchaseReturn, icon: 'fas fa-undo', moduleId: MENU_SUB.purchaseReturn },
      { id: 'purchase-report', name: 'Purchase Report', url: routerPathNames.inventory.purchaseReport, icon: 'fas fa-chart-bar', moduleId: MENU_SUB.purchaseReport },
      { id: 'purchase-return-report', name: 'Purchase Return Report', url: routerPathNames.inventory.purchaseReturnReport, icon: 'fas fa-chart-line', moduleId: MENU_SUB.purchaseReturnReport },
      { id: 'supplier-payment-report', name: 'Supplier Payment Report', url: routerPathNames.inventory.supplierPaymentReport, icon: 'fas fa-money-check', moduleId: MENU_SUB.supplierPaymentReport },
    ],
  },
  {
    id: 'statistics',
    name: 'Statistics',
    icon: 'fas fa-chart-pie',
    moduleId: MENU_MODULE.statistics,
    submenus: [
      { id: 'profit-analysis', name: 'Profit Analysis Report', url: routerPathNames.statistics.profitAnalysis, icon: 'fas fa-chart-pie', moduleId: MENU_SUB.profitAnalysis },
      { id: 'stats-dashboard', name: 'Dashboard', url: routerPathNames.statistics.dashboard, icon: 'fas fa-chart-line', moduleId: MENU_SUB.statsDashboard },
      { id: 'category-sales', name: 'Category Sales Statistics', url: routerPathNames.statistics.categorySales, icon: 'fas fa-layer-group', moduleId: MENU_SUB.categorySales },
      { id: 'product-analysis', name: 'Product Analysis Report', url: routerPathNames.statistics.productAnalysis, icon: 'fas fa-cube', moduleId: MENU_SUB.productAnalysis },
    ],
  },
  {
    id: 'stock-reports',
    name: 'Stock Reports',
    icon: 'fas fa-chart-bar',
    moduleId: MENU_MODULE.stockReports,
    submenus: [
      { id: 'current-stock', name: 'Current Stock', url: routerPathNames.stockReports.currentStock, icon: 'fas fa-boxes', moduleId: MENU_SUB.currentStock },
      { id: 'zero-stock', name: 'Zero Stock Report', url: routerPathNames.stockReports.zeroStock, icon: 'fas fa-box-open', moduleId: MENU_SUB.zeroStock },
      { id: 'product-transaction', name: 'Product Transaction', url: routerPathNames.stockReports.productTransaction, icon: 'fas fa-exchange-alt', moduleId: MENU_SUB.productTransaction },
      { id: 'stock-adjustment', name: 'Stock Adjustment', url: routerPathNames.stockReports.stockAdjustment, icon: 'fas fa-sliders-h', moduleId: MENU_SUB.stockAdjustment },
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
          { id: 'sales', name: 'Sales Report', url: routerPathNames.accountReports.sales, icon: 'fas fa-file-invoice', moduleId: MENU_SUB.sales },
          { id: 'sales-by-category', name: 'Sales by Category', url: routerPathNames.accountReports.salesByCategory, icon: 'fas fa-layer-group', moduleId: MENU_SUB.salesByCategory },
          { id: 'sales-by-department', name: 'Sales by Department', url: routerPathNames.accountReports.salesByDepartment, icon: 'fas fa-sitemap', moduleId: MENU_SUB.salesByDepartment },
          { id: 'sales-by-item', name: 'Sales by Product', url: routerPathNames.accountReports.salesByItem, icon: 'fas fa-cube', moduleId: MENU_SUB.salesByItem },
          { id: 'sales-by-customer', name: 'Sales by Customer', url: routerPathNames.accountReports.salesByCustomer, icon: 'fas fa-user', moduleId: MENU_SUB.salesByCustomer },
          { id: 'sales-by-attender', name: 'Sales by Attender', url: routerPathNames.accountReports.salesByAttender, icon: 'fas fa-user-tie', moduleId: MENU_SUB.salesByAttender },
          { id: 'day-book', name: 'Day Book', url: routerPathNames.accountReports.dayBook, icon: 'fas fa-book', moduleId: MENU_SUB.dayBook },
          { id: 'commission', name: 'Commission Report', url: routerPathNames.accountReports.commission, icon: 'fas fa-percent', moduleId: MENU_SUB.commission },
        ],
      },
      {
        id: 'gst-reports',
        name: 'GST Reports',
        icon: 'fas fa-calculator',
        submenus: [
          { id: 'gstr1', name: 'GSTR-1', url: routerPathNames.accountReports.gstr1, icon: 'fas fa-file-alt', moduleId: MENU_SUB.gstr1 },
          { id: 'gst-sales-summary', name: 'Sales Summary', url: routerPathNames.accountReports.gstSalesSummary, icon: 'fas fa-file-invoice', moduleId: MENU_SUB.gstSalesSummary },
          { id: 'gst-bill-wise', name: 'Bill Wise Sales GST', url: routerPathNames.accountReports.gstBillWise, icon: 'fas fa-receipt', moduleId: MENU_SUB.gstBillWise },
          { id: 'gst-item-wise', name: 'Item Wise Sales GST', url: routerPathNames.accountReports.gstItemWise, icon: 'fas fa-list', moduleId: MENU_SUB.gstItemWise },
          { id: 'gst-hsn', name: 'HSN Sales GST', url: routerPathNames.accountReports.gstHsn, icon: 'fas fa-barcode', moduleId: MENU_SUB.gstHsn },
          { id: 'gst-purchase', name: 'Purchase GST', url: routerPathNames.accountReports.gstPurchase, icon: 'fas fa-file-import', moduleId: MENU_SUB.gstPurchase },
          { id: 'gst-purchase-summary', name: 'Purchase GST Summary', url: routerPathNames.accountReports.gstPurchaseSummary, icon: 'fas fa-chart-pie', moduleId: MENU_SUB.gstPurchaseSummary },
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
      { id: 'customer-balance', name: 'Customers Balance', url: routerPathNames.credit.customerBalance, icon: 'fas fa-wallet', moduleId: MENU_SUB.customerBalance },
      { id: 'supplier-payment', name: 'Supplier Payment', url: routerPathNames.credit.supplierPayment, icon: 'fas fa-hand-holding-usd', moduleId: MENU_SUB.supplierPayment },
    ],
  },
  {
    id: 'users',
    name: 'User Management',
    icon: 'fas fa-user-shield',
    moduleId: MENU_MODULE.users,
    submenus: [
      { id: 'create-user', name: 'Create User', url: routerPathNames.users.create, icon: 'fas fa-user-plus', moduleId: MENU_SUB.createUser },
      { id: 'permission', name: 'Module Permission', url: routerPathNames.users.permission, icon: 'fas fa-key', moduleId: MENU_SUB.modulePermission },
      { id: 'special-permission', name: 'Special Permission', url: routerPathNames.users.specialPermission, icon: 'fas fa-unlock', moduleId: MENU_SUB.specialPermission },
      { id: 'attender', name: 'Attender Management', url: routerPathNames.users.attender, icon: 'fas fa-user-tie', moduleId: MENU_SUB.attender },
      { id: 'user-discount', name: 'User Discount', url: routerPathNames.users.discount, icon: 'fas fa-percent', moduleId: MENU_SUB.userDiscount },
    ],
  },
  {
    id: 'admin',
    name: 'Admin',
    icon: 'fas fa-chart-pie',
    moduleId: MENU_MODULE.admin,
    submenus: [
      { id: 'company-details', name: 'Company Details', url: routerPathNames.admin.companyDetails, icon: 'fas fa-building', moduleId: MENU_SUB.companyDetails },
      { id: 'monthly-bills', name: 'Edit Bill', url: routerPathNames.admin.monthlyBills, icon: 'fas fa-file-invoice', moduleId: MENU_SUB.editBill },
      { id: 'edit-log', name: 'Edit Log', url: routerPathNames.admin.editLog, icon: 'fas fa-history', moduleId: MENU_SUB.editLog },
      { id: 'exchange', name: 'Exchange', url: routerPathNames.admin.exchange, icon: 'fas fa-sync', moduleId: MENU_SUB.exchange },
      { id: 'exchange-report', name: 'Exchange & Return Report', url: routerPathNames.admin.exchangeReport, icon: 'fas fa-undo', moduleId: MENU_SUB.exchangeReport },
    ],
  },
  {
    id: 'expense',
    name: 'Expense',
    icon: 'fas fa-money-bill-wave',
    moduleId: MENU_MODULE.expense,
    submenus: [
      { id: 'expense-type', name: 'Expense Type', url: routerPathNames.expense.type, icon: 'fas fa-tags', moduleId: MENU_SUB.expenseType },
      { id: 'expense-entry', name: 'Expense Entry', url: routerPathNames.expense.entry, icon: 'fas fa-receipt', moduleId: MENU_SUB.expenseEntry },
      { id: 'expense-report', name: 'Expense Report', url: routerPathNames.expense.report, icon: 'fas fa-chart-line', moduleId: MENU_SUB.expenseReport },
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
