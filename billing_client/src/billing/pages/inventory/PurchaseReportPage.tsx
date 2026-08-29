import React, { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import { inventoryApi, invData, invError } from '../../../api/inventory/inventory-api-service';
import '../master/Master.css';

type Supplier = { id: number; name: string };
type Row = {
  id: number;
  invoiceNo: string;
  invoiceDate: string;
  total: number;
  paid: number;
  balance: number;
  entryDate: string;
  entryTime: string;
  userName: string;
  supplierName: string;
  prno: string;
};
type Detail = {
  id: number;
  productName: string;
  quantity: number;
  free: number;
  rate: number;
  mrp: number;
  tax: number;
  netAmt: number;
};

const today = () => new Date().toISOString().slice(0, 10);

const PurchaseReportPage: React.FC = () => {
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [from, setFrom] = useState(today());
  const [to, setTo] = useState(today());
  const [supplierId, setSupplierId] = useState('0');
  const [rows, setRows] = useState<Row[]>([]);
  const [details, setDetails] = useState<Detail[] | null>(null);
  const [openId, setOpenId] = useState<number | null>(null);

  useEffect(() => {
    inventoryApi.suppliers().then((res) => setSuppliers(invData<Supplier[]>(res) || [])).catch(() => undefined);
  }, []);

  const search = async () => {
    try {
      setRows(invData<Row[]>(await inventoryApi.purchaseReport(from, to, supplierId === '0' ? undefined : Number(supplierId))) || []);
      setDetails(null);
    } catch (err) {
      toast.error(invError(err, 'Could not load report'));
    }
  };

  const openDetails = async (id: number) => {
    try {
      setOpenId(id);
      setDetails(invData<Detail[]>(await inventoryApi.purchaseDetails(id)) || []);
    } catch (err) {
      toast.error(invError(err, 'Could not load details'));
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title">
        <i className="fas fa-chart-bar" /> Purchase Report
      </h2>
      <div className="mst-card" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form">
          <div className="mst-fg">
            <label>From Date</label>
            <input className="mst-inp" type="date" value={from} onChange={(e) => setFrom(e.target.value)} />
          </div>
          <div className="mst-fg">
            <label>To Date</label>
            <input className="mst-inp" type="date" value={to} onChange={(e) => setTo(e.target.value)} />
          </div>
          <div className="mst-fg">
            <label>Supplier</label>
            <select className="mst-sel" value={supplierId} onChange={(e) => setSupplierId(e.target.value)}>
              <option value="0">All Suppliers</option>
              {suppliers.map((s) => (
                <option key={s.id} value={s.id}>{s.name}</option>
              ))}
            </select>
          </div>
          <div className="mst-actions">
            <button className="mst-btn mst-btn-primary" type="button" onClick={search}>Generate Report</button>
          </div>
        </div>
      </div>
      <div className="mst-card">
        <div className="mst-table-wrap">
          <table className="mst-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Inv No / GR No</th>
                <th>Invoice Date</th>
                <th>Supplier</th>
                <th className="num">Total</th>
                <th className="num">Paid</th>
                <th className="num">Balance</th>
                <th>Date</th>
                <th>Time</th>
                <th>User</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 && <tr><td colSpan={10} className="mst-empty">No purchase records found for the selected period.</td></tr>}
              {rows.map((row, i) => (
                <tr key={row.id} onClick={() => openDetails(row.id)} style={{ cursor: 'pointer' }}>
                  <td>{i + 1}</td>
                  <td>{row.invoiceNo}/{row.prno}</td>
                  <td>{row.invoiceDate}</td>
                  <td>{row.supplierName}</td>
                  <td className="num">{Number(row.total || 0).toFixed(2)}</td>
                  <td className="num">{Number(row.paid || 0).toFixed(2)}</td>
                  <td className="num">{Number(row.balance || 0).toFixed(2)}</td>
                  <td>{row.entryDate}</td>
                  <td>{row.entryTime}</td>
                  <td>{row.userName}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      {details && (
        <div className="mst-card" style={{ marginTop: 12 }}>
          <div className="mst-card-h">Purchase details {openId ? `#${openId}` : ''}</div>
          <div className="mst-table-wrap">
            <table className="mst-table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th className="num">Qty</th>
                  <th className="num">Free</th>
                  <th className="num">Rate</th>
                  <th className="num">MRP</th>
                  <th className="num">Tax%</th>
                  <th className="num">Net</th>
                </tr>
              </thead>
              <tbody>
                {details.map((d) => (
                  <tr key={d.id}>
                    <td>{d.productName}</td>
                    <td className="num">{d.quantity}</td>
                    <td className="num">{d.free}</td>
                    <td className="num">{d.rate}</td>
                    <td className="num">{d.mrp}</td>
                    <td className="num">{d.tax}</td>
                    <td className="num">{d.netAmt}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
};

export default PurchaseReportPage;
