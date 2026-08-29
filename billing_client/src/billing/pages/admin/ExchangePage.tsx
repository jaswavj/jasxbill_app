import React, { useRef, useState } from 'react';
import { toast } from 'react-toastify';
import { adminApi, adminData, adminError } from '../../../api/admin/admin-api-service';
import { billingApi } from '../../../api/billing/billing-api-service';
import '../master/Master.css';
import '../credit/Credit.css';

type Item = { detailId: number; prodId: number; productName: string; qty: number; price: number; disc: number; total: number; isExchanged: number };
type Bill = { billId: number; billNo: string; customerId: number; cusName: string; total: string; payable: string; paid: string; billDate: string; items: Item[] };
type Hit = { id: number; name: string; phone?: string; mrp?: number; code?: string };

const ExchangePage: React.FC = () => {
  const [billNo, setBillNo] = useState('');
  const [bill, setBill] = useState<Bill | null>(null);
  const [needCustomer, setNeedCustomer] = useState(false);
  const [custName, setCustName] = useState('');
  const [custPhone, setCustPhone] = useState('');
  const [custId, setCustId] = useState(0);
  const [custHits, setCustHits] = useState<Hit[]>([]);
  const [exItem, setExItem] = useState<Item | null>(null);
  const [prodTerm, setProdTerm] = useState('');
  const [prodHits, setProdHits] = useState<Hit[]>([]);
  const [newProdId, setNewProdId] = useState(0);
  const [newPrice, setNewPrice] = useState('');
  const [retItem, setRetItem] = useState<Item | null>(null);
  const [retQty, setRetQty] = useState('');
  const [busy, setBusy] = useState(false);
  const timer = useRef<number | null>(null);

  const load = async (no = billNo) => {
    if (!no.trim()) return;
    setBusy(true);
    try {
      const data = adminData<Bill>(await adminApi.exchangeBill(no.trim()));
      setBill(data);
      setNeedCustomer(Number(data.customerId) === 1);
    } catch (err) {
      setBill(null);
      toast.error(adminError(err, 'Bill not found'));
    } finally {
      setBusy(false);
    }
  };

  const searchCust = (query?: string, phone?: string) => {
    if (timer.current) window.clearTimeout(timer.current);
    timer.current = window.setTimeout(async () => {
      try {
        const res: any = await billingApi.searchCustomers(query, phone);
        setCustHits(res?.data || []);
      } catch {
        setCustHits([]);
      }
    }, 250);
  };

  const searchProd = (term: string) => {
    setProdTerm(term);
    setNewProdId(0);
    if (timer.current) window.clearTimeout(timer.current);
    if (!term.trim()) {
      setProdHits([]);
      return;
    }
    timer.current = window.setTimeout(async () => {
      try {
        setProdHits(adminData<Hit[]>(await adminApi.exchangeProducts(term.trim())) || []);
      } catch {
        setProdHits([]);
      }
    }, 250);
  };

  const assign = async () => {
    if (!bill || !custName.trim()) {
      toast.warning('Customer name is required.');
      return;
    }
    setBusy(true);
    try {
      const res = adminData<any>(await adminApi.assignCustomer({
        billId: bill.billId,
        customerId: custId,
        cusName: custName.trim(),
        cusPhn: custPhone.trim(),
      }));
      toast.success(res.message || 'Customer updated');
      setNeedCustomer(false);
      await load(bill.billNo);
    } catch (err) {
      toast.error(adminError(err, 'Could not assign customer'));
    } finally {
      setBusy(false);
    }
  };

  const saveExchange = async () => {
    if (!bill || !exItem || !newProdId || !(parseFloat(newPrice) > 0)) {
      toast.warning('Select a product and enter a price greater than zero');
      return;
    }
    setBusy(true);
    try {
      const msg = adminData<string>(await adminApi.saveExchange({
        billNo: bill.billNo,
        detailId: exItem.detailId,
        newProdId,
        newPrice: parseFloat(newPrice),
      }));
      toast.success(msg);
      setExItem(null);
      await load(bill.billNo);
    } catch (err) {
      toast.error(adminError(err, 'Exchange failed'));
    } finally {
      setBusy(false);
    }
  };

  const saveReturn = async () => {
    if (!bill || !retItem) return;
    const qty = parseFloat(retQty);
    if (!(qty > 0) || qty > retItem.qty) {
      toast.warning('Enter a valid return quantity');
      return;
    }
    setBusy(true);
    try {
      const msg = adminData<string>(await adminApi.saveReturn({
        billNo: bill.billNo,
        detailId: retItem.detailId,
        returnQty: qty,
      }));
      toast.success(msg);
      setRetItem(null);
      await load(bill.billNo);
    } catch (err) {
      toast.error(adminError(err, 'Return failed'));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title"><i className="fas fa-sync" /> Product Exchange</h2>
      <div className="mst-card" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form" style={{ gridTemplateColumns: 'minmax(220px, 360px) auto' }}>
          <div className="mst-fg">
            <label>Bill Number</label>
            <input className="mst-inp" value={billNo} placeholder="Enter bill number…" onChange={(e) => setBillNo(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && load()} />
          </div>
          <div className="mst-actions" style={{ alignItems: 'end' }}>
            <button className="mst-btn mst-btn-primary" type="button" disabled={busy} onClick={() => load()}>Load</button>
          </div>
        </div>
        {bill && (
          <div className="mst-card-b" style={{ paddingTop: 0 }}>
            <div className="mst-note">Customer: <strong>{bill.cusName}</strong> | Total: ₹{bill.total} | Payable: ₹{bill.payable} | Date: {bill.billDate}</div>
            {needCustomer && <div className="mst-block">Customer not assigned — update the customer before exchange or return.</div>}
          </div>
        )}
      </div>

      {needCustomer && bill && (
        <div className="mst-card" style={{ marginBottom: 12, maxWidth: 520 }}>
          <div className="mst-card-h">Assign Customer</div>
          <div className="mst-card-b mst-form one-col">
            <div className="mst-fg crd-search-wrap">
              <label>Customer Name <span className="req">*</span></label>
              <input className="mst-inp" value={custName} onChange={(e) => { setCustName(e.target.value); setCustId(0); searchCust(e.target.value); }} />
              {custHits.length > 0 && (
                <ul className="crd-dropdown">
                  {custHits.map((c) => (
                    <li key={c.id} onClick={() => { setCustId(c.id); setCustName(c.name); setCustPhone(c.phone && c.phone !== '-' ? c.phone : ''); setCustHits([]); }}>
                      {c.name}{c.phone && c.phone !== '-' ? ` — ${c.phone}` : ''}
                    </li>
                  ))}
                </ul>
              )}
            </div>
            <div className="mst-fg">
              <label>Phone Number</label>
              <input className="mst-inp" value={custPhone} onChange={(e) => { setCustPhone(e.target.value); if (/^\d+$/.test(e.target.value)) searchCust(undefined, e.target.value); }} />
            </div>
            <div className="mst-actions">
              <button className="mst-btn mst-btn-primary" type="button" disabled={busy} onClick={assign}>Update & Continue</button>
            </div>
          </div>
        </div>
      )}

      {bill && (
        <div className="mst-card">
          <div className="mst-card-h">Bill Items — #{bill.billNo}</div>
          <div className="mst-table-wrap">
            <table className="mst-table">
              <thead><tr><th>#</th><th>Product</th><th>Qty</th><th>Price</th><th>Disc</th><th>Total</th><th>Status</th><th>Action</th></tr></thead>
              <tbody>
                {bill.items.map((item, i) => {
                  const exchanged = item.isExchanged === 1;
                  const returned = item.isExchanged === 2;
                  return (
                    <tr key={item.detailId} className={exchanged ? 'crd-row-adv' : returned ? 'crd-row-old' : ''}>
                      <td>{i + 1}</td>
                      <td>{item.productName}</td>
                      <td>{item.qty}</td>
                      <td>₹{item.price}</td>
                      <td>₹{item.disc}</td>
                      <td>₹{item.total}</td>
                      <td>
                        <span className={`crd-badge ${exchanged ? 'adv' : returned ? 'old' : 'col'}`}>
                          {exchanged ? 'Exchanged' : returned ? 'Returned' : 'Active'}
                        </span>
                      </td>
                      <td>
                        {exchanged || returned ? '—' : (
                          <>
                            <button className="mst-icon-btn" type="button" disabled={needCustomer} onClick={() => { setExItem(item); setProdTerm(''); setProdHits([]); setNewProdId(0); setNewPrice(''); }}>
                              <i className="fas fa-exchange-alt" /> Exchange
                            </button>
                            <button className="mst-icon-btn" type="button" disabled={needCustomer} onClick={() => { setRetItem(item); setRetQty(String(item.qty)); }}>
                              <i className="fas fa-undo" /> Return
                            </button>
                          </>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {exItem && bill && (
        <div className="crd-modal" onClick={() => setExItem(null)}>
          <div className="crd-modal-box" onClick={(e) => e.stopPropagation()}>
            <div className="mst-card-h">Exchange Item</div>
            <div className="mst-card-b mst-form one-col">
              <div className="mst-note">Replacing: <strong>{exItem.productName}</strong> | Qty {exItem.qty} | Total ₹{exItem.total}</div>
              <div className="mst-fg crd-search-wrap">
                <label>New Product <span className="req">*</span></label>
                <input className="mst-inp" value={prodTerm} onChange={(e) => searchProd(e.target.value)} placeholder="Type product name…" />
                {prodHits.length > 0 && (
                  <ul className="crd-dropdown">
                    {prodHits.map((p) => (
                      <li key={p.id} onClick={() => { setNewProdId(p.id); setProdTerm(p.name); setNewPrice(String(p.mrp || '')); setProdHits([]); }}>
                        {p.name}{p.code ? ` (${p.code})` : ''} {p.mrp ? ` — ₹${p.mrp}` : ''}
                      </li>
                    ))}
                  </ul>
                )}
              </div>
              <div className="mst-fg">
                <label>New Price (₹) <span className="req">*</span></label>
                <input className="mst-inp" type="number" min="0" step="0.01" value={newPrice} onChange={(e) => setNewPrice(e.target.value)} />
              </div>
              <div className="mst-actions">
                <button className="mst-btn mst-btn-outline" type="button" onClick={() => setExItem(null)}>Cancel</button>
                <button className="mst-btn mst-btn-primary" type="button" disabled={busy} onClick={saveExchange}>Confirm Exchange</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {retItem && bill && (
        <div className="crd-modal" onClick={() => setRetItem(null)}>
          <div className="crd-modal-box" onClick={(e) => e.stopPropagation()}>
            <div className="mst-card-h">Return Item</div>
            <div className="mst-card-b mst-form one-col">
              <div className="mst-note"><strong>{retItem.productName}</strong> | Available qty: {retItem.qty} | Total ₹{retItem.total}</div>
              <div className="mst-fg">
                <label>Return Quantity</label>
                <input className="mst-inp" type="number" min="0.001" max={retItem.qty} step="0.001" value={retQty} onChange={(e) => setRetQty(e.target.value)} />
              </div>
              <div className="mst-actions">
                <button className="mst-btn mst-btn-outline" type="button" onClick={() => setRetItem(null)}>Cancel</button>
                <button className="mst-btn mst-btn-primary" type="button" disabled={busy} onClick={saveReturn}>Yes, Return</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ExchangePage;
