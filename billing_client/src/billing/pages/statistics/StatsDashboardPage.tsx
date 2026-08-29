import React, { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import { statsApi, statsData, statsError } from '../../../api/statistics/statistics-api-service';
import '../master/Master.css';
import './Stats.css';

type Day = { date: string; sales: number; purchase: number };
type Dash = {
  year: number; month: number; label: string;
  sales: number; lastSales: number; salesPct: number;
  purchase: number; lastPurchase: number; purchasePct: number;
  expense: number; lastExpense: number; expensePct: number;
  profit: number; lastProfit: number; profitPct: number;
  netProfit: number; todaySales: number; todayBills: number; daily: Day[];
};

const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const n = (v?: number) => Number(v || 0).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const trend = (pct: number, last: number) => last === 0 ? '— No prev. data' : `${pct >= 0 ? '▲' : '▼'} ${Math.abs(pct).toFixed(1)}% vs last month`;

const StatsDashboardPage: React.FC = () => {
  const now = new Date();
  const [year, setYear] = useState(now.getFullYear());
  const [month, setMonth] = useState(now.getMonth() + 1);
  const [data, setData] = useState<Dash | null>(null);

  const load = async (y = year, m = month) => {
    try {
      setData(statsData<Dash>(await statsApi.dashboard(y, m)));
    } catch (err) {
      toast.error(statsError(err, 'Could not load dashboard'));
    }
  };

  useEffect(() => { load(); }, []);

  const years = Array.from({ length: 6 }, (_, i) => now.getFullYear() + 1 - i);
  const maxVal = Math.max(1, ...(data?.daily || []).flatMap((d) => [d.sales, d.purchase]));

  return (
    <div className="mst-page">
      <h2 className="mst-title"><i className="fas fa-chart-line" /> Dashboard</h2>
      <div className="mst-card" style={{ marginBottom: 12 }}>
        <div className="mst-card-b mst-form">
          <div className="mst-fg">
            <label>Year</label>
            <select className="mst-sel" value={year} onChange={(e) => setYear(Number(e.target.value))}>
              {years.map((y) => <option key={y} value={y}>{y}</option>)}
            </select>
          </div>
          <div className="mst-fg">
            <label>Month</label>
            <select className="mst-sel" value={month} onChange={(e) => setMonth(Number(e.target.value))}>
              {months.map((name, i) => <option key={name} value={i + 1}>{name}</option>)}
            </select>
          </div>
          <div className="mst-actions">
            <button className="mst-btn mst-btn-primary" type="button" onClick={() => load()}>Load</button>
            {(year !== now.getFullYear() || month !== now.getMonth() + 1) && (
              <button className="mst-btn mst-btn-outline" type="button" onClick={() => { setYear(now.getFullYear()); setMonth(now.getMonth() + 1); load(now.getFullYear(), now.getMonth() + 1); }}>Current Month</button>
            )}
          </div>
        </div>
      </div>
      {data && (
        <>
          <div className="st-kpis">
            <div className="st-kpi sales"><div className="st-kpi-l">Total Sales</div><div className="st-kpi-v">₹ {n(data.sales)}</div><div className="st-kpi-t">{trend(data.salesPct, data.lastSales)}</div></div>
            <div className="st-kpi purchase"><div className="st-kpi-l">Total Purchase</div><div className="st-kpi-v">₹ {n(data.purchase)}</div><div className="st-kpi-t">{trend(data.purchasePct, data.lastPurchase)}</div></div>
            <div className="st-kpi expense"><div className="st-kpi-l">Total Expense</div><div className="st-kpi-v">₹ {n(data.expense)}</div><div className="st-kpi-t">{trend(data.expensePct, data.lastExpense)}</div></div>
            <div className={`st-kpi profit ${data.netProfit >= 0 ? 'up' : 'down'}`}><div className="st-kpi-l">Net Profit</div><div className="st-kpi-v">₹ {n(data.netProfit)}</div><div className="st-kpi-t">{trend(data.profitPct, data.lastProfit)}</div></div>
          </div>
          <div className="mst-note" style={{ marginBottom: 10 }}>Today: ₹ {n(data.todaySales)} across {data.todayBills} bills · Showing {data.label}</div>
          <div className="mst-card">
            <div className="mst-card-h">Daily Sales vs Purchase — {data.label}</div>
            <div className="mst-card-b">
              {(data.daily || []).map((d) => (
                <div className="st-day" key={d.date}>
                  <span>{d.date}</span>
                  <div>
                    <div className="st-day-bar s"><i style={{ width: `${(d.sales / maxVal) * 100}%` }} /></div>
                    <div className="mst-note" style={{ margin: '2px 0 0' }}>Sales ₹ {n(d.sales)}</div>
                  </div>
                  <div>
                    <div className="st-day-bar p"><i style={{ width: `${(d.purchase / maxVal) * 100}%` }} /></div>
                    <div className="mst-note" style={{ margin: '2px 0 0' }}>Purchase ₹ {n(d.purchase)}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default StatsDashboardPage;
