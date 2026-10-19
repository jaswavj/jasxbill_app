import React, { useState } from 'react';
import { toast } from 'react-toastify';
import { adminApi, adminError, adminPage } from '../../../api/admin/admin-api-service';
import ListPagination, { DEFAULT_PAGE_SIZE } from '../../components/ListPagination';
import '../master/Master.css';
import '../BillingPage.css';

type Row = {
  id: number;
  billId: number;
  billNo: string;
  action: string;
  details: string;
  date: string;
  time: string;
  userName: string;
};

const today = () => new Date().toISOString().slice(0, 10);

const actionLabel = (action?: string) => {
  const value = (action || '').toUpperCase();
  if (value === 'EDIT') return 'Edited';
  if (value === 'CANCEL') return 'Cancelled';
  if (value === 'DATE_CHANGE') return 'Date changed';
  if (value === 'PAYMENT_CHANGE') return 'Payment changed';
  return action || '-';
};

const EditLogPage: React.FC = () => {
  const [from, setFrom] = useState(today());
  const [to, setTo] = useState(today());
  const [rows, setRows] = useState<Row[] | null>(null);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [open, setOpen] = useState<Row | null>(null);

  const search = async (p = 0) => {
    try {
      const pg = adminPage<Row>(await adminApi.editLog(from, to, p, DEFAULT_PAGE_SIZE));
      setRows(pg.items);
      setTotal(pg.total);
      setPage(p);
    } catch (err) {
      toast.error(adminError(err, 'Could not load edit log'));
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title"><i className="fas fa-history" /> Edit Log</h2>
      <div className="mst-card" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form">
          <div className="mst-fg"><label>From Date</label><input className="mst-inp" type="date" value={from} onChange={(e) => setFrom(e.target.value)} /></div>
          <div className="mst-fg"><label>To Date</label><input className="mst-inp" type="date" value={to} onChange={(e) => setTo(e.target.value)} /></div>
          <div className="mst-actions">
            <button className="mst-btn mst-btn-primary" type="button" onClick={() => search(0)}>Generate</button>
          </div>
        </div>
      </div>
      {rows && (
        <div className="mst-card">
          <div className="mst-card-h">Edits and cancellations from {from} to {to} ({total})</div>
          <div className="mst-table-wrap">
            <table className="mst-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Bill No</th>
                  <th>Action</th>
                  <th>Details</th>
                  <th>Date</th>
                  <th>Time</th>
                  <th>User</th>
                </tr>
              </thead>
              <tbody>
                {rows.length === 0 && <tr><td colSpan={7} className="mst-empty">No edits or cancellations in this period.</td></tr>}
                {rows.map((row, i) => (
                  <tr
                    key={row.id || `${row.billNo}-${i}`}
                    className="mst-click-row"
                    onClick={() => setOpen(row)}
                  >
                    <td>{page * DEFAULT_PAGE_SIZE + i + 1}</td>
                    <td>{row.billNo}</td>
                    <td>{actionLabel(row.action)}</td>
                    <td>{row.details}</td>
                    <td>{row.date}</td>
                    <td>{row.time}</td>
                    <td>{row.userName}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <ListPagination page={page} size={DEFAULT_PAGE_SIZE} total={total} onChange={(p) => search(p)} />
        </div>
      )}
      {open && (
        <div className="pos-modal-back" onClick={() => setOpen(null)}>
          <div className="pos-modal" style={{ width: 'min(560px, 100%)' }} onClick={(e) => e.stopPropagation()}>
            <div className="pos-modal-head">
              <h4>Edit log — {open.billNo || '-'}</h4>
              <button className="pos-btn pos-btn-outline" type="button" onClick={() => setOpen(null)}>Close</button>
            </div>
            <div className="mst-form one-col">
              <div className="mst-fg"><label>Bill No</label><input className="mst-inp" readOnly value={open.billNo || '-'} /></div>
              <div className="mst-fg"><label>Action</label><input className="mst-inp" readOnly value={actionLabel(open.action)} /></div>
              <div className="mst-fg"><label>Date</label><input className="mst-inp" readOnly value={open.date || '-'} /></div>
              <div className="mst-fg"><label>Time</label><input className="mst-inp" readOnly value={open.time || '-'} /></div>
              <div className="mst-fg"><label>User</label><input className="mst-inp" readOnly value={open.userName || '-'} /></div>
              <div className="mst-fg">
                <label>Details</label>
                <textarea className="mst-area" readOnly rows={6} value={open.details || '-'} style={{ whiteSpace: 'pre-wrap' }} />
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default EditLogPage;
