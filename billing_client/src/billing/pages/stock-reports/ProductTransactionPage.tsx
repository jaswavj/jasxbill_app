import React, { useRef, useState } from 'react';
import { toast } from 'react-toastify';
import { stockApi, stockError, stockPage } from '../../../api/stock-reports/stock-report-api-service';
import { billingApi } from '../../../api/billing/billing-api-service';
import ListPagination, { DEFAULT_PAGE_SIZE } from '../../components/ListPagination';
import '../master/Master.css';
import '../credit/Credit.css';
import '../statistics/Stats.css';
import ReportActions from '../account-reports/ReportActions';

type Hit = { id: number; name: string };
type Row = { productName: string; stockIn: number; stockOut: number; stockNow: number; notes: string; dateTime: string; userName: string; adjType: number; unit: string };

const today = () => new Date().toISOString().slice(0, 10);

const productNames = (raw: unknown): string[] => {
  if (!Array.isArray(raw)) return [];
  return raw
    .map((item) => (typeof item === 'string' ? item : item?.name || item?.productName || ''))
    .filter((name): name is string => Boolean(name));
};

const ProductTransactionPage: React.FC = () => {
  const [from, setFrom] = useState(today());
  const [to, setTo] = useState(today());
  const [term, setTerm] = useState('');
  const [hits, setHits] = useState<string[]>([]);
  const [prod, setProd] = useState<Hit | null>(null);
  const [rows, setRows] = useState<Row[] | null>(null);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const timer = useRef<number | null>(null);

  const searchProd = (q: string) => {
    setTerm(q);
    setProd(null);
    if (timer.current) window.clearTimeout(timer.current);
    if (!q.trim()) {
      setHits([]);
      return;
    }
    timer.current = window.setTimeout(async () => {
      try {
        const res: any = await billingApi.searchProducts(q.trim());
        setHits(productNames(res?.data));
      } catch {
        setHits([]);
      }
    }, 250);
  };

  const selectProd = async (name: string) => {
    setTerm(name);
    setHits([]);
    try {
      const res: any = await billingApi.productByName(name);
      const p = res?.data;
      if (!p?.id) {
        toast.warning('Product not found.');
        setProd(null);
        return;
      }
      setProd({ id: p.id, name: p.name || name });
    } catch {
      setProd(null);
      toast.error('Could not load product');
    }
  };

  const search = async (p = 0) => {
    if (term.trim() && !prod) {
      toast.warning('Please select a product from the list, or clear the field for all products.');
      return;
    }
    try {
      const pg = stockPage<Row>(await stockApi.transactions(
        from, to, prod?.id, p, DEFAULT_PAGE_SIZE,
      ));
      setRows(pg.items);
      setTotal(pg.total);
      setPage(p);
    } catch (err) {
      toast.error(stockError(err, 'Could not load report'));
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title no-print"><i className="fas fa-exchange-alt" /> Product Transaction</h2>
      <div className="mst-card no-print" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form">
          <div className="mst-fg"><label>From Date</label><input className="mst-inp" type="date" value={from} onChange={(e) => setFrom(e.target.value)} /></div>
          <div className="mst-fg"><label>To Date</label><input className="mst-inp" type="date" value={to} onChange={(e) => setTo(e.target.value)} /></div>
          <div className="mst-fg crd-search-wrap">
            <label>Product</label>
            <input
              className="mst-inp"
              value={term}
              placeholder="All products — type name or code"
              onChange={(e) => searchProd(e.target.value)}
            />
            {hits.length > 0 && (
              <ul className="crd-dropdown">
                {hits.map((name) => (
                  <li key={name} onClick={() => { void selectProd(name); }}>{name}</li>
                ))}
              </ul>
            )}
            {prod && <span className="mst-note">Selected: {prod.name}</span>}
          </div>
          <div className="mst-actions">
            <button className="mst-btn mst-btn-primary" type="button" onClick={() => search(0)}>Generate Report</button>
            <button className="mst-btn mst-btn-outline" type="button" onClick={() => { setTerm(''); setProd(null); setHits([]); }}>Clear</button>
            <ReportActions
              disabled={!rows}
              filename={`Product_Transaction_${from}_${to}`}
              sheets={[{
                name: 'Transactions',
                columns: [
                  { key: 'productName', label: 'Product' }, { key: 'stockIn', label: 'Stock in', num: true },
                  { key: 'stockOut', label: 'Stock out', num: true }, { key: 'stockNow', label: 'Stock now', num: true },
                  { key: 'notes', label: 'Notes' }, { key: 'dateTime', label: 'Date/Time' },
                  { key: 'userName', label: 'User' },
                ],
                rows: rows || [],
              }]}
            />
          </div>
        </div>
      </div>
      {rows && (
        <div className="mst-card">
          <div className="mst-card-h">Period: {from} to {to}{prod ? ` · ${prod.name}` : ' · All products'}</div>
          <div className="mst-table-wrap">
            <table className="mst-table">
              <thead>
                <tr>
                  <th>#</th><th>Product</th><th className="num">Stock in</th><th className="num">Stock out</th>
                  <th className="num">Stock now</th><th>Notes</th><th>Date/Time</th><th>Stock Adj</th><th>User</th>
                </tr>
              </thead>
              <tbody>
                {rows.length === 0 && <tr><td colSpan={9} className="mst-empty">No transactions.</td></tr>}
                {rows.map((row, i) => (
                  <tr key={`${row.dateTime}-${i}`}>
                    <td>{page * DEFAULT_PAGE_SIZE + i + 1}</td>
                    <td>{row.productName}</td>
                    <td className={`num ${row.stockIn > 0 ? 'st-in' : ''}`}>{row.stockIn} {row.unit}</td>
                    <td className={`num ${row.stockOut > 0 ? 'st-out' : ''}`}>{row.stockOut} {row.unit}</td>
                    <td className="num">{row.stockNow} {row.unit}</td>
                    <td>{row.notes}</td>
                    <td>{row.dateTime}</td>
                    <td>{row.adjType === 1 ? 'Added' : row.adjType === 2 ? 'Removed' : '—'}</td>
                    <td>{row.userName}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <ListPagination page={page} size={DEFAULT_PAGE_SIZE} total={total} onChange={(p) => search(p)} />
        </div>
      )}
    </div>
  );
};

export default ProductTransactionPage;
