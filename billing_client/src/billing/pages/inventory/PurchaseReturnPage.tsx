import React, { useState } from 'react';
import { toast } from 'react-toastify';
import { inventoryApi, invData, invError } from '../../../api/inventory/inventory-api-service';
import '../master/Master.css';

type Line = {
  detailId: number;
  product: string;
  qty: number;
  free: number;
  rate: number;
  mrp: number;
  alreadyReturned: number;
  availableQty: number;
  returnQty: string;
  selected: boolean;
};

type Bill = {
  id: number;
  prno: string;
  invoiceNo: string;
  invoiceDate: string;
  total: number;
  supplierName: string;
};

const PurchaseReturnPage: React.FC = () => {
  const [search, setSearch] = useState('');
  const [bill, setBill] = useState<Bill | null>(null);
  const [lines, setLines] = useState<Line[]>([]);
  const [notes, setNotes] = useState('');
  const [busy, setBusy] = useState(false);

  const load = async () => {
    if (!search.trim()) {
      toast.warning('Enter purchase ID or bill no');
      return;
    }
    try {
      const data = invData<any>(await inventoryApi.purchaseForReturn(search.trim()));
      setBill({
        id: data.id,
        prno: data.prno,
        invoiceNo: data.invoiceNo,
        invoiceDate: data.invoiceDate,
        total: data.total,
        supplierName: data.supplierName,
      });
      setLines(
        (data.items || []).map((item: any) => ({
          ...item,
          returnQty: String(item.availableQty || 0),
          selected: false,
        }))
      );
    } catch (err) {
      toast.error(invError(err, 'Purchase not found'));
      setBill(null);
      setLines([]);
    }
  };

  const save = async () => {
    const items = lines
      .filter((l) => l.selected && Number(l.returnQty) > 0)
      .map((l) => ({ detailId: l.detailId, qty: Number(l.returnQty), rate: l.rate }));
    if (!bill || items.length === 0) {
      toast.warning('Select items to return');
      return;
    }
    setBusy(true);
    try {
      const no = invData<string>(await inventoryApi.saveReturn({ purchaseId: bill.id, notes, items }));
      toast.success(`Return saved: ${no}`);
      setBill(null);
      setLines([]);
      setNotes('');
    } catch (err) {
      toast.error(invError(err, 'Return failed'));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title">
        <i className="fas fa-undo" /> Purchase Return
      </h2>
      <div className="mst-card" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form">
          <div className="mst-fg">
            <label>Purchase Bill No / ID</label>
            <input className="mst-inp" value={search} onChange={(e) => setSearch(e.target.value)} placeholder="Enter Purchase ID or Bill No" />
          </div>
          <div className="mst-actions">
            <button className="mst-btn mst-btn-primary" type="button" onClick={load}>Load Bill</button>
          </div>
        </div>
      </div>
      {bill && (
        <>
          <div className="mst-card" style={{ marginBottom: 12 }}>
            <div className="mst-card-b" style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
              <span><small className="mst-note">Bill No</small><div><b>{bill.prno}</b></div></span>
              <span><small className="mst-note">Invoice No</small><div><b>{bill.invoiceNo}</b></div></span>
              <span><small className="mst-note">Invoice Date</small><div><b>{bill.invoiceDate}</b></div></span>
              <span><small className="mst-note">Supplier</small><div><b>{bill.supplierName}</b></div></span>
              <span><small className="mst-note">Bill Total</small><div><b>{Number(bill.total || 0).toFixed(3)}</b></div></span>
            </div>
          </div>
          <div className="mst-card">
            <div className="mst-card-h">Select Items to Return</div>
            <div className="mst-table-wrap">
              <table className="mst-table">
                <thead>
                  <tr>
                    <th>
                      <input
                        type="checkbox"
                        onChange={(e) => setLines((prev) => prev.map((l) => ({ ...l, selected: e.target.checked })))}
                      />
                    </th>
                    <th>#</th>
                    <th>Product</th>
                    <th className="num">Orig Qty</th>
                    <th className="num">Free</th>
                    <th className="num">Returned</th>
                    <th className="num">Available</th>
                    <th className="num">Rate</th>
                    <th className="num">Return Qty</th>
                  </tr>
                </thead>
                <tbody>
                  {lines.map((line, i) => (
                    <tr key={line.detailId}>
                      <td>
                        <input type="checkbox" checked={line.selected} onChange={(e) => setLines((prev) => prev.map((l) => (l.detailId === line.detailId ? { ...l, selected: e.target.checked } : l)))} />
                      </td>
                      <td>{i + 1}</td>
                      <td>{line.product}</td>
                      <td className="num">{line.qty}</td>
                      <td className="num">{line.free}</td>
                      <td className="num">{line.alreadyReturned}</td>
                      <td className="num">{line.availableQty}</td>
                      <td className="num">{line.rate}</td>
                      <td>
                        <input
                          className="mst-inp"
                          type="number"
                          min="0"
                          max={line.availableQty}
                          step="0.001"
                          value={line.returnQty}
                          onChange={(e) => setLines((prev) => prev.map((l) => (l.detailId === line.detailId ? { ...l, returnQty: e.target.value } : l)))}
                        />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="mst-card-b mst-form">
              <div className="mst-fg span-2">
                <label>Notes</label>
                <textarea className="mst-area" value={notes} onChange={(e) => setNotes(e.target.value)} />
              </div>
              <div className="mst-actions">
                <button className="mst-btn mst-btn-primary" disabled={busy} type="button" onClick={save}>Save Return</button>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default PurchaseReturnPage;
